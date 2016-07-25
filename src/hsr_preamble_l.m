function [LLTF] = hsr_preamble_l()
% HSR_PREAMBLE_L  long preamble (training data) for IEEE 802.11a or Hiperlan/2. 
%
%   Y = HSR_PREAMBLE_L (TX_ANT)
%     returns the long preamble in Y.
%     TX_ANT (optional) contains the antenna coefficients in case of multiple
%     antenna transmit diversity.

% Simeon Furrer, 21.09.00   Created help file.
% Andre Noll Barreto, 08.01.01  multiple transmit antennas considered
%                     13.01.14  Include MIMO and 40MHz

global c_sim

version = c_sim.version;
channel = c_sim.w_channel;
antenna_array = c_sim.antennas;
sampling_freq = c_sim.sampling_freq;

LLTFleft = [1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1];
        
LLTFright = [1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1];

if strcmp(version,'802.11a')         
    
    LLTF = [0 0 0 0 0 0 LLTFleft 0 LLTFright 0 0 0 0 0];
    
    L = length(LLTF);
    
    % generate time data samples from long preamble
    LLTF = fftshift(LLTF);
    LLTF = ifft(LLTF)*sqrt(L);

    %L-LTF is a 8 us field
    Tg = LLTF((L/2) + 1:end);
    LLTF = [Tg LLTF LLTF];

elseif strcmp(version,'802.11n')
    
    LLTF = [0 0 0 0 0 0 LLTFleft 0 LLTFright 0 0 0 0 0];
    
    % replicate over each 20 MHz channel
    switch channel
        case 20
            N = 1;
        case 40
            N = 2;
        otherwise
            error('Invalid bandwidth for 802.11n')
    end
    
    LLTF = repmat(LLTF,[1,N]);
    
    L = length(LLTF);
    
    %phase rotation
    LLTF = fftshift(LLTF);
    LLTF = hsr_phase_rotation('transmission',LLTF.');
    LLTF = LLTF.';
        
    %support for multiple antennas
    Ntx = antenna_array(1);
    
    % cyclic shift for multiple antenna
    cs = hsr_cyclic_shift('legacy',Ntx);
    
    shiftsamps = zeros(1,Ntx);
    Nss_LLTF = zeros(Ntx,L);

    for k = 1:Ntx
        shiftsamps(k) = cs(k)*sampling_freq;
        shiftsamps(k) = 1e-9*shiftsamps(k);
        Nss_LLTF(k,:) = circshift(LLTF,[0,shiftsamps(k)]);
    end
    
    % generate time data samples from long preamble
    L = size(Nss_LLTF,2);
    Nss_LLTF = ifft(Nss_LLTF)*sqrt(L);
    
    %L-LTF is a 8 us field
    L = size(Nss_LLTF,2);
    Tg = Nss_LLTF(:,(L/2) + 1:end);
    LLTF = [Tg Nss_LLTF Nss_LLTF];
    
elseif strcmp(version,'802.11ac')
    
    LLTF = [0 0 0 0 0 0 LLTFleft 0 LLTFright 0 0 0 0 0];
    
    % replicate over each 20 MHz channel
    switch channel
        case 20
            N = 1;
        case 40
            N = 2;
        case 80
            N = 4;
        case 160
            N = 8;
        otherwise
            error('Invalid bandwidth for 802.11ac')
    end
    
    LLTF = repmat(LLTF,[1,N]);
    
    L = length(LLTF);
    
    %phase rotation
    LLTF = fftshift(LLTF);
    LLTF = hsr_phase_rotation('transmission',LLTF.');
    LLTF = LLTF.';
    
    %support for multiple antennas
    Ntx = antenna_array(1);
    
    % cyclic shift for multiple antenna
    cs = hsr_cyclic_shift('legacy',Ntx);
    
    shiftsamps = zeros(1,Ntx);
    Nss_LLTF = zeros(Ntx,L);

    for k = 1:Ntx
        shiftsamps(k) = cs(k)*sampling_freq;
        shiftsamps(k) = 1e-9*shiftsamps(k);
        Nss_LLTF(k,:) = circshift(LLTF,[0,shiftsamps(k)]);
    end
    
    % generate time data samples from long preamble
    L = size(Nss_LLTF,2);
    Nss_LLTF = ifft(Nss_LLTF)*sqrt(L);
    
    %L-LTF is a 8 us field
    L = size(Nss_LLTF,2);
    Tg = Nss_LLTF(:,(L/2) + 1:end);
    LLTF = [Tg Nss_LLTF Nss_LLTF];
    
end

end

% % constants for 802.11 preambles
% % long preamble, ordering input #-32 ... #+31
% % c_l_preamble = [ 0  0  0  0  0  0 +1 +1 -1 -1 +1 +1 -1 +1 -1 +1 ...
% % 		        +1 +1 +1 +1 +1 -1 -1 +1 +1 -1 +1 -1 +1 +1 +1 +1 ...
% % 		         0 +1 -1 -1 +1 +1 -1 +1 -1 +1 -1 -1 -1 -1 -1 +1 ...
% % 	      	    +1 -1 -1 +1 -1 +1 -1 +1 +1 +1 +1  0  0  0  0  0];
% %
% 
% LLTFleft = [+1 +1 -1 -1 +1 +1 -1 +1 -1 +1 +1 +1 +1 +1 +1 ...
%             -1 -1 +1 +1 -1 +1 -1 +1 +1 +1 +1];
%         
% LLTFright = [+1 -1 -1 +1 +1 -1 +1 -1 +1 -1 -1 -1 -1 -1 +1 ...
%  	      	 +1 -1 -1 +1 -1 +1 -1 +1 +1 +1 +1];
% 
% if strcmp(c_sim.version,'802.11a')
%     c_l_preamble = [0 0 0 0 0 0 LLTFleft 0 LLTFright 0 0 0 0 0];
% end
% 
% if strcmp(c_sim.version,'802.11n')
%     switch c_sim.w_channel
%         case 20
%             c_l_preamble = [0 0 0 0 0 0 LLTFleft 0 LLTFright 0 0 0 0 0];
%         case 40
%             c_l_preamble = [0 0 0 0 0 0 LLTFleft 0 LLTFright 0 0 0 0 0 ...
%                             0 0 0 0 0 0 LLTFleft 0 LLTFright 0 0 0 0 0];
%         otherwise
%             error('invalid L-STF frequency senquence');
%     end
% end
% 
% if strcmp(c_sim.version,'802.11ac')
%     switch c_sim.w_channel
%         case 20
%             c_l_preamble = [0 0 0 0 0 0 LLTFleft 0 LLTFright 0 0 0 0 0];
%         case 40
%             c_l_preamble = [0 0 0 0 0 0 LLTFleft 0 LLTFright 0 0 0 0 0 ...
%                             0 0 0 0 0 0 LLTFleft 0 LLTFright 0 0 0 0 0];
%         case 80
%             L_58 = [LLTFleft 0 LLTFright 0 0 0 0 0 ...
%                     0 0 0 0 0 0 LLTFleft 0 LLTFright];
%             c_l_preamble = [0 0 0 0 0 0 L_58 0 0 0 0 0 ...
%                             0 0 0 0 0 0 L_58 0 0 0 0 0];
%         case 160
%             L_122 = [LLTFleft 0 LLTFright 0 0 0 0 0 ...
%                      0 0 0 0 0 0 LLTFleft 0 LLTFright 0 0 0 0 0 ...
%                      0 0 0 0 0 0 LLTFleft 0 LLTFright 0 0 0 0 0 ...
%                      0 0 0 0 0 0 LLTFleft 0 LLTFright];
%             c_l_preamble = [0 0 0 0 0 0 L_122 0 0 0 0 0 ...
%                             0 0 0 0 0 0 L_122 0 0 0 0 0];
%     end
% end
% 
% % phase rotation
% c_l_preamble = fftshift(c_l_preamble);
% c_l_preamble = hsr_phase_rotation(c_l_preamble);
% 
% % generate air data samples
% % generate long preamble
% c_l_preamble = ifft(c_l_preamble)*sqrt(N);
% 
% %support for multiple antennas
% ntx = c_sim.antennas(1);
% 
% % same preamble is transmitted from all antennas with circular shifts
% if strcmp(c_sim.version,'802.11a')
%     cs = 0;
% elseif strcmp(c_sim.version,'802.11n')
%     cs = hsr_cyclic_shift('legacy',ntx);
% elseif strcmp(c_sim.version,'802.11ac')
%     cs = hsr_cyclic_shift('legacy',ntx);
% end
% 
% shiftsamps = zeros(1,ntx);
% l_preamble = zeros(ntx,N);
% 
% for nant = 1:ntx
%     shiftsamps(nant) = cs(nant)*c_sim.sampling_freq;
%     shiftsamps(nant) = 1e-9*shiftsamps(nant);
%     l_preamble(nant,:) = circshift(c_l_preamble,[0,shiftsamps(nant)]);
% end
% 
% data_out = [l_preamble(:,N/2 + 1:N) l_preamble l_preamble];