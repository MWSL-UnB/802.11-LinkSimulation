function [pilot] = hsr_values_pilots()

global c_sim

if strcmp(c_sim.version,'802.11a')
    pilot = [1,1,1,-1];
    
elseif strcmp(c_sim.version,'802.11n')
    switch c_sim.w_channel
        case 20
            if c_sim.n_sts == 1
                pilot = [1,1,1,-1];
            elseif c_sim.n_sts == 2
                pilot = [1,1,-1,-1 ; 1,-1,-1,1];
            elseif c_sim.n_sts == 3
                pilot = [1,1,-1,-1 ; 1,-1,1,-1 ; -1,1,1,-1];
            elseif c_sim.n_sts == 4;
                pilot = [1,1,1,-1 ; 1,1,-1,1 ; 1,-1,1,1 ; -1,1,1,1];
            end
        case 40
            if c_sim.n_sts == 1
                pilot = [1,1,1,-1,-1,1];
            elseif c_sim.n_sts == 2
                pilot = [1,1,-1,-1,-1,-1 ; 1,1,1,-1,1,1];
            elseif c_sim.n_sts == 3
                pilot = [1,1,-1,-1,-1,-1 ; 1,1,1,-1,1,1 ; 1,-1,1,-1,-1,1];
            elseif c_sim.n_sts == 4
                pilot = [1,1,-1,-1,-1,-1, ; 1,1,1,-1,1,1 ; 1,-1,1,-1,-1,1 ; -1,1,1,1,-1,1];
            end    
    end
            
elseif strcmp(c_sim.version,'802.11ac')
    switch c_sim.w_channel
        case 20
           pilot = [1,1,1,-1];
        case 40
            pilot = [1,1,1,-1,-1,1];
        case 80
            pilot = [1,1,1,-1,-1,1,1,1];
        case 160
            pilot = [1,1,1,-1,-1,1,1,1,1,1,1,-1,-1,1,1,1];
    end
end
end