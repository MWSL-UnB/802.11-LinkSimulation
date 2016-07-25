function [leg] = hsr_legacy()

leg.channel = 20;

leg.Nfft = 64;          % number of subcarriers in a OFDM symbol
  
leg.Nsd = 48;           % number of data subcarriers
leg.Nsd_index = [-26:-22,-20:-8,-6:-1,1:6,8:20,22:26];      % data subcarriers index
leg.Nsd_index = [(leg.Nsd_index(1:leg.Nsd/2) + leg.Nfft) leg.Nsd_index((leg.Nsd/2 + 1):end)];
leg.Nsd_index = ones(1,leg.Nsd) + leg.Nsd_index;
    
leg.Nsp = 4;            % number of pilot subcarriers
leg.Nsp_index = [-21,-7,7,21];      % pilots subcarriers index
leg.Nsp_index = [(leg.Nsp_index(1:leg.Nsp/2) + leg.Nfft) leg.Nsp_index((leg.Nsp/2 + 1):end)];
leg.Nsp_index = ones(1,leg.Nsp) + leg.Nsp_index;
leg.Nsp_values = [1,1,1,-1];

leg.sampling_freq = 20e6;

end

