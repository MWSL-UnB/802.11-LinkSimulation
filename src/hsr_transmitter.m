function [data_out,output,feed,ldpc] = hsr_transmitter(p_TXVECTOR,PSDU)
%HSR_TRANSMITTER Transmitter for IEEE 802.11a/n
%
% [DATA, SCR_INIT, LDPC_PCM] = HSR_TRANSMITTER(TXVECTOR,PSDU,TX_ANT)
%   outputs in DATA a PHY burst defined by the struct TXVECTOR, which has the
%   following fields:
%      .LENGTH      number of bytes per packet/ofdm frame
%      .DATARATE    data rate index, see hsr_drate_param.m
%      .SERVICE     SERVICE field, e.g. [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
%      .TXPWR_LEVEL TX power level 1..8 (not implemented yet) 
%   ,by PSDU, the data unit (vector with binary elements)
%   DATA consists of short and long preambles, SIGNAL field and data.
%   SCR_INIT contains the scrambler initialization state.
%   LDPC is a struct containing the LDPC parity check matrix and other LDPC
%   encoder parameters if LDPC code is employed, empty matrix otherwise.

%History:
%  Andre Noll Barreto  25.07.2001  created
%                      26.10.2010  encoding using Matlab functions
%                      07.01.2014  remove antenna diversity 
%                                  MIMO
% import basic simulation parameters
global c_sim;

version = c_sim.version;
channel = c_sim.w_channel;
stbc = c_sim.stbc;
Ntail = c_sim.bcc_tail;
Nservice = c_sim.service_length;
psdu_length = p_TXVECTOR.length;
Service = p_TXVECTOR.service;
encoder = c_sim.encoder;
Nss = c_sim.n_streams;
Nsd = c_sim.Nsd;
antenna_array = c_sim.antennas;
sampling_freq = c_sim.sampling_freq;
Tcp = c_sim.cp_length;
Nsts = c_sim.n_sts;
timedom_windowing = c_sim.timedomwindowing;

%persistent codetrellis

%short preamble
LSTF = hsr_preamble_s();

%long preamble
LLTF = hsr_preamble_l();
data_out = [LSTF LLTF];

sim_param = hsr_drate_param(p_TXVECTOR.datarate);  

%SIGNAL field
LSIG = hsr_signal();
data_out = [data_out LSIG];

if strcmp(version,'802.11n')
    % include HT-Signal fields
    HTSIGNAL = hsr_ht_sig();
    data_out = [data_out HTSIGNAL];
    
    HTSTF = hsr_ht_stf();
    data_out = [data_out HTSTF];
    
    NHTLTF = hsr_preamble_ht_l();
    data_out = [data_out NHTLTF];
    
elseif strcmp(version, '802.11ac')
    % include VHT-Signal fields
    VHTSIGA = hsr_vht_sig_a();
    VHTSTF = hsr_vht_stf();
    NVHTLTF = hsr_vht_ltf();
    VHTSIGB = hsr_vht_sig_b();
    data_out = [data_out VHTSIGA VHTSTF NVHTLTF VHTSIGB];
end

% data
Ndbps = sim_param.Ndbps;
Ncbps = sim_param.Ncbps;
Nbpsc = sim_param.Nbpsc;
Nes = sim_param.Nes;
code_rate = sim_param.code_rate;
modulation = sim_param.modulation;

payload = Nservice + 8*psdu_length + Ntail*Nes;
Nsym = (stbc + 1)*ceil(payload/((stbc + 1)*Ndbps)); % number of OFDM symbols
Npad = Nsym*Ndbps - payload; % number of pad bits
Pad = zeros(1,Npad);

if strcmp(encoder,'BCC')
    Tail = zeros(1,Ntail*Nes);
    Data = [Service PSDU Tail Pad];
else strcmp(encoder,'LDPC')
    Data = [Service PSDU Pad];
end

%scrambler
feed = randi([0,126],1);
Data2 = hsr_scrambler(feed,Data);

if strcmp(encoder,'BCC')
    ldpc = [];
    
    % BCC encoder parsing
    if ~strcmp(version,'802.11a')
        Data3 = hsr_encoder_parser(Nes,Nsym,Ndbps,Data2);
    else
        Data3 = Data2;
    end
    
    % zero tail bits before BCC encoding
    if ~strcmp(version,'802.11ac')
        Tail_index = (Nservice + 8*psdu_length)/Nes;
        Data3(:,Tail_index + 1:Tail_index + 6) = 0;
    end
    
    % BCC encoder
    codetrellis = poly2trellis(7,[133,171]);
    Data4 = zeros(Nes,2*size(Data3,2));
    Data5 = zeros(Nes,size(Data3,2)/code_rate);
    for n = 1:Nes
        % BCC encoder
        Data4(n,:) = convenc(Data3(n,:),codetrellis);

        % puncture
        Data5(n,:) = hsr_puncture(code_rate,Data4(n,:));
    end
    
elseif strcmp(encoder,'LDPC')
    
    [Data5,ldpc]  = hsr_ldpc_enc(Data2,p_TXVECTOR);
    Nsym = length(Data5)/Ncbps;
    
end

% Stream parser
if ~strcmp(version,'802.11a')
    Data6 = hsr_stream_parser(Nbpsc,Ncbps,Nes,Data5);
else
    Data6 = Data5;
end

% Segment parser
if strcmp(version,'802.11ac')
    Data7 = hsr_segment_parser('transmission',Nbpsc,Nes,Data6);
else
    Data7 = Data6;
end

% Frequency interleaver
if strcmp(encoder,'BCC')
    Data8 = hsr_interleaver(version,channel,Ncbps,Nbpsc,Nss,Nsym,Data7);
elseif strcmp(encoder,'LDPC')
    Data8 = Data7;
end

% segment deparser
if strcmp(version,'802.11ac')
    Data9 = hsr_segment_deparser('transmission',Nes,Nbpsc,Data8);
else
    Data9 = Data8;
end

% Constellation mapping
Kmod = hsr_gain(modulation);
mapping = zeros(Nss,size(Data9,2)/Nbpsc);
Data10 = zeros(Nss,size(Data9,2)/Nbpsc);
for n = 1:Nss
    mapping(n,:) = hsr_map(Data9(n,:),modulation);
    Data10(n,:) = Kmod*mapping(n,:);
end

Data11 = zeros(Nsd,Nsym,Nss);
for i = 1:Nss
    for n = 1:Nsym
        Data11(1:Nsd,n,i) = Data10(i,(n - 1)*Nsd + 1:n*Nsd);
    end
end

% Alamouti coding
if stbc == true
    Data12 = hsr_alamouti_coding(Nsym,Data11);
else
    Data12 = Data11;    %Nsts = Nss
end

% data and pilot insertion
pilot = hsr_pilot(Nsym);
Data13 = hsr_subcload(Data12,pilot);

% Phase rotation to avoid PAPR
Data14 = hsr_phase_rotation('transmission',Data13);

% cyclic shift for multiple antenna
Ntx = antenna_array(1);
Nrx = antenna_array(2);
if Ntx == Nrx
    if strcmp(version,'802.11a')
        cs = 0;
    elseif strcmp(version,'802.11n')
        cs = hsr_cyclic_shift('HT',Ntx);
    elseif strcmp(version,'802.11ac')
        cs = hsr_cyclic_shift('VHT',Ntx);
    end

    shiftsamps = zeros(1,Ntx);
    Data15 = zeros(size(Data14));
    for k = 1:Ntx
        shiftsamps(k) = cs(k)*sampling_freq;
        shiftsamps(k) = 1e-9*shiftsamps(k);
        Data15(:,:,k) = circshift(Data14(:,:,k),shiftsamps(k));
    end
else
    Data15 = Data14;
end

% IDFT
L = size(Data14,1);
Data16 = ifft(Data15)*sqrt(L);

% prepend cyclic prefix
Tg = Data16(L - Tcp + 1:L,:,:);
Data17 = [Tg ; Data16];

L = size(Data17,1);
Data18 = zeros(Nsts,L*Nsym);
for i = 1:Nsts
    for n = 1:Nsym
        Data18(i,(n - 1)*L + 1:n*L) = Data17(1:L,n,i);
    end
end

if (strcmp(timedom_windowing,'on') == 1)
    Data19 = windowing('execute',Data18);
else
    Data19 = Data18;
end

output = Data19;

data_out = [data_out output];

% if strcmp (c_sim.encoder,'BCC')  %convolutional encoder
%     
%     nbits = c_sim.service_length + 8*p_TXVECTOR.length + c_sim.bcc_tail*Nes;
%     Nsym = (c_sim.stbc + 1)*ceil(nbits/((c_sim.stbc + 1)*Ndbps)); % number of OFDM symbols
%     Npad = Nsym*p_Ndbps - nbits; % number of pad bits
%     tail = zeros(1,6*p_Nes);
%     pad = zeros(1,Npad);
%     
%     % add service, tail and pad bits
%     x = [p_TXVECTOR.service PSDU tail pad];
%     
%     %scrambler
%     scr_init = randi([0,126],1);
%     x = hsr_scrambler(scr_init,x);
%     
%     % encoder parser
%     if ~strcmp(c_sim.version,'802.11a')
%         x = hsr_encoder_parser(p_Nes,p_Nsym,p_Ndbps,x);
%     end
%     
%     %zero tail bits after scrambling
%     if ~strcmp(c_sim.version,'802.11ac')
%         tail_index = (c_sim.service_length + 8*p_TXVECTOR.length)/p_Nes;
%         x(:,tail_index + 1:tail_index + 6) = 0;
%     end
%     
%     % BCC encoder
%     codetrellis = poly2trellis(7,[133,171]);
%     x = convenc(x,codetrellis);
%     % puncture
%     %x = hsr_puncture(sim_param.code_rate,x);
%     for n = 1:p_Nes
%         x(n,:) = convenc(x(n,:),codetrellis);
%     
%         % puncture
%         x(n,:) = hsr_puncture(sim_param.code_rate,x(n,:));
%     end
%     
%     % stream parser
%     if ~strcmp(c_sim.version,'802.11a')
%         x = hsr_stream_parser(p_Nbpsc,p_Ncbps,p_Nes,x);
%     end
%     
%     % segment parser
%     if c_sim.w_channel == 160
%         x = hsr_segment_parser('uplink',p_Nbpsc,p_Nes,x);
%     end
%     
%     % interleaver
%     x = hsr_interleaver(c_sim.version,c_sim.w_channel,p_Ncbps,p_Nbpsc,c_sim.n_streams,p_Nsym,x);
%     
%     ldpc = [];
%     
% elseif strcmp(c_sim.encoder,'LDPC')
%     
%     x = [p_TXVECTOR.service p_PSDU];
% 
%     %scrambler
%     scr_init = randi([0,126],1);
%     
%     x = hsr_scrambler(scr_init,x);
%    
%     [x,ldpc]  = hsr_ldpc_enc(x,p_TXVECTOR);
%     p_Nsym = length(x)/p_Ncbps;
%     
%     % stream parser
%     x = hsr_stream_parser(p_Nbpsc,p_Ncbps,p_Nes,x);
%     
%     % segment parser
%     if strcmp(c_sim.version,'802.11ac')
%         x = hsr_segment_parser(p_Nbpsc,p_Nes,x);
%     end
% end
% 
% % constellation mapping
% Kmod = hsr_gain(sim_param.modulation);
% mapping = hsr_map(x,sim_param.modulation);
% x = Kmod*mapping;
% % Nsubblock = size(x,3);
% % mapping = zeros(c_sim.n_streams,size(x,2)/p_Nbpsc,Nsubblock);
% % for n = 1:c_sim.n_streams
% %     for l = 1:Nsubblock
% %         mapping(n,:,l) = hsr_map(x(n,:,l),sim_param.modulation);
% %         x(n,:,l) = Kmod*mapping(n,:,l);
% %     end
% % end
% 
% % segment deparser
% if c_sim.w_channel == 160
%     x = hsr_segment_deparser('uplink',p_Nes,p_Nbpsc,x);
% end
% 
% x = reshape(x,[c_sim.Nsd,p_Nsym,c_sim.n_streams]);
% %     for i = 1:c_sim.n_streams
% %         for n = 1:p_Nsym
% %             x(1:c_sim.Nsd,n,i) = x(i,(n - 1)*c_sim.Nsd + 1:n*c_sim.Nsd);
% %         end
% %     end
% 
% % load subcarriers with signal data and pilots
% pilot = hsr_pilot(p_Nsym);
% x = hsr_subcload(x,pilot);
% 
% % Space-Time Encoding
% if ~strcmp(c_sim.version,'802.11a')
%     if c_sim.stbc == true
%         x = hsr_alamouti(p_Nsym,x);
%     
%         % power normalization
%         x = x/sqrt(c_sim.stbc);
%     end
% end
% 
% Ntx = c_sim.antennas(1);
% 
% % cyclic shift for multiple antenna
% if strcmp(c_sim.version,'802.11a')
%     cs = 0;
% elseif strcmp(c_sim.version,'802.11n')
%     cs = hsr_cyclic_shift('HT',Ntx);
% elseif strcmp(c_sim.version,'802.11ac')
%     cs = hsr_cyclic_shift('VHT',Ntx);
% end
% 
% shiftsamps = zeros(1,Ntx);
% for k = 1:Ntx
%     shiftsamps(k) = cs(k)*c_sim.sampling_freq;
%     shiftsamps(k) = 1e-9*shiftsamps(k);
%     x(:,:,k) = circshift(x(:,:,k),shiftsamps(k));
% end
% 
% % IFFT
% x = ifft(x)*sqrt(N);
% 
% % cyclic extension
% Tg = x(N - c_sim.cp_length + 1:N,:,:);
% x = [Tg ; x];
% 
% L = size(x,1);
% x = reshape(x,[Ntx,L*p_Nsym]);
% %     for i = 1:c_sim.n_streams
% %         for n = 1:p_Nsym
% %             x(i,(n - 1)*L + 1:n*L) = x(1:L,n,i);
% %         end
% %     end
% 
% if (strcmp(c_sim.timedomwindowing,'on') == 1)
%     x = hsr_timewindow('execute',x);
% end;
% 
% data_out = [data_out x];
end
