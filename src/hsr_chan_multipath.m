function [varargout] = hsr_chan_multipath(varargin)
% HSR_CHAN_MULTIPATH - Multipath channel for T-spaced simulation in
%                           baseband
%
%   This function generates a multipath channel with exponentially decaying
%   multipathes according to [1]. The channel must be initialised with 'init'
%   and the 'fade'-method must be called at least once before the channel is
%   used. Every time the 'fade' method is called the fading coefficients of
%   all the paths are changed.
%
%   HSR_CHAN_MULTIPATH('init',MODEL,TS,ROLLOFF,SEED,[N_BS N_MS],...
%                           VELOCITY,FADING_INTERVAL)
%     Initializes channel unit sample response and channel state. Independent
%     channel instances are created between each transmit and receive antenna.
%     MODEL = 'A','B','C','D', 'E' or 'F' specifies the channel environment
%     according to [2]
%     TS = sampling period in seconds
%     ROLLOFF = roll-off factor of transmit filter
%     SEED = initial state of random number generator (default = 1)
%     N_BS and N_MS are the number of antennas at the base and at the mobile
%     station respectively, by default N_TX = N_RX = 1.
%     VELOCITY in m/s. If velocity < 0 (default) there is no correlation
%     between different fades. A minimum Doppler of 5Hz is considered if
%     velocity >= 0, to account for a changing environment
%     FADING_INTERVAL is the interval in seconds between two fades, only
%     relevant if VELOCITY > 0
%
%   C = HSR_CHAN_MULTIPATH_ETSI('fade',NORM_P)
%      Randomly generates newchannel coefficients (Rayleigh or Rice distributed).
%      The current impulse response of the channel is returned in C. If NORM_P
%      exists and NORM_P > 0, then the energy of the channel impulse response is
%      normalised to NORM_P, corresponding to ideal power control.
%
%      !!!!This method has to be called at least once before 'exec' is used!!!!
%
%   [Y,C] = HSR_CHAN_MULTIPATH_ETSI ('exec', X)
%   [Y,C] = HSR_CHAN_MULTIPATH_ETSI ('downlink', X)
%     Processes the T-spaced complex baseband samples X to determine the T-spaced
%     complex channel outputs Y. Output the current unit-sample response C of the
%     channel. N_BS transmit and N_MS receive antennas are considered. The signals
%     at the different transmit antennas are row vectors.
%
%   [Y,C] = HSR_CHAN_MULTIPATH_ETSI ('uplink', X)
%     As above, except that N_MStransmit and N_BS receive antennas are considered.
%
%   C = HSR_CHANNEL_MULTIPATH_ETSI ('getchannel')
%     Outputs the current unit-sample response C of the channel as row vectors
%
%   [1] ETSI EP BRAN#9, "Criteria for Comparison", 30701F, July 1998
%   [2] Perahia E. and Stacey R., "Next Generation Wireless LANs",
%   Cambridge, 2008

% History:
% 21.11.00, Andre Noll Barreto: created
% 05.01.01,                     multiple antennas considered
% 15.02.01,                     time-variant fading
% 25.07.01,                     adapted for block transmission, filter states are not stored anymore
% 19.10.16, Calil Queiroz:      Adapted to 802.11n's channel model [2]

persistent Ts
persistent rolloff
persistent tau
persistent power_av
persistent mfirst
persistent mlast
persistent L
persistent N
persistent W
persistent t
persistent h
persistent rnd_state
persistent n_bs
persistent n_ms
persistent npaths
persistent fade_count
persistent fade_filst
persistent fd
persistent next_fade_count
persistent previous_fade_count
persistent fade_save
persistent Tf
persistent n_fil
persistent num
persistent den
persistent TxFilMatrix;

method = varargin{1};
if strcmp(method,'init')
    model = varargin{2};
    Ts = varargin{3};
    rolloff = varargin{4};
    if (nargin > 4) && ~isempty(varargin{5})
        seed = varargin{5};
    else
        seed = 1;
    end
    if (nargin > 5) && ~isempty(varargin{6})
        n_bs = varargin{6}(1);
        n_ms = varargin{6}(2);
    else
        n_bs = 1;
        n_ms = 1;
    end
    if (nargin > 6) && ~isempty(varargin{7})
        vel = varargin{7};
    else
        vel = -1;
    end
    if (nargin > 7)
        Tf = varargin{8};
    end
    
    switch model
        case 'A' %Flat channel
            tau = 0*1.0e-9; %tap delay in nanoseconds
            clusters = 0;
%             Rice_K = 1;
        case 'B'
            tau = [0 10 20 30 40 50 60 70 80]*1.0e-9; %tap delay in nanoseconds
            clusters = [[0    -5.4 -10.8 -16.2 -21.7 -Inf  -Inf  -Inf  -Inf];...
                        [-Inf -Inf -3.2  -6.3  -9.4  -12.5 -15.6 -18.7 -21.8]];
%             Rice_K = 1;
        case 'C'
            tau = [0 10 20 30 40 50 60 70 80 90 110 140 170 200]*1.0e-9;
            clusters = [[0 -2.1 -4.3 -6.5 -8.6 -10.8 -13.0 -15.2 -17.3 -19.5 -Inf -Inf -Inf -Inf];...
                [-Inf -Inf -Inf -Inf -Inf -Inf -5.0 -7.2 -9.3 -11.5 -13.7 -15.8 -18.0 -20.2]];
%             Rice_K = 1;
        case 'D'
            tau = [0 10 20 30 40 50 60 70 80 90 110 140 170 200 240 290 340 390]*1.0e-9;
            clusters = [[0    -0.9 -1.7 -2.6 -3.5 -4.3 -5.2 -6.1 -6.9 -7.8 -9.0 -11.1 -13.7 -16.3 -19.3 -23.2 -Inf  -Inf];...
                        [-Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -6.6 -9.5  -12.1 -14.7 -17.4 -21.9 -25.5 -Inf];...
                        [-Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf  -Inf  -Inf  -18.8 -23.2 -25.2 -26.7]];
%             Rice_K = 2;  %K = P_LOS/P_Rayleigh
        case 'E'
            tau = [0 10 20 30 50 80 110 140 180 230 280 330 380 430 490 560 640 730]*1.0e-9;
            clusters = [[-2.6 -3.0 -3.5 -3.9 -4.5 -5.6 -6.9 -8.2 -9.8 -11.7 -13.9 -6.1  -18.3 -20.5 -22.9 -Inf  -Inf  -Inf];...
                        [-Inf -Inf -Inf -Inf -1.8 -3.2 -4.5 -5.8 -7.1 -9.9  -10.3 -14.3 -14.7 -18.7 -19.9 -22.4 -Inf  -Inf];...
                        [-Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -7.9 -9.6  -14.2 -13.8 -18.6 -18.1 -22.8 -Inf  -Inf  -Inf];...
                        [-Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf  -Inf  -Inf  -Inf  -Inf  -20.6 -20.5 -20.7 -24.6]];
%             Rice_K = 4;
        case 'F'
            tau = [0 10 20 30 50 80 110 140 180 230 280 330 400 490 600 730 880 1050]*1.0e-9;
            clusters = [[-3.3 -3.6 -3.9 -4.2 -4.6 -5.3 -6.2 -7.1 -8.2 -9.5  -11.0 -12.5 -14.3 -16.7 -19.9 -Inf  -Inf  -Inf];...
                        [-Inf -Inf -Inf -Inf -1.8 -2.8 -3.5 -4.4 -5.3 -7.4  -7.0  -10.3 -10.4 -13.8 -15.7 -19.9 -Inf  -Inf];...
                        [-Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -5.7 -6.7  -10.4 -9.6  -14.1 -12.7 -18.5 -Inf  -Inf  -Inf];...
                        [-Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf  -Inf  -Inf  -8.8  -13.3 -18.7 -Inf  -Inf  -Inf];...
                        [-Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf  -Inf  -Inf  -Inf  -Inf  -12.9 -14.2 -Inf  -Inf];...
                        [-Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -16.3 -21.2]];
%             Rice_K = 4;
        otherwise
            error ('hsr_chan_multipath_etsi: invalid channel model');
    end
    
    power_dB = 10.*log10(sum(10.^(clusters./10),1));
    
    npaths = length(tau);
    
    power_av = 10.^(power_dB/10);
    power_av = power_av / sum(power_av);
    
    mfirst = -2; %non-causal tail of raised cosine filter
    mlast = ceil(max(tau)/Ts);
    L = mlast-mfirst+1;
    N = length(tau); % Number of paths
    W = 1/Ts; % Two-sided bandwidth in Hz
    t = (mfirst:mlast)*Ts; % Time axis
    
    % Convolve multipath channel with inverse Fourier transform of raised cosine shape and sample:
    %h = zeros(1, L);
    %for n=1:N
    %   tx_fil = invraisedcos(t-tau(n),W,rolloff);
    %   h = h + sqrt(power_av(n)) * invraisedcos(t-tau(n),W,rolloff);
    %end
    %norm_factor = sqrt(sum (h.^2));
    %h = h / norm_factor;
    %zi = zeros(length(h)-1,1);
    
    if isempty(seed)
        seed = 1;
    end
    rnd_state = seed;
    randn ('state',rnd_state);
    
    if vel >= 0
        %doppler frequency fd=v*fc/c, fd>=5 to account for channel variations due to change in environment
        fd = max (vel*5e9/3e8,5);
        
        %define Doppler-Spectrum IIR filter
        %this filter has the following normalised sampling frequency: T = .05686/fd/2/pi
        n1 = [1 -1.99671673774719 1.00000002059504];
        d1 = [1 -1.98030912876129 .98243188940615];
        n2 = [1 -1.99488747119904 .99999998162424];
        d2 = [1 -1.96096897125244 .96170167433376];
        n3 = [1 -1.98880815505981 1.00000001921195];
        d3 = [1 -1.99305760860443 .99608788500263];
        n4 = [1 -1.93061649799347 1.00000000808090];
        d4 = [1 -1.99655961990356 .99977399848985];
        
        num = conv(conv(conv(n1,n2),n3),n4);
        den = conv(conv(conv(d1,d2),d3),d4);
        
        % generate time-variant fading (throw away first 400 transient-state samples)
        fade_filst = zeros(n_bs,npaths,n_ms,max(length(num),length(den))-1);
        for count = 1:8
            for ms = 1:n_ms
                for bs = 1:n_bs
                    for path = 1:npaths
                        %xrnd = (randn(n_bs,npaths,n_ms,50)+i*randn(n_bs,npaths,n_ms,50))/sqrt(21144);
                        %[fade_dop,fade_filst] = filter(num,den,xrnd,fade_filst,4);
                        xrnd = (randn(1,50)+1i*randn(1,50))/sqrt(21144);
                        [fade_dop(bs,path,ms,:),fade_filst(bs,path,ms,:)] = filter(num,den,xrnd,squeeze(fade_filst(bs,path,ms,:)));
                    end
                end
            end
        end
        
        fade_count = 0;
        next_fade_count = 0;
        n_fil = 0;
        
    end
    rnd_state = randn('state');
    
    TxFilMatrix = [];
    for n = 1:N
        TxFilMatrix(:,:,:,n) = repmat(invraisedcos(t-tau(n),W,rolloff),[n_bs,1,n_ms]);
    end
    
elseif strcmp(method,'fade');
    if fd > 0
        if fade_count >= next_fade_count
            randn ('state',rnd_state);
            
            fade_save = [];
            for ms = 1:n_ms
                for bs = 1:n_bs
                    for path = 1:npaths
                        xrnd = (randn(1,50)+1i*randn(1,50))/sqrt(21144);
                        [fade_dop(bs,path,ms,:),fade_filst(bs,path,ms,:)] = filter(num,den,xrnd,squeeze(fade_filst(bs,path,ms,:)));
                    end
                end
            end
            rnd_state = randn('state');
            
            Tf_fil = .05686/2/pi/fd;
            tfade_f = [Tf_fil*n_fil*50:Tf_fil:(n_fil*50+49)*Tf_fil];
            tfade_r = [(fade_count*Tf):Tf:(n_fil*50+49)*Tf_fil];
            
            for ms = 1:n_ms
                for bs = 1:n_bs;
                    for path = 1:npaths
                        fade_save(bs,path,ms,:) = interp1(tfade_f,squeeze(fade_dop(bs,path,ms,:)),tfade_r,'cubic');
                    end
                end
            end
            previous_fade_count = next_fade_count;
            next_fade_count = next_fade_count + size(fade_save,4);
            n_fil = n_fil + 1;
            
        end
        fade = fade_save(:,:,:,fade_count-previous_fade_count+1);
        fade_count = fade_count + 1;
    else
        randn ('state',rnd_state);
        fade = (randn(n_bs,npaths,n_ms) + 1i*randn(n_bs,npaths,n_ms)) / sqrt(2);
        rnd_state = randn('state');
    end
    
    fade = fade .* repmat(sqrt(power_av),[n_bs,1,n_ms]);
    if exist ('Rice_K_dB')
        phi = pi/4; %
        LOS = exp(1i*phi) * sqrt(power_av(1)*Rice_K/(1+Rice_K));
        fade(:,1,:) = LOS + fade(:,1,:)/sqrt(1+Rice_K);
    end
    
    % Convolve multipath channel with inverse Fourier transform of raised cosine shape and sample:
    h = zeros(n_bs,L,n_ms);
    if n_bs==1
        for n = 1:N
            h = h + repmat(fade(:,n,:),[1,L,1]) .* TxFilMatrix(:,:,:,n).';
        end
    else
        for n=1:N
            %h = h + repmat(fade(:,n,:),[1,L,1]) .* repmat(invraisedcos(t-tau(n),W,rolloff),[n_bs,1,n_ms]);
            h = h + repmat(fade(:,n,:),[1,L,1]) .* TxFilMatrix(:,:,:,n);
        end
    end
    zi = zeros(n_bs,L-1,n_ms);
    
    % h = h/norm_factor;
    
    if length(varargin) > 1
        norm_p = varargin{2};
        if (norm_p > 0)
            h = h ./ repmat(sqrt(sum(abs(h).^2)),[1,L,1]) * sqrt(varargin{2});
        end
    end
    
    varargout{1} = h;
elseif strcmp(method,'exec') || strcmp(method,'downlink')
    
    X = varargin{2};
    
    for tx_i = 1:n_bs
        for rx_i = 1:n_ms
            Y(tx_i,:,rx_i) = filter(h(tx_i,:,rx_i),1,X(tx_i,:),[],2);
        end
    end
    Y = squeeze(sum (Y,1));
    
    varargout{1} = Y;
    varargout{2} = h;
    
elseif strcmp(method,'uplink')
    
    X = varargin{2};
    
    for tx_i = 1:n_ms
        for rx_i = 1:n_bs
            Y(rx_i,:,tx_i) = filter(h(rx_i,:,tx_i),1,X(tx_i,:),[],2);
        end
    end
    Y = squeeze(sum (Y,3));
    
    varargout{1} = Y;
    varargout{2} = h;
    
elseif strcmp(method,'getchannel')
    varargout{1} = h;
else
    error ('hsr_chan_multipath_etsi: invalid method');
end
