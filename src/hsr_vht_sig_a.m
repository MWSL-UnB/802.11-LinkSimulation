function [Nss_VHT_SIGNAL_A_2] = hsr_vht_sig_a()


global c_sim

Ntail = 6;
Nbits = 24;

VHTSIGA1 = randi([0,1],[1,Nbits]);
VHTSIGA2 = randi([0,1],[1,Nbits]);
tail = zeros(1,Ntail);
VHTSIGA2 = [VHTSIGA2(1:(Nbits - Ntail)) tail];

%BCC encoder
codetrellis = poly2trellis(7,[133,171]);
VHTSIGA1_2 = convenc(VHTSIGA1,codetrellis);
VHTSIGA2_2 = convenc(VHTSIGA2,codetrellis);

%interleaver
sim_param = hsr_drate_param(0,true);
%[~,modulation,Nbpsc,~,~,Ncbps] = mcs_rates('802.11a',0,'long',20,48,1,4);
VHTSIGA1_3 = hsr_interleaver('802.11a',20,sim_param.Ncbps,sim_param.Nbpsc,1,1,VHTSIGA1_2);
VHTSIGA2_3 = hsr_interleaver('802.11a',20,sim_param.Ncbps,sim_param.Nbpsc,1,1,VHTSIGA2_2);
        
% map
Kmod = hsr_gain(sim_param.modulation);
mapping1 = hsr_map(VHTSIGA1_3,sim_param.modulation);
VHTSIGA1_4 = Kmod*mapping1;
mapping2 = hsr_map(VHTSIGA2_3,sim_param.modulation);
VHTSIGA2_4 = Kmod*mapping2;
 
%load subcarriers with signal data and pilots
tmp1 = zeros(1,c_sim.legacy.Nfft);
tmp2 = zeros(1,c_sim.legacy.Nfft);
tmp1(c_sim.legacy.c_ps_index) = VHTSIGA1_4;
tmp2(c_sim.legacy.c_ps_index) = VHTSIGA2_4;

% rotate the second group of bits 90 degrees relative to the first symbol 
tmp2 = 1i*tmp2;

% pilot insertion
tmp1(c_sim.legacy.pilot_index) = c_sim.legacy.pilot;
tmp2(c_sim.legacy.pilot_index) = c_sim.legacy.pilot;

VHTSIGA1_5 = tmp1;
VHTSIGA2_5 = tmp2;

VHTSIGA1_6 = fftshift(VHTSIGA1_5);
VHTSIGA2_6 = fftshift(VHTSIGA2_5);

VHT_SIGNAL_A = [VHTSIGA1_6 VHTSIGA2_6];

%replicate over multiple 20 MHz channels
switch c_sim.w_channel
    case 20
        N = 1;
    case 40
        N = 2;
    case 80
        N = 4;
    case 160
        N = 8;
end

VHT_SIGNAL_A = repmat(VHT_SIGNAL_A,1,N);

%phase rotation
% i = 1:N;
% Kshift = 32*(N - 1 - 2*(i - 1));
%VHT_SIGNAL_A_3 = phase_rotation(c_sim.w_channel,VHT_SIGNAL_A_2);
    
% generate time data samples
L = length(VHT_SIGNAL_A);
VHT_SIGNAL_A = ifft(VHT_SIGNAL_A)*sqrt(L);

%support for multiple antennas
Ntx = c_sim.antennas(1);

% cyclic shift for multiple antenna
cs = hsr_cyclic_shift('legacy',Ntx);
    
shiftsamps = zeros(1,Ntx);
Nss_VHT_SIGNAL_A = zeros(Ntx,L);
    
for k = 1:Ntx
    shiftsamps(k) = (cs(k)*c_sim.sampling_freq)/1e9;
    Nss_VHT_SIGNAL_A(k,:) = circshift(VHT_SIGNAL_A,[0,shiftsamps(k)]);
end

%VHT-SIG-A is a 8 us field
L = size(Nss_VHT_SIGNAL_A,2);
Tg = Nss_VHT_SIGNAL_A(:,(L/2) + (L/4) + 1:end);
Nss_VHT_SIGNAL_A_2 = [Tg Nss_VHT_SIGNAL_A];
end