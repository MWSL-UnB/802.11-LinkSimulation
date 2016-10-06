
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define simulation parameters

clear c_sim
clc

global c_sim; % basic simulation paramters

c_sim.release = 'wisil_11n_1.0';     % simulator release

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main Simulation Parameters

% Eb/N0 values in dB
c_sim.EbN0s = -5:1:30;

% simulation length
c_sim.min_npackets = 500;    %minimum number of packets
c_sim.max_npackets = 2000;   %maximum number of packets
c_sim.min_pack_errors = 5;   %minimum number of packet errors
c_sim.max_pack_errors = 20;  %maximum number of packet errors
c_sim.min_bit_errors = 5;   %minimum number of bit errors
% for a given Eb/N0 simulation stops if either <c_sim.max_npackets> are
% transmitted or <c_sim.max_pack_errors> packet errors occur, however not
% before <c_sim.min_npackets> are transmitted
% error rate is not considered if less than 'c_sim.min_pack_errors' or
% 'c_sim.min_pack_errors' occur

% display simulation status every <c_sim.display_npack>
c_sim.display_npack = 100;

c_sim.rnd_state = 1;		% initial state of random number generator

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Transmitter Parameters

% Standards Version ('802.11a', '802.11n' or '802.11ac')
c_sim.version = '802.11n';

% data length of each PSDU in bytes
c_sim.data_len = 1000;

% cyclic prefix length ('long' (Ts/4) or 'short' (Ts/8))
c_sim.cyclic_prefix = 'long';

% channel bandwidth
c_sim.w_channel = 20; %20MHz or 40 MHz

% windowing
c_sim.timedomwindowing = false; % timedomain windowing
c_sim.windowlength = 2.5;       % window length TTr in samples

c_sim.encoder = 'BCC';  % BCC or LDPC encoder

c_sim.antennas = [1,1]; % number of transmit and receive antennas

c_sim.stbc = false; % Alamouti coding

c_sim.n_sts = 1;    % number of spatial-time streams

c_sim.n_streams = 1;  % number of spatial multiplexing streams

% standard MCSs
if strcmp(c_sim.version,'802.11a')
    c_sim.drates = 0:7;
    
elseif strcmp(c_sim.version,'802.11n')
    c_sim.drates = 0:7;
    
elseif strcmp(c_sim.version, '802.11ac')
    if c_sim.w_channel == 20
        switch c_sim.n_streams
            case 1
                c_sim.drates = 0:8;
            case 2
                c_sim.drates = 0:8;
            case 3
                c_sim.drates = 0:9;
            case 4
                c_sim.drates = 0:8;
            case 5
                c_sim.drates = 0:8;
            case 6
                c_sim.drates = 0:9;
            case 7
                c_sim.drates = 0:8;
            case 8
                c_sim.drates = 0:8;
        end
        
    elseif c_sim.w_channel == 40
        c_sim.drates = 0:9;
        
    elseif c_sim.w_channel == 80
        switch c_sim.n_streams
            case 1
                c_sim.drates = 0:9;
            case 2
                c_sim.drates = 0:9;
            case 3
                c_sim.drates = [0:5,7:9];
            case 4
                c_sim.drates = 0:9;
            case 5
                c_sim.drates = 0:9;
            case 6
                c_sim.drates = 0:8;
            case 7
                c_sim.drates = [0:5,7:9];
            case 8
                c_sim.drates = 0:9;
        end
        
    elseif c_sim.w_channel == 160
        switch c_sim.n_streams
            case 1
                c_sim.drates = 0:9;
            case 2
                c_sim.drates = 0:9;
            case 3
                c_sim.drates = 0:8;
            case 4
                c_sim.drates = 0:9;
            case 5
                c_sim.drates = 0:9;
            case 6
                c_sim.drates = 0:9;
            case 7
                c_sim.drates = 0:9;
            case 8
                c_sim.drates = 0:9;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Channel Parameters

% AWGN channel enable/disable
c_sim.chan_awgn = true;

% Multipath channel model
c_sim.chan_multipath = 'B';
% 'off' for freq. flat channel
% ETSI channel model: 'A','B','C','D', 'E','UMTS_A' or 'UMTS_B'
c_sim.chan_fixed = true;  % 'true' if channel is fixed for whole simulation
c_sim.chan_norm = 0;       % normalise channel power to c_sim.chan_norm,
% don't normalise if c_sim.chan_norm == 0
c_sim.chan_vel = -1;       % mobile velocity in m/s (if vel >= 0,
% a Doppler spread of at least 5 Hz is considered
% if vel == -1, independent channel samples are
% generated for each packet

c_sim.frame_interval = .002; % time interval between transmission of
% consecutive frames (in seconds), used for
% channel update

c_sim.ch_rolloff = .1875; % roll-off factor for Doppler filter

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Receiver Parameters

% Channel estimation
% employ channel estimation? 'off','zf,'mmse'
c_sim.chan_est = 'off';
% MMSE-channel-estimator parameters
c_sim.chan_est_len = 16; % estimated channel length
c_sim.chan_est_snr = 20; % estimated SNR

% BCC Decoder
c_sim.dec_delay = 32; % decoding delay in trellis states for Viterbi decoder

%LDPC Decoder
c_sim.ldpc_max_it = 10; % maximum number of LDPC iterations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Derived Parameters and Parameters from the 802.11 standards
% (DO NOT CHANGE!!!!!)
% Legacy 802.11a Parameters
c_sim.legacy.w_channel = 20;
c_sim.legacy.Nfft = 64;
c_sim.legacy.n_data_subc = 48;
c_sim.legacy.c_ps_index = [39:43,45:57,59:64,2:7,9:21,23:27];
c_sim.legacy.pilot_index = [44,58,8,22];
c_sim.legacy.pilot = [1,1,1,-1];
c_sim.legacy.sampling_freq = 20e6;


%number of subcarries
if strcmp(c_sim.version,'802.11a')
    
    if c_sim.w_channel ~= 20
        error ('invalid channel bandwith for IEEE 802.11a')
    end
    if ~strcmp(c_sim.cyclic_prefix,'long')
        error ('invalid cyclic prefix for IEEE 802.11a')
    end
    if c_sim.antennas(1) > 1
        error('invalid number of transmit antennas')
    end
    
    parameters = hsr_version_parameters();
    c_sim.pilot = hsr_values_pilots();
    
elseif strcmp(c_sim.version,'802.11n')
    
    if ~strcmp(c_sim.chan_est,'off')
        warning ('channel estimate not tested for 802.11n');
    end
    
    if c_sim.antennas(1) > 4
        error('number of transmit antennas currently not supported');
    end
    
    if c_sim.antennas(2) > 4
        error('number of receive antennas currently not supported');
    end
    
    if c_sim.antennas(1) > 4
        error('invalid number of transmit antennas');
    end
    
    if c_sim.n_streams > 4
        error('invalid number of spatial streams')
    end
    
    if c_sim.n_streams > min(c_sim.antennas)
        error ('number of spatial streams cannot be greater than number of antennas');
    end
    
    parameters = hsr_version_parameters();
    c_sim.pilot = hsr_values_pilots();
    
elseif strcmp(c_sim.version,'802.11ac')
    
    if c_sim.antennas(1) > 8
        error('number of transmit antennas currently not supported')
    end
    
    if c_sim.antennas(2) > 8
        error('number of receive antennas currently not supported')
    end
    
    if c_sim.n_streams > 8
        error('invalid number of spatial streams')
    end
    
    if c_sim.n_streams > min(c_sim.antennas)
        error ('number of spatial streams cannot be greater than number of antennas');
    end
    
    parameters = hsr_version_parameters();
    c_sim.pilot = hsr_values_pilots();
    
else
    error('invalid standards version')
end

c_sim.Nfft = parameters.Nfft;
c_sim.Nsd = parameters.Nsd;
c_sim.Nsd_index = parameters.Nsd_index;
c_sim.Nsp = parameters.Nsp;
c_sim.Nsp_index = parameters.Nsp_index;
c_sim.sampling_freq = parameters.sampling_freq;
c_sim.Tdata = parameters.Tdata;
c_sim.cp_length = parameters.cp_length;
c_sim.cp_time = parameters.cp_time;
c_sim.Tsym = parameters.Tsym;

c_sim.legacy.cp_length = c_sim.Nfft/4;

HEADER_LENGTH = 24;
CRC_LENGTH = 4;
c_sim.psdu_len = c_sim.data_len + HEADER_LENGTH + CRC_LENGTH;
c_sim.service_length = 16;
if strcmp(c_sim.encoder,'BCC')
    c_sim.bcc_tail = 6;
elseif strcmp(c_sim.encoder,'LDPC')
    c_sim.bcc_tail = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Start simulation

if exist('L2S','var') == 0 % Only run this section if not called by L2S script
    
    [per,ber,C_channel] = hsr_sim(parameters);
    
    filename = ['results_' datestr(now, 'yy-mm-dd-HHMM') '.mat'];
    save(filename, 'c_sim', 'ber', 'per');
    
end