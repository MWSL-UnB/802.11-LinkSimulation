function [HTSTF] = hsr_ht_stf()

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
         
HTSTF = sqrt(1/2)*[0 0 0 0 0 0 LSTFleft 0 LSTFright 0 0 0 0 0];

switch channel
    case 20
        N = 1;
    case 40
        N = 2;
end

HTSTF = repmat(HTSTF,[1,N]);

L = length(HTSTF);

% phase rotation
HTSTF = fftshift(HTSTF);
HTSTF = hsr_phase_rotation('transmission',HTSTF.');
HTSTF = HTSTF.';
    
%support for multiple antennas
Ntx = antenna_array(1);
    
% cyclic shift for multiple antennas
cs = hsr_cyclic_shift('HT',Ntx);
    
shiftsamps = zeros(1,Ntx);
Nss_HTSTF = zeros(Ntx,L);
    
for k = 1:Ntx
    shiftsamps(k) = cs(k)*sampling_freq;
    shiftsamps(k) = 1e-9*shiftsamps(k);
    Nss_HTSTF(k,:) = circshift(HTSTF,[0,shiftsamps(k)]);
end

% generate time data samples
L = size(Nss_HTSTF,2);
Nss_HTSTF = ifft(Nss_HTSTF)*sqrt(L);

%HT-STF is a 4 us field
L = size(Nss_HTSTF,2);
Tg = Nss_HTSTF(:,(L/2) + (L/4) + 1:end);
HTSTF = [Tg Nss_HTSTF];


end

