function [parameters] = hsr_version_parameters()

global c_sim

if strcmp(c_sim.version,'802.11a')
    switch c_sim.w_channel
        case 20
            parameters.Nfft = 64;          % number of subcarriers in a OFDM symbol
            parameters.Nsd = 48;           % number of data subcarriers
            parameters.Nsd_index = [-26:-22,-20:-8,-6:-1,1:6,8:20,22:26];      % data subcarriers index
            parameters.Nsd_index = [(parameters.Nsd_index(1:parameters.Nsd/2) + parameters.Nfft) parameters.Nsd_index((parameters.Nsd/2 + 1):end)];
            parameters.Nsd_index = ones(1,parameters.Nsd) + parameters.Nsd_index;

            parameters.Nsp = 4;            % number of pilot subcarriers
            parameters.Nsp_index = [-21,-7,7,21];      % pilots subcarriers index
            parameters.Nsp_index = [(parameters.Nsp_index(1:parameters.Nsp/2) + parameters.Nfft) parameters.Nsp_index((parameters.Nsp/2 + 1):end)];
            parameters.Nsp_index = ones(1,parameters.Nsp) + parameters.Nsp_index;

            parameters.sampling_freq = 20e6;
        otherwise
            error ('Invalid c_sim.w_channel bandwith for IEEE 802.11a')
    end
            
    parameters.Tdata = parameters.Nfft/c_sim.w_channel;   % parameters.Nfft duration in samples
            
    if strcmp(c_sim.cyclic_prefix,'long')
        parameters.cp_length = parameters.Nfft/4;
        parameters.cp_time = parameters.cp_length/c_sim.w_channel;
        parameters.Tsym = parameters.cp_time + parameters.Tdata;
    else
        error('Invalid cyclic prefix')
    end    

elseif strcmp(c_sim.version,'802.11n')
    switch c_sim.w_channel
        case 20
            parameters.Nfft = 64;      % number of subcarriers in a OFDM symbol
            parameters.Nsd = 52;       % number of data subcarriers
            parameters.Nsd_index = [-28:-22,-20:-8,-6:-1,1:6,8:20,22:28];
            parameters.Nsd_index = [(parameters.Nsd_index(1:parameters.Nsd/2) + parameters.Nfft) ... 
                                    parameters.Nsd_index((parameters.Nsd/2 + 1):end)];       % data subcarriers index
            parameters.Nsd_index = ones(1,parameters.Nsd) + parameters.Nsd_index;
            
            parameters.Nsp = 4;            % number of pilot subcarriers
            parameters.Nsp_index = [-21,-7,7,21];      % pilots subcarriers index
            parameters.Nsp_index = [(parameters.Nsp_index(1:parameters.Nsp/2) + parameters.Nfft) parameters.Nsp_index((parameters.Nsp/2 + 1):end)];
            parameters.Nsp_index = ones(1,parameters.Nsp) + parameters.Nsp_index;
            
            parameters.sampling_freq = 20e6;
            
        case 40
            parameters.Nfft = 128;     % number of subcarriers in a OFDM symbol
            parameters.Nsd = 108;      % number of data subcarriers
            parameters.Nsd_index = [-58:-54,-52:-26,-24:-12,-10:-2,2:10,12:24,26:52,54:58];
            parameters.Nsd_index = [(parameters.Nsd_index(1:parameters.Nsd/2) + parameters.Nfft) ...
                                    parameters.Nsd_index((parameters.Nsd/2 + 1):end)];       % data subcarriers index
            parameters.Nsd_index = ones(1,parameters.Nsd) + parameters.Nsd_index;
            
            parameters.Nsp = 6;            % number of pilot subcarriers
            parameters.Nsp_index = [-53,-25,-11,11,25,53];      % pilots subcarriers index
            parameters.Nsp_index = [(parameters.Nsp_index(1:parameters.Nsp/2) + parameters.Nfft) ...
                                    parameters.Nsp_index((parameters.Nsp/2 + 1):end)];
            parameters.Nsp_index = ones(1,parameters.Nsp) + parameters.Nsp_index;
            
            parameters.sampling_freq = 40e6;
            
        otherwise
            error ('Invalid c_sim.w_channel bandwith for IEEE 802.11n')
    end
    
    parameters.Tdata = parameters.Nfft/c_sim.w_channel;
            
    if strcmp(c_sim.cyclic_prefix,'long')
        parameters.cp_length = parameters.Nfft/4;
        parameters.cp_time = parameters.cp_length/c_sim.w_channel;
        parameters.Tsym = parameters.cp_time + parameters.Tdata;
    elseif strcmp(c_sim.cyclic_prefix,'short')
        parameters.cp_length = parameters.Nfft/8;
        parameters.cp_time = parameters.cp_length/c_sim.w_channel;
        parameters.Tsym = parameters.cp_time + parameters.Tdata;
    else
        error('Invalid cyclic prefix')
    end
      
elseif strcmp(c_sim.version,'802.11ac')
    switch c_sim.w_channel
        case 20
            parameters.Nfft = 64;      % number of subcarriers in a OFDM symbol
            parameters.Nsd = 52;       % number of data subcarriers
            parameters.Nsd_index = [-28:-22,-20:-8,-6:-1,1:6,8:20,22:28];
            parameters.Nsd_index = [(parameters.Nsd_index(1:parameters.Nsd/2) + parameters.Nfft) ...
                                    parameters.Nsd_index((parameters.Nsd/2 + 1):end)];       % data subcarriers index
            parameters.Nsd_index = ones(1,parameters.Nsd) + parameters.Nsd_index;
            
            parameters.Nsp = 4;            % number of pilot subcarriers
            parameters.Nsp_index = [-21,-7,7,21];      % pilots subcarriers index
            parameters.Nsp_index = [(parameters.Nsp_index(1:parameters.Nsp/2) + parameters.Nfft) parameters.Nsp_index((parameters.Nsp/2 + 1):end)];
            parameters.Nsp_index = ones(1,parameters.Nsp) + parameters.Nsp_index;
            
            parameters.sampling_freq = 20e6;
                       
        case 40
            parameters.Nfft = 128;     % number of subcarriers in a OFDM symbol
            parameters.Nsd = 108;      % number of data subcarriers
            parameters.Nsd_index = [-58:-54,-52:-26,-24:-12,-10:-2,2:10,12:24,26:52,54:58];
            parameters.Nsd_index = [(parameters.Nsd_index(1:parameters.Nsd/2) + parameters.Nfft) ...
                                    parameters.Nsd_index((parameters.Nsd/2 + 1):end)];       % data subcarriers index
            parameters.Nsd_index = ones(1,parameters.Nsd) + parameters.Nsd_index;
            
            parameters.Nsp = 6;            % number of pilot subcarriers
            parameters.Nsp_index = [-53,-25,-11,11,25,53];      % pilots subcarriers index
            parameters.Nsp_index = [(parameters.Nsp_index(1:parameters.Nsp/2) + parameters.Nfft) ...
                                    parameters.Nsp_index((parameters.Nsp/2 + 1):end)];
            parameters.Nsp_index = ones(1,parameters.Nsp) + parameters.Nsp_index;
            
            parameters.sampling_freq = 40e6;
                   
        case 80
            parameters.Nfft = 256;     % number of subcarriers in a OFDM symbol
            parameters.Nsd = 234;      % number of data subcarriers
            parameters.Nsd_index = [-122:-104,-102:-76,-74:-40,-38:-12,-10:-2,2:10,12:38,40:74,76:102,104:122];
            parameters.Nsd_index = [(parameters.Nsd_index(1:parameters.Nsd/2) + parameters.Nfft) ...
                                    parameters.Nsd_index((parameters.Nsd/2 + 1):end)];       % data subcarriers index
            parameters.Nsd_index = ones(1,parameters.Nsd) + parameters.Nsd_index;
            
            parameters.Nsp = 8;            % number of pilot subcarriers
            parameters.Nsp_index = [-103,-75,-39,-11,11,39,75,103];      % pilots subcarriers index
            parameters.Nsp_index = [(parameters.Nsp_index(1:parameters.Nsp/2) + parameters.Nfft) ...
                                    parameters.Nsp_index((parameters.Nsp/2 + 1):end)];
            parameters.Nsp_index = ones(1,parameters.Nsp) + parameters.Nsp_index;
            
            parameters.sampling_freq = 80e6;
        
        case 160
            parameters.Nfft = 512;     % number of subcarriers in a OFDM symbol
            parameters.Nsd = 468;      % number of data subcarriers
            parameters.Nsd_index = [-250:-232,-230:-204,-202:-168,-166:-140,-138:-130,-126:-118 ...
                         -116:-90,-88:-54,-52:-26,-24:-6,6:24,26:52,54:88,90:116,118:126 ...
                         130:138,140:166,168:202,204:230,232:250];
            parameters.Nsd_index = [(parameters.Nsd_index(1:parameters.Nsd/2) + parameters.Nfft) ...
                                    parameters.Nsd_index((parameters.Nsd/2 + 1):end)];       % data subcarriers index
            parameters.Nsd_index = ones(1,parameters.Nsd) + parameters.Nsd_index;
            
            parameters.Nsp = 16;            % number of pilot subcarriers
            parameters.Nsp_index = [-231,-203,-167,-139,-117,-89,-53,-25,25,53,89,117,139,167,203,231];      % pilots subcarriers index
            parameters.Nsp_index = [(parameters.Nsp_index(1:parameters.Nsp/2) + parameters.Nfft) ...
                                    parameters.Nsp_index((parameters.Nsp/2 + 1):end)];
            parameters.Nsp_index = ones(1,parameters.Nsp) + parameters.Nsp_index;
            
            parameters.sampling_freq = 160e6;
        
        otherwise
            error ('Invalid c_sim.w_channel bandwith for IEEE 802.11n')
    end
    
    parameters.Tdata = parameters.Nfft/c_sim.w_channel;
            
    if strcmp(c_sim.cyclic_prefix,'long')
        parameters.cp_length = parameters.Nfft/4;
        parameters.cp_time = parameters.cp_length/c_sim.w_channel;
        parameters.Tsym = parameters.cp_time + parameters.Tdata;
    elseif strcmp(c_sim.cyclic_prefix,'short')
        parameters.cp_length = parameters.Nfft/8;
        parameters.cp_time = parameters.cp_length/c_sim.w_channel;
        parameters.Tsym = parameters.cp_time + parameters.Tdata;
    else
        error('Invalid cyclic prefix')
    end
            
end

