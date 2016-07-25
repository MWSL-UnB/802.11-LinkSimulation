function [HTSIGNAL] = hsr_ht_sig()

global c_sim

channel = c_sim.w_channel;
antenna_array = c_sim.antennas;

% HT-SIF field for IEEE 802.11n; 48 bits
% MCS
% switch streams
%     case 1
%         MCS = Txvector_rate;
%     case 2
%         MCS = Txvector_rate + 8;
%     case 3
%         MCS = Txvector_rate + 16;
%     case 4
%         MCS = Txvector_rate + 24;
%     otherwise
%         error('modulation coding scheme unknown');
% end
% 
% MCS_binary = de2bi(MCS,7);
% 
% %bandwidth
% switch channel
%     case 20
%         CBW = 0;
%     case 40
%         CBW = 1;
% end
% 
% %PSDU length
% psdu_binary = de2bi(psdu,16);
% 
% %smoothing
% 
% %not sounding
% 
% %reserved
% reserved = 1;
% 
% %aggregation
% 
% %STBC
% switch (Nsts - streams)
%     case 1
%         STBC = [1 0];
%     case 2
%         STBC = [0 1];
%     otherwise
%         STBC = [0 0];
% end
% 
% %encoder
% if strcmp(encoder,'BCC')
%     FEC = 0;
% elseif strcmp(encoder,'LDPC')
%     FEC = 1;
% end
% 
% if strcmp(cyclic_prefix,'long')
%     short_gi = 0;
% elseif strcmp(cyclic_prefix,'short')
%     short_gi = 1;
% end
% 
% %Number of extension spation streams
% switch Ness
%     case 0
%         NESS = [0 0];
%     case 1
%         NESS = [1 0];
%     case 2
%         NESS = [0 1];
%     case 3
%         NESS = [1 1];
% end
% 
% %CRC
% 
% %Tail bits
% Tail = zeros(1,Nservice);

Ntail = 6;
Nbits = 24;

HTSIG1 = randi([0,1],1,Nbits);
HTSIG2 = randi([0,1],1,Nbits);
tail = zeros(1,Ntail);
HTSIG2 = [HTSIG2(1:(Nbits - Ntail)) tail];

%BCC encoder
codetrellis = poly2trellis(7,[133,171]);
HTSIG1 = convenc(HTSIG1,codetrellis);
HTSIG2 = convenc(HTSIG2,codetrellis);

%interleaver
mcs =  hsr_drate_param(0,true);
HTSIG1 = hsr_interleaver('802.11a',20,mcs.Ncbps,mcs.Nbpsc,1,1,HTSIG1);
HTSIG2 = hsr_interleaver('802.11a',20,mcs.Ncbps,mcs.Nbpsc,1,1,HTSIG2);

% map
Kmod = hsr_gain(mcs.modulation);
mapping1 = hsr_map(HTSIG1,mcs.modulation);
HTSIG1 = Kmod*mapping1;
mapping2 = hsr_map(HTSIG2,mcs.modulation);
HTSIG2 = Kmod*mapping2;

%load subcarriers with signal data and pilots
tmp1 = zeros(1,c_sim.legacy.Nfft);
tmp2 = zeros(1,c_sim.legacy.Nfft);
tmp1(c_sim.legacy.c_ps_index) = HTSIG1;
tmp2(c_sim.legacy.c_ps_index) = HTSIG2;

% rotate constellation by 90º relative to L-SIG
tmp1 = 1i*tmp1;
tmp2 = 1i*tmp2;

% pilot insertion
tmp1(c_sim.legacy.pilot_index) = c_sim.legacy.pilot;
tmp2(c_sim.legacy.pilot_index) = c_sim.legacy.pilot;

HTSIG1 = tmp1;
HTSIG2 = tmp2;

HTSIGNAL = [HTSIG1 HTSIG2];

switch c_sim.w_channel
    case 20
        N = 1;
    case 40
        N = 2;
    otherwise
        error('Invalid bandwidth for 802.11n')
end

HTSIGNAL = repmat(HTSIGNAL,[1,N]);
L = length(HTSIGNAL);

% phase rotation on the upper subcarriers to avoid PAPR
if channel == 40
    HTSIGNAL = [1i*HTSIGNAL(1:(L/2)) HTSIGNAL((L/2) + 1:end)];
end

%support for multiple antennas
Ntx = antenna_array(1);
    
% cyclic shift for multiple antennas
cs = hsr_cyclic_shift('HT',Ntx);
    
shiftsamps = zeros(1,Ntx);
Nss_HT_SIGNAL = zeros(Ntx,L);
    
for k = 1:Ntx
    shiftsamps(k) = cs(k)*c_sim.sampling_freq;
    shiftsamps(k) = 1e-9*shiftsamps(k);
    Nss_HT_SIGNAL(k,:) = circshift(HTSIGNAL,[0,shiftsamps(k)]);
end

% generate time data samples
L = size(Nss_HT_SIGNAL,2);
Nss_HT_SIGNAL = ifft(Nss_HT_SIGNAL)*sqrt(L);
    
%HT-SIG is a 4 us field
L = size(Nss_HT_SIGNAL,2);
Tg = Nss_HT_SIGNAL(:,L - (L/4) + 1:end);
HTSIGNAL = [Tg Nss_HT_SIGNAL];


end

