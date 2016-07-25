function [VHTSTF] = hsr_vht_stf()

global c_sim

channel = c_sim.w_channel;
antenna_array = c_sim.antennas;
sampling_freq = c_sim.sampling_freq;

LSTFleft = [0 0 ...
            +1+1i 0 0 0 ...
            -1-1i 0 0 0 ...
            +1+1i 0 0 0 ...
            -1-1i 0 0 0 ...
            -1-1i 0 0 0 ...
            +1+1i 0 0 0];
LSTFright = [0 0 0 ...
             -1-1i 0 0 0 ...
             -1-1i 0 0 0 ...
             +1+1i 0 0 0 ...
             +1+1i 0 0 0 ...
             +1+1i 0 0 0 ...
             +1+1i 0 0];
         

VHTSTF = sqrt(1/2)*[0 0 0 0 0 0 LSTFleft 0 LSTFright 0 0 0 0 0];

switch channel
    case 20
        N = 1;
    case 40
        N = 2;
    case 80
        N = 4;
    case 160
        N = 8;
end

VHTSTF = repmat(VHTSTF,[1,N]);

L = length(VHTSTF);

%phase rotation
VHTSTF = fftshift(VHTSTF);
VHTSTF = hsr_phase_rotation('transmission',VHTSTF.');
VHTSTF = VHTSTF.';

%support for multiple antennas
Ntx = antenna_array(1);

cs = hsr_cyclic_shift('VHT',Ntx);

shiftsamps = zeros(1,Ntx);
Nss_VHTSTF = zeros(Ntx,L);
    
for k = 1:Ntx
    shiftsamps(k) = cs(k)*sampling_freq;
    shiftsamps(k) = 1e-9*shiftsamps(k);
    Nss_VHTSTF(k,:) = circshift(VHTSTF,[0,shiftsamps(k)]);
end

% generate time data samples
L = size(Nss_VHTSTF,2);
Nss_VHTSTF = ifft(Nss_VHTSTF)*sqrt(L);

%VHT-STF is a 4 us field
L = size(Nss_VHTSTF,2);
Tg = Nss_VHTSTF(:,(L/2) + (L/4) + 1:end);
VHTSTF = [Tg Nss_VHTSTF];

end

