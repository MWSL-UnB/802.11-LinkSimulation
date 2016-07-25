function [NHTLTF] = hsr_preamble_ht_l()
% HSR_PREAMBLE_HT_L  HT long preamble (training data) for IEEE 802.11n  
%
%   Y = HSR_PREAMBLE_L ()
%     returns the long preamble in Y.


% Andre Noll Barreto, 14.01.02  created (based on work from Marley Matos)

global c_sim

channel = c_sim.w_channel;
antenna_array = c_sim.antennas;
sampling_freq = c_sim.sampling_freq;

% preamble in frequency domain

switch channel
    case 20
       HTLTF = [0 0 0 0 1 1 1 1 -1 -1 1 1 -1 1 -1 1 ...
                1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 ...
                0 1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 ...
                1 -1 -1 1 -1 1 -1 1 1 1 1 -1 1 0 0 0];
    case 40
        HTLTF = [0 0 0 0 0 0 1 1 -1 -1 1 1 -1 1 -1 1 1 1 ...
                 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 ...
                 -1 -1 1 1 -1 1 -1 1 1 -1 -1 -1 -1 -1 1 1 ...
                 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 -1 1 0 0 ...
                 0 -1 1 1 -1 1 1 -1 -1 1 1 -1 1 -1 1 1 ...
                 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 ...
                 1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 ...
                 -1 -1 1 -1 1 -1 1 1 1 1 0 0 0 0];
end

L = length(HTLTF);

% phase rotation
HTLTF = fftshift(HTLTF);
HTLTF = hsr_phase_rotation('transmission',HTLTF.');
HTLTF = HTLTF.';
    
%support for multiple antennas
Ntx = antenna_array(1);

% cyclic shift for multiple antenna
cs = hsr_cyclic_shift('HT',Ntx);

shiftsamps = zeros(1,Ntx);
Nss_HTLTF = zeros(Ntx,L);

for k = 1:Ntx
     shiftsamps(k) = cs(k)*sampling_freq;
     shiftsamps(k) = 1e-9*shiftsamps(k);
     Nss_HTLTF(k,:) = circshift(HTLTF,[0,shiftsamps(k)]);
end

% generate time data samples
L = size(Nss_HTLTF,2);
Nss_HTLTF = ifft(Nss_HTLTF)*sqrt(L);

%L-LTF is a 4 us field
L = size(Nss_HTLTF,2);
Tg = Nss_HTLTF(:,(L/2) + (L/4) + 1:end);
Nss_HTLTF = [Tg Nss_HTLTF];

% orthogonal mapping
P = [1 -1 1 1;
     1 1 -1 1;
     1 1 1 -1;
     -1 1 1 1];
 
NLTF = Ntx;
if Ntx == 3
   NLTF = 4;
end

L = size(Nss_HTLTF,2);
NHTLTF = zeros(Ntx,NLTF*L);

for k = 1:Ntx
    for n = 1:NLTF
        NHTLTF(k,(n - 1)*L + 1:n*L) = P(k,n)*Nss_HTLTF(k,:);
    end
end
%switch c_sim.w_channel
%     case 20
%         c_preamble = [0 0 0 0   1 1 1 1   -1 -1 1 1   -1 1 -1 1 ...
%                       1 1 1 1   1 -1 -1 1  1 -1 1 -1   1 1 1 1 ...
%                       0 1 -1 -1   1 1 -1 1   -1 1 -1 -1 -1 -1 -1 1 ...
%                       1 -1 -1 1   -1 1 -1 1   1 1 1 -1  1   0 0 0 ];
%     case 40
%         c_preamble = [0 0 0 0 0 0  1 1 -1 -1   1 1 -1 1   -1 1 1 1 ...
%                       1 1 1 -1  -1 1 1 -1   1 -1 1 1   1 1 1 1 ...
%                       -1 -1 1 1   -1 1 -1 1   1 -1 -1 -1   -1 -1 1 1 ...
%                       -1 -1 1 -1  1 -1 1 1  1 1 -1 -1  -1 1 0 0 ...
%                       0 -1 1 1   -1 1 1 -1   -1 1 1 -1   1 -1 1 1 ...
%                       1 1 1 1   -1 -1 1 1   -1 1 -1 1   1 1 1 1 ...
%                       1 -1 -1 1   1 -1 1 -1 1 -1 -1 -1   -1 -1 1 1 ...
%                       -1 -1 1 -1   1 -1 1 1   1 1 0 0 0 0];        
%     otherwise
%         error('invalid channel bandwidth')
% end
% 
% 
% % preamble in frequency domain
% c_preamble = fftshift(c_preamble);
% c_preamble = hsr_phase_rotation(c_preamble);
% c_preamble = ifft(c_preamble,[],2)*sqrt(c_sim.Nfft);
% 
% %support for multiple antennas
% ntx = c_sim.antennas(1);
% 
% % cyclic shifts
% cs = hsr_cyclic_shift('HT',ntx);
% 
% shiftsamps = zeros(1,ntx);
% ht_l_preamble = zeros(ntx,c_sim.Nfft);
% 
% for nant = 1:ntx
%     shiftsamps(nant) = cs(nant)*c_sim.sampling_freq;
%     shiftsamps(nant) = 1e-9*shiftsamps(nant);
%     ht_l_preamble(nant,:) = circshift(c_preamble,[0,shiftsamps(nant)]);
% end
% 
% % cyclic prefix
% N = c_sim.Nfft;
% ht_l_preamble = [ht_l_preamble(:, (3*N/4 + 1):N) ht_l_preamble];
% 
% 
% % orthogonal mapping
% p = [1 -1 1 1 ; 1 1 -1 1 ; 1 1 1 -1 ; -1 1 1 1];
% nltf = nant;
% if nant == 3
%     nltf = 4;
% end
% 
% lenHT = 5/4*N;
% data_out = zeros(nant,nltf*lenHT);
% 
% for n = 1:nltf
%     for nant = 1:ntx
%         data_out(nant,(n - 1)*lenHT + 1:n*lenHT) = p(nant,nltf)*ht_l_preamble(nant,:);
%     end

end


