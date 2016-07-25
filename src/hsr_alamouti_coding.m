function [output] = hsr_alamouti_coding(Nsym,input)

global c_sim;

version = c_sim.version;
Nsts = c_sim.n_sts;
Nsd = c_sim.Nsd;
streams = c_sim.n_streams;

if strcmp(version,'802.11n')
    switch Nsts
        case 2
            s1 = input(:,1:2:end,1);
            s2 = input(:,2:2:end,1);
                
            output = zeros(Nsd,Nsym,Nsts);
            
            output(:,1:2:end,1) = s1;
            output(:,1:2:end,2) = s2;
            
            output(:,2:2:end,1) = -conj(s2);
            output(:,2:2:end,2) = conj(s1);
        case 3
            s1 = input(:,1:2:end,1);
            s2 = input(:,2:2:end,1);
            s3 = input(:,1:2:end,2);
            s4 = input(:,2:2:end,2);
                
            output = zeros(Nsd,Nsym,Nsts);
            
            output(:,1:2:end,1) = s1;
            output(:,1:2:end,2) = s2;
            output(:,1:2:end,3) = s3;
            
            output(:,2:2:end,1) = -conj(s2);
            output(:,2:2:end,2) = conj(s1);
            output(:,2:2:end,3) = s4;
        case 4
            if streams == 2
                s1 = input(:,1:2:end,1);
                s2 = input(:,2:2:end,1);
                s3 = input(:,1:2:end,2);
                s4 = input(:,2:2:end,2);

                output = zeros(Nsd,Nsym,Nsts);
                
                output(:,1:2:end,1) = s1;
                output(:,1:2:end,2) = s2;
                output(:,1:2:end,3) = s3;
                output(:,1:2:end,4) = s4;
                
                output(:,2:2:end,1) = -conj(s2);
                output(:,2:2:end,2) = conj(s1);
                output(:,2:2:end,3) = -conj(s4);
                output(:,2:2:end,4) = conj(s4);
                    
            elseif streams == 3
                s1 = input(:,1:2:end,1);
                s2 = input(:,2:2:end,1);
                s3 = input(:,1:2:end,2);
                s4 = input(:,2:2:end,2);
                s5 = input(:,1:2:end,3);
                s6 = input(:,2:2:end,3);
                    
                output = zeros(Nsd,Nsym,Nsts);
                
                output(:,1:2:end,1) = s1;
                output(:,1:2:end,2) = s2;
                output(:,1:2:end,3) = s3;
                output(:,1:2:end,4) = s4;
                
                output(:,2:2:end,1) = -conj(s2);
                output(:,2:2:end,2) = conj(s1);
                output(:,2:2:end,3) = s5;
                output(:,2:2:end,4) = s6;
            end
    end
    
elseif strcmp(version,'802.11ac')
    switch Nsts
        case 2
            s1 = input(:,1:2:end,1);
            s2 = input(:,2:2:end,1);
                
            output = zeros(Nsd,Nsym,Nsts);
            
            output(:,1:2:end,1) = s1;
            output(:,1:2:end,2) = s2;
            
            output(:,2:2:end,1) = -conj(s2);
            output(:,2:2:end,2) = conj(s1);
        case 4
            s1 = input(:,1:2:end,1);
            s2 = input(:,2:2:end,1);
            s3 = input(:,1:2:end,2);
            s4 = input(:,2:2:end,2);

            output = zeros(Nsd,Nsym,Nsts);
            
            output(:,1:2:end,1) = s1;
            output(:,1:2:end,2) = s2;
            output(:,1:2:end,3) = s3;
            output(:,1:2:end,4) = s4;
            
            output(:,2:2:end,1) = -conj(s2);
            output(:,2:2:end,2) = conj(s1);
            output(:,2:2:end,3) = -conj(s4);
            output(:,2:2:end,4) = conj(s3);
        case 6
            s1 = input(:,1:2:end,1);
            s2 = input(:,2:2:end,1);
            s3 = input(:,1:2:end,2);
            s4 = input(:,2:2:end,2);
            s5 = input(:,1:2:end,3);
            s6 = input(:,2:2:end,3);
            
            output = zeros(Nsd,Nsym,Nsts);
            
            output(:,1:2:end,1) = s1;
            output(:,1:2:end,2) = s2;
            output(:,1:2:end,3) = s3;
            output(:,1:2:end,4) = s4;
            output(:,1:2:end,5) = s5;
            output(:,1:2:end,6) = s6;
            
            output(:,2:2:end,1) = -conj(s2);
            output(:,2:2:end,2) = conj(s1);
            output(:,2:2:end,3) = -conj(s4);
            output(:,2:2:end,4) = conj(s3);
            output(:,2:2:end,5) = -conj(s6);
            output(:,2:2:end,6) = conj(s5);
            
        case 8
            s1 = input(:,1:2:end,1);
            s2 = input(:,2:2:end,1);
            s3 = input(:,1:2:end,2);
            s4 = input(:,2:2:end,2);
            s5 = input(:,1:2:end,3);
            s6 = input(:,2:2:end,3);
            s7 = input(:,1:2:end,4);
            s8 = input(:,2:2:end,4);
            
            output = zeros(Nsd,Nsym,Nsts);
            
            output(:,1:2:end,1) = s1;
            output(:,1:2:end,2) = s2;
            output(:,1:2:end,3) = s3;
            output(:,1:2:end,4) = s4;
            output(:,1:2:end,5) = s5;
            output(:,1:2:end,6) = s6;
            output(:,1:2:end,7) = s7;
            output(:,1:2:end,8) = s8;
            
            output(:,1:2:end,1) = -conj(s2);
            output(:,1:2:end,2) = conj(s1);
            output(:,1:2:end,3) = -conj(s4);
            output(:,1:2:end,4) = conj(s3);
            output(:,1:2:end,5) = -conj(s6);
            output(:,1:2:end,6) = conj(s5);
            output(:,1:2:end,7) = -conj(s8);
            output(:,1:2:end,8) = conj(s7);
    end
end

output = output/sqrt(Nsts);

end

