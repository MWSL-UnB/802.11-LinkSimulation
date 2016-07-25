function [LSTF] = hsr_preamble_s()
% HSR_PREAMBLE_S  short preamble (training data) for IEEE 802.11a or Hiperlan/2. 
%
%   Y = HSR_PREAMBLE_S (TYPE)
%     returns the short preamble in Y.
%     TYPE = 'legacy' for 802.11a preamble or 'HT' for 802.11n HT preamble

% Simeon Furrer, 21.09.00   Created help file.
% Andre Noll Barreto, 08.01.01  multiple transmit antennas considered
%                     07.01.14 include MIMO and 40MHz

global c_sim;

version = c_sim.version;
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

if strcmp(version,'802.11a')
    
    LSTF = sqrt(13/6)*[0 0 0 0 0 0 LSTFleft 0 LSTFright 0 0 0 0 0];
    
    L = length(LSTF);
    
    % generate time data samples from short preamble
    LSTF = fftshift(LSTF);
    LSTF = ifft(LSTF)*sqrt(L);
    
    %L-STF is a 8 us field
    Tg = LSTF((L/2) + 1:end);
    LSTF = [Tg LSTF LSTF];

elseif strcmp(version,'802.11n')
    
    LSTF = sqrt(1/2)*[0 0 0 0 0 0 LSTFleft 0 ...
                      LSTFright 0 0 0 0 0];
    
    % replicate over each 20 MHz channel
    switch channel
        case 20
            N = 1;
        case 40
            N = 2;
        otherwise
            error('Invalid bandwidth for 802.11n')
    end
    
    LSTF = repmat(LSTF,[1,N]);
    L = length(LSTF);
    
    %support for multiple antennas
    Ntx = antenna_array(1);
    
    % phase rotation
    LSTF = fftshift(LSTF);
    LSTF = hsr_phase_rotation('transmission',LSTF.');
    LSTF = LSTF.';
           
    % cyclic shift for multiple antenna
    cs = hsr_cyclic_shift('legacy',Ntx);
    
    shiftsamps = zeros(1,Ntx);
    Nss_LSTF = zeros(Ntx,L);
    
    for k = 1:Ntx
        shiftsamps(k) = cs(k)*sampling_freq;
        shiftsamps(k) = 1e-9*shiftsamps(k);
        Nss_LSTF(k,:) = circshift(LSTF,[0,shiftsamps(k)]);
    end
    
    % generate time data samples from short preamble
    L = size(Nss_LSTF,2);
    Nss_LSTF = ifft(Nss_LSTF)*sqrt(L);
    
    %L-STF is a 8 us field
    L = size(Nss_LSTF,2);
    Tg = Nss_LSTF(:,(L/2) + 1:end);
    LSTF = [Tg Nss_LSTF Nss_LSTF];
        
elseif strcmp(version,'802.11ac')
    
    LSTF = sqrt(1/2)*[0 0 0 0 0 0 LSTFleft 0 ...
                      LSTFright 0 0 0 0 0];
    
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
    
    LSTF = repmat(LSTF,[1,N]);
    L = length(LSTF);
    
    %support for multiple antennas
    Ntx = antenna_array(1);
    
    %phase rotation
    LSTF = fftshift(LSTF);
    LSTF = hsr_phase_rotation('transmission',LSTF.');
    LSTF = LSTF.';
        
    % cyclic shift for multiple antenna
    cs = hsr_cyclic_shift('legacy',Ntx);
    
    shiftsamps = zeros(1,Ntx);
    Nss_LSTF = zeros(Ntx,L);
    
    for k = 1:Ntx
        shiftsamps(k) = cs(k)*sampling_freq;
        shiftsamps(k) = 1e-9*shiftsamps(k);
        Nss_LSTF(k,:) = circshift(LSTF,[0,shiftsamps(k)]);
    end
    
    % generate time data samples from short preamble
    L = size(Nss_LSTF,2);
    Nss_LSTF = ifft(Nss_LSTF)*sqrt(L);
    
    %L-STF is a 8 us field
    L = size(Nss_LSTF,2);
    Tg = Nss_LSTF(:,(L/2) + 1:end);
    LSTF = [Tg Nss_LSTF Nss_LSTF];

% N = c_sim.Nfft;
% 
% % constants for 802.11 preambles
% % short preamble, ordering input #-32 ... #+31
% LSTFleft = [0 0 ...
%             +1+1i 0 0 0 ...
%             -1-1i 0 0 0 ...
%             +1+1i 0 0 0 ...
%             -1-1i 0 0 0 ...
%             -1-1i 0 0 0 ...
%             +1+1i 0 0 0];
% LSTFright = [0 0 0 ...
%              -1-1i 0 0 0 ...
%              -1-1i 0 0 0 ...
%              +1+1i 0 0 0 ...
%              +1+1i 0 0 0 ...
%              +1+1i 0 0 0 ...
%              +1+1i 0 0];
% 
% if strcmp(c_sim.version,'802.11a')
%     c_s_preamble = sqrt(13/6)*[0 0 0 0 0 0 LSTFleft 0 LSTFright 0 0 0 0 0];
% end
% 
% if strcmp(c_sim.version,'802.11n')
%     switch c_sim.w_channel
%         case 20
%             c_s_preamble = sqrt(1/2)*[0 0 0 0 0 0 LSTFleft 0 ...
%                                       LSTFright 0 0 0 0 0];
%         case 40
%             c_s_preamble = sqrt(1/2)*[0 0 0 0 0 0 LSTFleft 0 ...
%                                       LSTFright 0 0 0 0 0 ...
%                                       0 0 0 0 0 0 LSTFleft 0 ...
%                                       LSTFright 0 0 0 0 0];
%         otherwise
%             error('Invalid L-STF frequency sequence');
%     end
% end
% 
% if strcmp(c_sim.version,'802.11ac')
%     switch c_sim.w_channel
%         case 20
%             c_s_preamble = sqrt(1/2)*[0 0 0 0 0 0 LSTFleft 0 ...
%                                       LSTFright 0 0 0 0 0];
%         case 40
%             c_s_preamble = sqrt(1/2)*[0 0 0 0 0 0 LSTFleft 0 ...
%                                       LSTFright 0 0 0 0 0 ...
%                                       0 0 0 0 0 0 LSTFleft 0 ...
%                                       LSTFright 0 0 0 0 0];
%         case 80
%             S_58 = [LSTFleft 0 LSTFright 0 0 0 0 0 ...
%                     0 0 0 0 0 0 LSTFleft 0 LSTFright];
%             c_s_preamble = sqrt(1/2)*[0 0 0 0 0 0 S_58 0 0 0 0 0 ...
%                                       0 0 0 0 0 0 S_58 0 0 0 0 0];
%         case 160
%             S_122 = [LSTFleft 0 LSTFright 0 0 0 0 0 ...
%                     0 0 0 0 0 0 LSTFleft 0 LSTFright 0 0 0 0 0 0 ...
%                     0 0 0 0 0 LSTFleft 0 LSTFright 0 0 0 0 0 ...
%                     0 0 0 0 0 0 LSTFleft 0 LSTFright];
%             c_s_preamble = sqrt(1/2)*[0 0 0 0 0 0 S_122 0 0 0 0 0 0 ...
%                                       0 0 0 0 0 S_122 0 0 0 0 0];   
%         otherwise
%             error('Invalid L-STF frequency sequence');
%     end
% end
%                                   
% % phase rotation
% c_s_preamble = fftshift(c_s_preamble);
% c_s_preamble = hsr_phase_rotation(c_s_preamble);
% 
% % generate air data samples from short preamble
% c_s_preamble= ifft(c_s_preamble)*sqrt(N);
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
% s_preamble = zeros(ntx,N);
% 
% for nant = 1:ntx
%     shiftsamps(nant) = cs(nant)*c_sim.sampling_freq;
%     shiftsamps(nant) = 1e-9*shiftsamps(nant);
%     s_preamble(nant,:) = circshift(c_s_preamble,[0,shiftsamps(nant)]);
% end
% 
% if strcmp(type,'legacy')
%     data_out = [s_preamble(:,N/2 + 1:N) s_preamble s_preamble];
% elseif strcmp(type,'HT')  
%     data_out = [s_preamble(:,3*N/4 + 1:N) s_preamble];
% elseif strcmp(type,'VHT')
%     data_out = [s_preamble(:,3*N/4 + 1:N) s_preamble];
end