function [per,ber,C_channel] = hsr_sim(parameters)

global c_sim;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Simulation

c_sim.EsN0s = [];
ber = zeros(length(c_sim.drates),length(c_sim.EbN0s));
per = zeros(length(c_sim.drates),length(c_sim.EbN0s));
max_ebn0 = length(c_sim.EbN0s);

% initialize transmitter
if c_sim.timedomwindowing
    hsr_timewindow('init',c_sim.windowlength);
end

% initialize receiver
if strcmp(c_sim.chan_est,'mmse')
    hsr_channel_est('init',c_sim.chan_est_len,c_sim.chan_est_snr);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Simulation Loop

% Loop for all specified data rates (MCSs)
for drate_index = 1:length(c_sim.drates)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % initialize simulation for a particular MCS
    
    % initialize random number generators
    hsr_initrnd(c_sim.rnd_state);
    
    % initialize 'txvector', a vector of transmission parameters
    txvector.length = c_sim.psdu_len; % number of bytes per packet
    txvector.datarate = c_sim.drates(drate_index); % data rate index,
    % see hsr_drate_param.m
    txvector.service = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % service field
    
    % get simulation parameters for this MCS from lookup-table
    mcs_param = hsr_drate_param(txvector.datarate);
    
    % convert Eb/N0 to Es/N0
    c_sim.EsN0s = [c_sim.EsN0s; ...
        c_sim.EbN0s + db(mcs_param.Ndbps/c_sim.Nsd)];
    
    %initialize multipath channel
    if ~strcmp(c_sim.chan_multipath,'off')
        %ETSI channel model
        hsr_chan_multipath('init',c_sim.chan_multipath, ...
            1/c_sim.sampling_freq,c_sim.ch_rolloff, ...
            c_sim.rnd_state,c_sim.antennas, ...
            c_sim.chan_vel,c_sim.frame_interval/2);
    else
        warning('Multipath Channel disabled');
    end
    
    if c_sim.chan_fixed
        
        warning('Channel is constant for all packets');
        
        % channel will be constant for all packets
        if ~strcmp(c_sim.chan_multipath,'off')
            c = hsr_chan_multipath('fade',c_sim.chan_norm);
        else
            c = 1;
        end
    end
    
    %initialize BER and PER measurements
    nbits = zeros(1,length(c_sim.EbN0s));
    nberr = zeros(1,length(c_sim.EbN0s));
    npcks = zeros(1,length(c_sim.EbN0s));
    nperr = zeros(1,length(c_sim.EbN0s));
    
    min_ebn0 = 1; % minimum Eb/N0 index
    
    % Run simulation for all packets
    for packcount = 1:c_sim.max_npackets
        PSDU = randi([0,1],[1,8*txvector.length]); %random PSDU
        
        if ~c_sim.chan_fixed
            % update time-variant channel
            % obtain channel impulse response
            if ~strcmp(c_sim.chan_multipath,'off')
                c = hsr_chan_multipath('fade',c_sim.chan_norm);
            else
                c = 1;
            end
        end
        C_channel = fft(c,parameters.Nfft,2); % channel in frequency domain
        
        % simulation of one OFDM burst
        
        % generate packet to be transmitted
        % air_tx -> transmitted packet in time tomain
        % scr_init -> scrambler initialization
        [air_tx,~,scr_init,ldpc] = hsr_transmitter(txvector,PSDU);
        
        % multipath channel
        if ~strcmp(c_sim.chan_multipath,'off')
            air_tx2 = hsr_chan_multipath('downlink',air_tx);
        else
            air_tx2 = air_tx;
        end
        
        % Loop for all specified EbN0 values
        for ebn0_index = min_ebn0:max_ebn0
            
            % temporary signal with noise
            air = air_tx2;
            if c_sim.chan_awgn
                [air,nvar] = hsr_chan_awgn(air,mcs_param.modulation, ...
                    mcs_param.code_rate, ...
                    c_sim.EbN0s(ebn0_index));
            else
                nvar = 0;
            end;
            
            % inner receiver signal processing (packet disassembling, FFT)
            [data,~,long_preamble] = hsr_receiver_inner(air);
            
            if ~strcmp(c_sim.chan_est,'off')
                % estimate channel
                C_channel_eq = hsr_channel_est(c_sim.chan_est,long_preamble);
            else
                % use perfect knowledge
                C_channel_eq = C_channel;
            end
            
            %frequency-domain equalizer
            [data,Hchannel,~,sigma] = hsr_pre_equalizer(data,C_channel_eq);
            
            if c_sim.stbc == true
                [data,sigmaw2r] = hsr_alamouti_decoding(data,Hchannel,sigma);
            else
                [data,sigmaw2r] = hsr_equalizer(data,Hchannel,sigma);
            end
            
            data = hsr_receiver_outer(data,sigmaw2r,mcs_param, ...
                scr_init, ...
                ldpc,c_sim.EbN0s(ebn0_index));
            
            % calculate number of errors
            nerr = sum(data ~= [txvector.service PSDU]);
            
            if nerr > 0
                npcks(ebn0_index) = npcks(ebn0_index) + 1;
                nperr(ebn0_index) = nperr(ebn0_index) + 1;
                
                nberr(ebn0_index) = nberr(ebn0_index) + nerr;
                nbits(ebn0_index) = nbits(ebn0_index) + length(data);
            else
                npcks(ebn0_index:max_ebn0) = npcks(ebn0_index:max_ebn0) + 1;
                nbits(ebn0_index:max_ebn0) = nbits(ebn0_index:max_ebn0) + ...
                    length(data);
                break;
            end
            
        end %loop for EbN0s
        
        if (nperr(min_ebn0) >= c_sim.max_pack_errors && ...
                npcks(min_ebn0) >= c_sim.min_npackets)
            min_ebn0 = min_ebn0 + 1;
        end
        
        if ~rem(packcount,c_sim.display_npack)
            fprintf('\t\t%d packets\n',packcount);
        end
        
        if min_ebn0 > max_ebn0
            break;
        end
        
    end; % bursts loop
    
    ber(drate_index,:) = (nberr.*(nberr >= c_sim.min_bit_errors))./nbits;
    per(drate_index,:) = (nperr.*(nperr >= c_sim.min_pack_errors))./npcks;
    
    disp(strcat(datestr(now),'   : ',num2str(mcs_param.data_rate), ' Mb/s  mod: ', ...
        upper(mcs_param.modulation), '  rate: ',mcs_param.crate_str));
    
    for ebn0_index = 1:max_ebn0
        disp(strcat('          EbN0: ',num2str(c_sim.EbN0s(ebn0_index)), ...
            ' ber: ',num2str(ber(drate_index,ebn0_index)), ...
            ' per: ',num2str(per(drate_index,ebn0_index))));
    end
end; %drate loop;

end