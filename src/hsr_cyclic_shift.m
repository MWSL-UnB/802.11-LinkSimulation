function [cs] = hsr_cyclic_shift(type,Ntx)

global c_sim

version = c_sim.version;

% same preamble is transmitted from all antennas with circular shifts
if strcmp(version,'802.11n')
    % cyclic shift for L-STF, L-LTF, L-SIG and HT-SIG
    if strcmp(type,'legacy')
        switch Ntx
            case 1
                cs = 0;
            case 2
                cs = [0 200];
            case 3
                cs = [0 100 200];
            case 4
                cs = [0 50 100 150];        
        end
    elseif strcmp(type,'HT');
        % cyclic shift for HT-STF, HT-LTF and Data Field
        switch Ntx
            case 1
                cs = 0;
            case 2
                cs = [0 400];
            case 3
                cs = [0 400 200];
            case 4
                cs = [0 400 200 600];   
        end
    end
elseif strcmp(version,'802.11ac')
    % cyclic shift for L-STF, L-LTF, L-SIG and VHT-SIG-A
    if strcmp(type,'legacy')
        switch Ntx
            case 1
                cs = 0;
            case 2
                cs = [0 200];
            case 3
                cs = [0 100 200];
            case 4
                cs = [0 50 100 150];
            case 5
                cs = [0 175 25 50 75];
            case 6
                cs = [0 200 25 150 175 125];
            case 7
                cs = [0 200 150 25 175 75 50];
            case 8
                cs = [0 175 150 125 25 100 50 200];
        end
    elseif strcmp(type,'VHT')
        % cyclic shift for VHT-STF, VHT-LTF, VHT-SIG-B and Data Field
        switch Ntx
            case 1
                cs = 0;
            case 2
                cs = [0 400];
            case 3
                cs = [0 400 200];
            case 4
                cs = [0 400 200 600];
            case 5
                cs = [0 400 200 600 350];
            case 6
                cs = [0 400 200 600 350 650];
            case 7
                cs = [0 400 200 600 350 650 100];
            case 8
                cs = [0 400 200 600 350 650 100 750];
        end
    end

end

