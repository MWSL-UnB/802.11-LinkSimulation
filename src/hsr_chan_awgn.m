function [data_out, sigma2] = hsr_chan_awgn(data_in,modulation,code_rate,snr)
%HSR_CHAN_AWGN Additive White Gaussian Noise channel for 802.11/Hiperlan2 PHY
%
%       [Y, N0] = HSR_CHAN_AWGN(X,MODULATION,CODERATE,SNR) 
%
%       Adds white Gaussian noise to the input signal in X , which is an input matrix
%       with complex elements. Each row corresponds to a different antenna. A unit
%       average symbol energy pro subcarrier is assumed. The noise variance depends
%       on the following parameters:
%           MODULATION = 'bpsk','qpsk','16qm','64qm'
%           CODERATE = 0 (R=1/2), 1(R=2/3), 2(R=3/4) or 3(R=4/5)
%           SNR = Eb/N0 in dB.
%       The noisy signal is output in Y, the noise variance in N0.

%	      Simeon Furrer, 31.01.00  Initial version
%       Simeon Furrer, 26.06.00  Updated
%       Simeon Furrer, 15.08.00  Scaling of EbN0 for coding 
%                                Removed FFT power normalization
%       Simeon Furrer, 05.10.00  Rate loss because of cyclic prefix 
%       Andre Noll Barreto: 05.01.01 bidimensional input (multiple antennas) allowed
%                           26.10.01 help updated

global c_sim

N = c_sim.Nfft; % FFT length
c_Ncp = c_sim.cp_length; % Length of cyclic prefix

if strcmp(modulation,'bpsk') 
        M = 2;
    elseif strcmp(modulation, 'qpsk')
        M = 4;
    elseif strcmp(modulation, '16qam')
        M = 16;
    elseif strcmp(modulation, '64qam')
        M = 64;
    elseif strcmp(modulation, '256qam') 
        M = 256;    
end

% switch coderate
%     case 0
%         R = 1/2;
%     case 1
%         R = 2/3;
%     case 2 
%         R = 3/4;
%     case 3
%         R = 4/5;
%     otherwise
%         error('invalid code rate')
% end

R = code_rate;

R = R*N/(N + c_Ncp);

% AWGN channel
Eab = 1/(log2(M)*R); % average bit energy: Eab = Eas/log2(sqrt(M))
sigma2 = Eab/(10^(snr/10));
sigma = sqrt(sigma2);
% complex noise (projection to I and Q components) for QPSK, X-QAM

w = randn(size(data_in));
% ensure mean zero and variance one
%w = w - mean(w)*ones(1,size(data_in,2)); w = w / std(w); 
% adjust mean and variance
z1 = (sigma/sqrt(2))*w;

w = randn(size(data_in));
% ensure mean zero and variance one
%w = w - mean(w)*ones(1,size(data_in,2)); w = w / std(w); 
% adjust mean and variance
z2 = (sigma/sqrt(2))*w;

% channel output   
data_out = data_in + z1 + 1i*z2;
