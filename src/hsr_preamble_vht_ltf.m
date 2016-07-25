function[NVHTLTF] = hsr_preamble_vht_ltf()
% VHT-LTF for IEEE 802.11ac

global c_sim

Nsp_index = c_sim.Nsp_index;
sampling_freq = c_sim.sampling_freq;
channel = c_sim.w_channel;
antenna_array = c_sim.antennas;
streams = c_sim.n_streams;

LTFleft = [+1 +1 -1 -1 +1 +1 -1 +1 -1 +1 +1 +1 +1 +1 +1 ...
           -1 -1 +1 +1 -1 +1 -1 +1 +1 +1 +1];
        
LTFright = [+1 -1 -1 +1 +1 -1 +1 -1 +1 -1 -1 -1 -1 -1 +1 ...
 	      	+1 -1 -1 +1 -1 +1 -1 +1 +1 +1 +1];
         
switch channel
        case 20
            VHTLTF = [0 0 0 0 1 1 LTFleft 0 LTFright -1 -1 0 0 0];
        case 40
            VHTLTF = [0 0 0 0 0 0 LTFleft 1 LTFright -1 -1 -1 1 0 0 0 ...
                      -1 1 1 -1 LTFleft 1 LTFright 0 0 0 0 0];
        case 80
            VHTLTF = [0 0 0 0 0 0 LTFleft 1 LTFright -1 -1 -1 1 1 -1 1 ...
                      -1 1 1 -1 LTFleft 1 LTFright 1 -1 1 -1 0 0 0 ...
                      1 -1 -1 1 LTFleft 1 LTFright -1 -1 -1 1 1 -1 1 ...
                      -1 1 1 -1 LTFleft 1 LTFright 0 0 0 0 0];
        case 160
            L_122 = [LTFleft 1 LTFright -1 -1 -1 1 1 -1 1 ...
                     -1 1 1 -1 LTFleft 1 LTFright 1 -1 1 -1 0 0 0 ...
                     1 -1 -1 1 LTFleft 1 LTFright -1 -1 -1 1 1 -1 1 ...
                     -1 1 1 -1 LTFleft 1 LTFright];
            VHTLTF = [0 0 0 0 0 0 L_122 0 0 0 0 0 ...
                      0 0 0 0 0 0 L_122 0 0 0 0 0];
end

L = length(VHTLTF);

% phase rotation
VHTLTF2 = fftshift(VHTLTF);
VHTLTF3 = phase_rotation(channel,VHTLTF2);

% generate time data samples
VHTLTF4 = ifft(VHTLTF3)*sqrt(L);
    
%support for multiple antennas
Ntx = antenna_array(1);

if Ntx > 8
    error('802.11ac supports at most 8x8 antenna array')
end

% cyclic shift for multiple antenna
cs = cyclic_shift(version,'VHT',Ntx);

shiftsamps = zeros(1,Ntx);
Nss_VHTLTF = zeros(Ntx,L);

for k = 1:Ntx
     shiftsamps(k) = cs(k)*sampling_freq;
     shiftsamps(k) = 1e-9*shiftsamps(k);
     Nss_VHTLTF(k,:) = circshift(VHTLTF4,[0,shiftsamps(k)]);
end

% spatial mapping
Q = spatial_mapping(version,'VHT',Ntx,streams);
Nss_VHTLTF2 = Q*Nss_VHTLTF;

% VHT-LTF is a 4 us field
L = size(Nss_VHTLTF2,2);
Tg = Nss_VHTLTF2(:,(L/2) + (L/4) + 1:end);
VHTLTF = [Tg Nss_VHTLTF2];

% number of VHT-LTFs
Nvhtltf = Ntx;

if Ntx == 3
    Nvhtltf = 4;
elseif Ntx == 5
    Nvhtltf = 6;
elseif Ntx == 7
    Nvhtltf = 8;
end

% matrix mapping
if Nvhtltf <= 4
    Pvhtltf = [1 -1 1 1;
               1 1 -1 1;
               1 1 1 -1;
               -1 1 1 1];
    
    switch Nvhtltf
        case 1
            Rvhtltf = 1;
        case 2
            Rvhtltf = [1 -1;
                       1 -1];
        case 4
            Rvhtltf = Pvhtltf(1,:);
            Rvhtltf = repmat(Rvhtltf,4,1);
    end
elseif Nvhtltf == 6
    w = exp(-1i*(2*pi)/6);
    Pvhtltf = [1    -1      1       1       1       -1;
               1    -w^1    w^2     w^3     w^4     -w^5;
               1    -w^2    w^4     w^6     w^8     -w^10;
               1    -w^3    w^6     w^9     w^12    -w^15;
               1    -w^4    w^8     w^12    w^16    -w^20;
               1    -w^5    w^10    w^15    w^20    -w^25];
    
    Rvhtltf = Pvhtltf(1,:);
    Rvhtltf = repmat(Rvhtltf,6,1);
               
elseif Nvhtltf == 8
    P_4 = [1 -1 1 1;
           1 1 -1 1;
           1 1 1 -1;
           -1 1 1 1];

    Pvhtltf = [P_4 P_4;
               P_4 P_4];
    
    Rvhtltf = Pvhtltf(1,:);
    Rvhtltf = repmat(Rvhtltf,8,1);
end

L = size(VHTLTF,2);
NVHTLTF = zeros(Ntx,Nvhtltf*L);

for n = 1:Nvhtltf
    for iss = 1:Ntx
        for m = 1:L
            if m == Nsp_index
                NVHTLTF(iss,(n - 1)*L + 1:n*L) = Rvhtltf(iss,n)*VHTLTF(iss,m);
            else
                NVHTLTF(iss,(n - 1)*L + 1:n*L) = Pvhtltf(iss,n)*VHTLTF(iss,m);
            end
        end
    end
end

end

