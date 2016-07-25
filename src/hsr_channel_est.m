function C_channel = hsr_channel_est(method, data, SNR)

%HSR_CHANNEL_EST Channel estimator for IEEE 802.11a / Hiperlan2
%
%   HSR_CHANNEL_EST('init', CH_LENGTH, SNR) to initialize the estimator (generates filtering matrix)
%   this is needed if mmse estimation is employed later. The estimator is configured considering a maximum
%   delay spread CH_LENGTH samples (default value CH_LENGTH = 16) and a signal-to-noise ratio SNR in dB
%   (default value SNR = 20dB)
%  
%   C_CHANNEL = HSR_CHANNEL_EST('zf',DATA) returns the estimated channel frequency response based on input data
%   the zero-forcing method (LS) is employed [1], the channel is estimated on the non-null frequencies only
%
%   C_CHANNEL = HSR_CHANNEL_EST('mmse',DATA)
%   C_CHANNEL = HSR_CHANNEL_EST('exec',DATA) returns the estimated channel frequency response based on input data
%   the minimum mean-square error method (MMSE) is employed. Since the channel covariance matrix and the noise
%   level are not known a robust estimator is considered, assuming a flat delay profile over 16 samples (400ns) [2].
%   The noise level is fixed at Eb/N0 = 20dB
%
%   References:
%     [1] J.J. van de Beek, O. Edfors, M. Sandell, S.K. Wilson and P.O. Borjesson, "On channel estimation in OFDM
%         systems", Proc. of VTC'95, Chicago, USA, July 1995, pp. 815-819
%     [2] Y. Li, L.J. Cimini Jr. and N.R. Sollenberger, "Robust channel estimation for OFDM systems with rapid fading
%         channels", IEEE Trans. on Commun., July 1998, pp. 902-915

% History:   Andre Noll Barreto   20.11.2000   created
%                                 01.02.2001   multiple receice antennas considered
%                                              lmmse estimator implemented (code from Simeon Furrer)
%                                 21.08.2001   lmmse estimator can be initialised with different values


persistent filter

pmask = [2:27,39:64];

if strcmpi(method,'init')    
    if exist('data') && ~isempty(data)
        ch_len = data;
    else
        ch_len = 16;
    end
    
    if ~exist('SNR') || ~isempty(SNR)
        SNR = 20;    
    end
    
    c_chan_model = ones(1,ch_len);
    c_chan_model = c_chan_model./sqrt(c_chan_model*c_chan_model');
    c_chan_model = [c_chan_model zeros(1,(64-length(c_chan_model)))].';
    
    Rqq = (fft(c_chan_model.*conj(c_chan_model)))';
    Rqq = toeplitz((Rqq));
    % and fixed SNR (20dB)
    fixsigmaZ2 = (1/(log2(2)))/(10^(SNR/10));
    Rnn = fixsigmaZ2*diag(ones(1,52));
    filter = Rqq(:,pmask)*inv(Rqq(pmask,pmask)+Rnn);
    
    return;
end


preamble = [+1 -1 -1 +1 +1 -1 +1 -1 +1 -1 -1 -1 -1 -1 +1 +1 -1 -1 +1 -1 +1 -1 +1 +1 +1 +1 ...
        +1 +1 -1 -1 +1 +1 -1 +1 -1 +1 +1 +1 +1 +1 +1 -1 -1 +1 +1 -1 +1 -1 +1 +1 +1 +1];    

if strncmpi(method,'zf',2)
    [nants,l] = size(data);
    
    if l ~= 128
        error ('hsr_channel_est: input vector must be 128 samples long')
    end
    
    clear data_mean;
    
    data_mean(:,:,1) = data(:,1:64);
    data_mean(:,:,2) = data(:,65:128);
    data_mean = fft(data_mean,64,2)/8;
    data_mean = mean(data_mean,3);
    
    ch_est_log = data_mean(:,pmask) .* repmat(preamble,nants,1);
    C_channel = zeros(nants,64);
    C_channel(:,pmask) = ch_est_log;
    
    
elseif strncmpi(method,'exec',4) || strncmpi(method,'mmse',4)
    [nants,l] = size(data);
    if l ~= 128
        error ('hsr_channel_est: input vector must be 128 samples long')
    end
    
    clear data_mean;
    data_mean(:,:,1) = data(:,1:64);
    data_mean(:,:,2) = data(:,65:128);
    data_mean = fft(data_mean,64,2)/8;
    data_mean = mean(data_mean,3);
    ch_est_log = data_mean(:,pmask) .* repmat(preamble,nants,1);
    C_channel = (filter * ch_est_log.').';
    
else
    error ('hsr_channel_est: method unknown');
end



