function [output,sigmaw2r] = hsr_equalizer(input,H,sigma)
%HSR_EQUALIZER frequency domain equalizer for IEEE 802.11a / Hiperlan2
%
%  [DATA_OUT,SIGMAW2R] = HSR_EQUALIZER(DATA_IN,C_CHANNEL)
%      Performs a zero-forcing equalization of DATA_IN based on the channel
%      estimates C_CHANNEL. Both are in the frequency domain.
%      DATA_IN is a 64xN matrix, with N the number of OFDM symbols in a block
%      C_CHANNEL is a 1x64 vector
%      The logical subchannels of the equalized signal are output in the 
%      48 x N matrix DATA_OUT and SIGMAW2R (1x48) contains the reciprocal values
%      of the logical subchannel noise variances
%

% Versions:   sfu   02.11.2000   initial
%             aba   08.11.2000   takes variable power allocation into account
%             aba   20.11.2000   channel input in the frequency domain
%             aba   26.07.2001   adapted for block transmission, parameter METHOD eliminated


global c_sim

Ntx = c_sim.antennas(1);
Nrx = c_sim.antennas(2);
Nsym = size(input,2);

if Ntx == 1 && Nrx == 1
    sigmaw2r = repmat(sigma,[1,Nsym]);
    H1 = repmat(H,[1,Nsym]);
    output = input./H1;
end

% % data = data_in(c_sim.Nsd_index,:,:);
% % C_channel = C_channel(:,c_sim.Nsd_index);
% % 
% if c_sim.antennas(1) == 2 && c_sim.n_streams == 1
%     % Alamouti
%     %nsymbs = size(input,2);
%     output = zeros(Nsd,Nsym);
%     H1 = repmat(Hchannel(:,1),[1,Nsym/2]);
%     %H1 = repmat(C_channel(1,:).',1,nsymbs/2);
%     H2 = repmat(Hchannel(:,2),[1,Nsym/2]);
%     %H2 = repmat(C_channel(2,:).',1,nsymbs/2);
%     
%     output(:,1:2:end) = input(:,1:2:end).*conj(H1) + conj(input(:,2:2:end)).*H2;
%     output(:,2:2:end) = input(:,1:2:end).*conj(H2) - conj(input(:,2:2:end)).*H1; 
%     %data_out(:,1:2:end) = data(:,1:2:end).*conj(H1) + conj(data(:,2:2:end)).*H2;
%     %data_out(:,2:2:end) = data(:,1:2:end).*conj(H2) - conj(data(:,2:2:end)).*H1;                        
%     
%     H1 = repmat(H1,1,2);
%     H2 = repmat(H2,1,2);
%     
%     output = sqrt(Ntx)*output./(abs(H1).^2 + abs(H2).^2);
%     sigmaw2r = (abs(H(1,:)).^2 + abs(H(2,:)).^2)/sqrt(Ntx);
%     %sigmaw2r = (abs(C_channel(1,:)).^2 + abs(C_channel(2,:)).^2) /...
%     %            sqrt(c_sim.antennas(1));
%     
% % else     
% %     data_out = data./repmat(C_channel.',1,size(data,2));
% %     sigmaw2r = C_channel.*conj(C_channel);
end

% Estimate noise variances. Here, they are estimated by assuming white
% channel noise and a perfect channel estimate. The subcarrier noise levels
% are amplified by frequency-domain equalization above ("noise enhancement").
% In fact, we need the reciprocal values of the logical subcarrier noise variances: