function [Nss_VHTSIGB] = hsr_vht_sig_b()

global c_sim

channel = c_sim.w_channel;

if channel == 20
    psdu_binary = de2bi(c_sim.psdu_len,17);
    reserved = [1 1 1];
    tail = zeros(1,6);
elseif channel == 40
    psdu_binary = de2bi(c_sim.psdu_len,19);
    reserved = [1 1];
    tail = zeros(1,6);
elseif (channel == 80)||(channel == 160)
    psdu_binary = de2bi(c_sim.psdu_len,21);
    reserved = [1 1];
    tail = zeros(1,6);
end

VHTSIGB = [psdu_binary reserved tail];

if channel == 40
    VHTSIGB = repmat(VHTSIGB,[1,2]);
elseif channel == 80
    VHTSIGB = repmat(VHTSIGB,[1,4]);
    VHTSIGB = [VHTSIGB 0];
elseif channel == 160
    VHTSIGB = repmat(VHTSIGB,[1,4]);
    VHTSIGB = [VHTSIGB 0];
    VHTSIGB = repmat(VHTSIGB,[1,2]);
end

%BCC encoder
codetrellis = poly2trellis(7,[133,171]);
VHTSIGB = convenc(VHTSIGB,codetrellis);

sim_param = hsr_drate_param(0);
%[~,modulation,Nbpsc,~,~,~,Nes] = mcs_rates('802.11a',0,'long',20,48,1,4);

% segment parser
if channel == 160
    VHTSIGB = hsr_segment_parser('transmission',sim_param.Nbpsc,sim_param.Nes,VHTSIGB);
end

% interleaver
VHTSIGB = hsr_interleaver('802.11ac',channel,sim_param.Ncbps,sim_param.Nbpsc,1,1,VHTSIGB);

% segment deparser
if channel == 160
    VHTSIGB = hsr_segment_deparser('reception',sim_param.Nes,sim_param.Nbpsc,VHTSIGB);
end

% map
Kmod = hsr_gain(sim_param.modulation);
mapping = hsr_map(VHTSIGB,sim_param.modulation);
VHTSIGB = Kmod*mapping;

% data insertion
Nsts = c_sim.n_streams;
pilot_values = hsr_values_pilots();

channel_param = hsr_version_parameters();
Nfft = channel_param.Nfft;

temporary = zeros(1,Nfft);
temporary(channel_param.Nsd_index) = VHTSIGB;

% matrix mapping
if Nsts <= 4
    Pvhtltf = [1 -1 1 1;
               1 1 -1 1;
               1 1 1 -1;
               -1 1 1 1];
elseif (Nsts == 5)||(Nsts == 6)
    w = exp(-1i*(2*pi)/6);
    Pvhtltf = [1    -1      1       1       1       -1;
               1    -w^1    w^2     w^3     w^4     -w^5;
               1    -w^2    w^4     w^6     w^8     -w^10;
               1    -w^3    w^6     w^9     w^12    -w^15;
               1    -w^4    w^8     w^12    w^16    -w^20;
               1    -w^5    w^10    w^15    w^20    -w^25];
elseif Nsts > 6
    P_4 = [1 -1 1 1;
           1 1 -1 1;
           1 1 1 -1;
           -1 1 1 1];
           
    Pvhtltf = [P_4 P_4;
               P_4 P_4];
end

for n = 1:Nsts
    for k = 1:Nfft
        temporary(k) = Pvhtltf(n,1)*temporary(k);
    end
end

% pilot insertion
temporary(channel_param.Nsp_index) = pilot_values;

VHTSIGB = temporary;

% cyclic shift for multiple antenna
Ntx = c_sim.antennas(1);

cs = hsr_cyclic_shift('VHT',Ntx);
shiftsamps = zeros(1,Ntx);
Nss_VHTSIGB = zeros(Ntx,Nfft);

for k = 1:Ntx
     shiftsamps(k) = cs(k)*channel_param.sampling_freq;
     shiftsamps(k) = 1e-9*shiftsamps(k);
     Nss_VHTSIGB(k,:) = circshift(VHTSIGB,[0,round(shiftsamps(k))]);
end

% phase rotation and IDFT
Nss_VHTSIGB2 = zeros(Ntx,Nfft);
for k = 1:Ntx
    Nss_VHTSIGB(k,:) = hsr_phase_rotation('transmission',Nss_VHTSIGB(k,:).');
    Nss_VHTSIGB2(k,:) = ifft(Nss_VHTSIGB(k,:).');
end

% VHT-SIG-B is a 4 us field
Tg = Nss_VHTSIGB2(:,Nfft/2 + Nfft/4 + 1:Nfft);
Nss_VHTSIGB = [Tg Nss_VHTSIGB2];

end

