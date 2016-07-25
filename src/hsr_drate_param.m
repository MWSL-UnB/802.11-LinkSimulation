function [sim_param] = hsr_drate_param(mcs_index,legacy)

%    data_rate       data rate in Mbps
%    modulation      modulation (string)
%    Nbpsc           bits/subcarrier (integer)
%    code_rate       code rate (float)
%    Ndbps           Ndbps (data bits/OFDM symbol) (integer)
%    Ncbps           Ncbps (code bits/OFDM symbol)(integer)
%    Nes             number of BCC encoders used

global c_sim

sim_param.rateIndex = mcs_index;
if ~exist('legacy','var')
    legacy = false;
end

if strcmp(c_sim.version,'802.11a') || legacy
    Nsd = 48;
    Tsym = 4;
    switch mcs_index
        case 0
            sim_param.Nes = 1;
            sim_param.modulation = 'bpsk';
            sim_param.Nbpsc = 1;
            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*Nsd;
            sim_param.code_rate = 1/2;
            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
            sim_param.data_rate = sim_param.Ndbps/Tsym;
        case 1
            sim_param.Nes = 1;
            sim_param.modulation = 'bpsk';
            sim_param.Nbpsc = 1;
            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*Nsd;
            sim_param.code_rate = 3/4;
            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
            sim_param.data_rate = sim_param.Ndbps/Tsym;
        case 2
            sim_param.Nes = 1;
            sim_param.modulation = 'qpsk';
            sim_param.Nbpsc = 2;
            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*Nsd;
            sim_param.code_rate = 1/2;
            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
            sim_param.data_rate = sim_param.Ndbps/Tsym;
        case 3
            sim_param.Nes = 1;
            sim_param.modulation = 'qpsk';
            sim_param.Nbpsc = 2;
            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*Nsd;
            sim_param.code_rate = 3/4;
            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
            sim_param.data_rate = sim_param.Ndbps/Tsym;
        case 4
            sim_param.Nes = 1;  
            sim_param.modulation = '16qam';
            sim_param.Nbpsc = 4;
            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*Nsd;
            sim_param.code_rate = 1/2;
            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
            sim_param.data_rate = sim_param.Ndbps/Tsym;
        case 5
            sim_param.Nes = 1;
            sim_param.modulation = '16qam';
            sim_param.Nbpsc = 4;
            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*Nsd;
            sim_param.code_rate = 3/4;
            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
            sim_param.data_rate = sim_param.Ndbps/Tsym;
        case 6
            sim_param.Nes = 1;
            sim_param.modulation = '64qam';
            sim_param.Nbpsc = 6;
            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*Nsd;
            sim_param.code_rate = 2/3;
            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
            sim_param.data_rate = sim_param.Ndbps/Tsym;
        case 7
            sim_param.Nes = 1;
            sim_param.modulation = '64qam';
            sim_param.Nbpsc = 6;
            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*Nsd;
            sim_param.code_rate = 3/4;
            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
            sim_param.data_rate = sim_param.Ndbps/Tsym;
        otherwise
            error('unknown mcs_index');
    end
elseif strcmp(c_sim.version,'802.11n')
    switch c_sim.w_channel
        case 20
            switch c_sim.n_streams
                case 1
                    switch mcs_index
                        case 0
                           sim_param.Nes = 1;
                           sim_param.modulation = 'bpsk';
                           sim_param.Nbpsc = 1;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                           sim_param.Nes = 1; 
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                           sim_param.Nes = 1; 
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                           sim_param.Nes = 1; 
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 2/3;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                           sim_param.Nes = 1; 
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                           sim_param.Nes = 1; 
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 5/6;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                           error('unknown mcs_index');
                    end
                case 2
                    switch mcs_index
                        case 0
                           sim_param.Nes = 1;
                           sim_param.modulation = 'bpsk';
                           sim_param.Nbpsc = 1;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                           sim_param.Nes = 1;
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                           sim_param.Nes = 1;
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                           sim_param.Nes = 1;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 2/3;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                           sim_param.Nes = 1;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                           sim_param.Nes = 1;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 5/6;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                           error('unknown mcs_index');
                    end
                case 3
                    switch mcs_index
                        case 0
                           sim_param.Nes = 1;
                           sim_param.modulation = 'bpsk';
                           sim_param.Nbpsc = 1;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 2/3;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 5/6;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                           error('unknown mcs_index');
                    end
                case 4
                    switch mcs_index
                        case 0
                           sim_param.Nes = 1;
                           sim_param.modulation = 'bpsk';
                           sim_param.Nbpsc = 1;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                           sim_param.Nes = 1; 
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                           sim_param.Nes = 1;
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                           sim_param.Nes = 1;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 2/3;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                           sim_param.Nes = 1;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                           sim_param.Nes = 1;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 5/6;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                           error('unknown mcs_index');
                    end
                otherwise
                    error('number of spatial streams not supported');
            end
        case 40
            switch c_sim.n_streams
                case 1
                    switch mcs_index
                        case 0
                           sim_param.Nes = 1;
                           sim_param.modulation = 'bpsk';
                           sim_param.Nbpsc = 1;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                           sim_param.Nes = 1;
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                           sim_param.Nes = 1;
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                           sim_param.Nes = 1;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 2/3;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                           sim_param.Nes = 1;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                           sim_param.Nes = 1;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 5/6;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                           error('unknown mcs_index');
                    end
                case 2
                    switch mcs_index
                        case 0
                           sim_param.Nes = 1;
                           sim_param.modulation = 'bpsk';
                           sim_param.Nbpsc = 1;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                           sim_param.Nes = 1;
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                           sim_param.Nes = 1;
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                           sim_param.Nes = 1;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 2/3;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                           sim_param.Nes = 1;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                           sim_param.Nes = 1;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 5/6;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                           error('unknown mcs_index');
                    end
                case 3
                    switch mcs_index
                        case 0
                           sim_param.Nes = 1;
                           sim_param.modulation = 'bpsk';
                           sim_param.Nbpsc = 1;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                           sim_param.Nes = 1;
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                           sim_param.Nes = 1;
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                           sim_param.Nes = 2;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 2/3;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                           sim_param.Nes = 2;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                           sim_param.Nes = 2;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 5/6;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                           error('unknown mcs_index');
                    end
                case 4
                    switch mcs_index
                        case 0
                           sim_param.Nes = 1;
                           sim_param.modulation = 'bpsk';
                           sim_param.Nbpsc = 1;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                           sim_param.Nes = 1;
                           sim_param.modulation = 'qpsk';
                           sim_param.Nbpsc = 2;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                           sim_param.Nes = 1;
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 1/2;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                           sim_param.Nes = 2;
                           sim_param.modulation = '16qam';
                           sim_param.Nbpsc = 4;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                           sim_param.Nes = 2;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 2/3;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                           sim_param.Nes = 2;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 3/4;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                           sim_param.Nes = 2;
                           sim_param.modulation = '64qam';
                           sim_param.Nbpsc = 6;
                           sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                           sim_param.code_rate = 5/6;
                           sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                           sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                      otherwise
                           error('unknown mcs_index');
                    end
                otherwise
                    error('number of spatial streams not supported');
            end
        otherwise
            error('invalid bandwidth')
    end     
elseif strcmp(c_sim.version,'802.11ac')
    switch c_sim.w_channel
        case 20
            switch c_sim.n_streams
                case 1
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 2
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 3
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 4
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 5
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 6
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 7
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 2;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 8
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 2;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                otherwise
                    error('number of spatial streams not supported');
            end
        case 40
            switch c_sim.n_streams
                case 1
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;  
                        otherwise
                            error('unknown mcs_index');
                    end
                case 2
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;  
                        otherwise
                            error('unknown mcs_index');
                    end
                case 3
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 4
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 2;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 2;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 5
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 2;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 2;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 6
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 2;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 2;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 7
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 2;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 3;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 3;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;  
                        otherwise
                            error('unknown mcs_index');
                    end
                case 8
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 2;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 3;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 3;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;  
                        otherwise
                            error('unknown mcs_index');
                    end
                otherwise
                    error('number of spatial streams not supported');
            end
        case 80
            switch c_sim.n_streams
                case 1
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 1;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;  
                        otherwise
                            error('unknown mcs_index');
                    end
                case 2
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 2;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 2;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;  
                        otherwise
                            error('unknown mcs_index');
                    end
                case 3
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 2;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 3;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 4
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 2;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 3;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 3;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 3;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 5
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 2;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 2;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 3;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 3;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 3;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 4;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 4;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 6
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 2;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 2;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 3;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 3;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 4;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 4;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 7
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 2;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 2;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 3;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 4;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 6;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 6;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 6;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;  
                        otherwise
                            error('unknown mcs_index');
                    end
                case 8
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 2;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 2;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 3;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 4;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 4;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 6;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 6;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 6;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;  
                        otherwise
                            error('unknown mcs_index');
                    end
                otherwise
                    error('number of spatial streams not supported');
            end
        case 160
            switch c_sim.n_streams
                case 1
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 1;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 2;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 2;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;  
                        otherwise
                            error('unknown mcs_index');
                    end
                case 2
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 1;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 2;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 2;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 3;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 3;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 3;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;  
                        otherwise
                            error('unknown mcs_index');
                    end
                case 3
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 2;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 2;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 3;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 3;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 4;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 4;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 4
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 1;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 2;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 2;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 3;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 4;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 4;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 6;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 6;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 6;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 5
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 2;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 2;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 3;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 4;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 5;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 5;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 6;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 8;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 8;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 6
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 2;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 2;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 3;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 4;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 6;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 6;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 8;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 8;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 9;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        otherwise
                            error('unknown mcs_index');
                    end
                case 7
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 2;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 3;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 4;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 6;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 7;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 7;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 9;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 12;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 12;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;  
                        otherwise
                            error('unknown mcs_index');
                    end
                case 8
                    switch mcs_index
                        case 0
                            sim_param.Nes = 1;
                            sim_param.modulation = 'bpsk';
                            sim_param.Nbpsc = 1;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 1
                            sim_param.Nes = 2;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 2
                            sim_param.Nes = 3;
                            sim_param.modulation = 'qpsk';
                            sim_param.Nbpsc = 2;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 3
                            sim_param.Nes = 4;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 1/2;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 4
                            sim_param.Nes = 6;
                            sim_param.modulation = '16qam';
                            sim_param.Nbpsc = 4;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 5
                            sim_param.Nes = 8;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 2/3;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 6
                            sim_param.Nes = 8;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 7
                            sim_param.Nes = 9;
                            sim_param.modulation = '64qam';
                            sim_param.Nbpsc = 6;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 8
                            sim_param.Nes = 12;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 3/4;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;
                        case 9
                            sim_param.Nes = 12;
                            sim_param.modulation = '256qam';
                            sim_param.Nbpsc = 8;
                            sim_param.Ncbps = c_sim.n_streams*sim_param.Nbpsc*c_sim.Nsd;
                            sim_param.code_rate = 5/6;
                            sim_param.Ndbps = sim_param.code_rate*sim_param.Ncbps;
                            sim_param.data_rate = sim_param.Ndbps/c_sim.Tsym;  
                        otherwise
                            error('unknown mcs_index');
                    end
                otherwise
                    error('number of spatial streams not supported');
            end
        otherwise
            error('invalid bandwidth');
    end
end

switch sim_param.code_rate
    case 1/2
        sim_param.crate_str = '1/2';
    case 2/3
        sim_param.crate_str = '2/3';
    case 3/4
        sim_param.crate_str = '3/4';
    case 5/6
        sim_param.crate_str = '5/6';
    otherwise
        error('unknown code rate')
end

end

