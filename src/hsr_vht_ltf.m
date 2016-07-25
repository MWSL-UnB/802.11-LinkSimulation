function [NVHTLTF] = hsr_vht_ltf()


global c_sim

LTFleft = [+1 +1 -1 -1 +1 +1 -1 +1 -1 +1 +1 +1 +1 +1 +1 ...
           -1 -1 +1 +1 -1 +1 -1 +1 +1 +1 +1];
        
LTFright = [+1 -1 -1 +1 +1 -1 +1 -1 +1 -1 -1 -1 -1 -1 +1 ...
 	      	+1 -1 -1 +1 -1 +1 -1 +1 +1 +1 +1];
         
switch c_sim.w_channel
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

%phase rotation
VHTLTF = fftshift(VHTLTF);
%VHTLTF = phase_rotation(c_sim.w_channel,VHTLTF);

% generate time data samples
VHTLTF = ifft(VHTLTF)*sqrt(L);
    
%support for multiple antennas
Ntx = c_sim.antennas(1);

if Ntx > 8
    error('802.11ac supports at most 8x8 antenna array')
end

% cyclic shift for multiple antenna
cs = hsr_cyclic_shift('VHT',Ntx);

shiftsamps = zeros(1,Ntx);
Nss_VHTLTF = zeros(Ntx,L);

for k = 1:Ntx
     shiftsamps(k) = (cs(k)*c_sim.sampling_freq)/1e9;
     Nss_VHTLTF(k,:) = circshift(VHTLTF,[0,shiftsamps(k)]);
end

% VHT-LTF is a 4 us field
L = size(Nss_VHTLTF,2);
Tg = Nss_VHTLTF(:,(L/2) + (L/4) + 1:end);
VHTLTF = [Tg Nss_VHTLTF];

% number of VHT-LTFs
Nvhtltf = Ntx;

if (Ntx == 3)
    Nvhtltf = 4;
elseif (Ntx == 5)
    Nvhtltf = 6;
elseif (Ntx == 7)
    Nvhtltf = 8;
end

% matrix mapping
if (Nvhtltf <= 4)
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
elseif (Nvhtltf == 6)
    w = exp(-1i*(2*pi)/6);
    Pvhtltf = [1    -1      1       1       1       -1;
               1    -w^1    w^2     w^3     w^4     -w^5;
               1    -w^2    w^4     w^6     w^8     -w^10;
               1    -w^3    w^6     w^9     w^12    -w^15;
               1    -w^4    w^8     w^12    w^16    -w^20;
               1    -w^5    w^10    w^15    w^20    -w^25];
    
    Rvhtltf = Pvhtltf(1,:);
    Rvhtltf = repmat(Rvhtltf,6,1);
               
elseif (Nvhtltf == 8)
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
pilots = circshift(c_sim.Nsp_index,[1,c_sim.Nsp/2]);

for n = 1:Nvhtltf
    for iss = 1:Ntx
        x = 1;
        s = 1;
        for m = 1:L
            if m == pilots(x)
                
                if m >= max(pilots)
                    x = length(pilots);
                else
                    x = x + 1;
                end
                
                NVHTLTF(iss,(n - 1)*L + s) = Rvhtltf(iss,n)*VHTLTF(iss,m);
            else
                NVHTLTF(iss,(n - 1)*L + s) = Pvhtltf(iss,n)*VHTLTF(iss,m);
            end
            s = s + 1;
        end
    end
end


end

