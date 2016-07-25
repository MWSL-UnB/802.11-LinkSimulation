function [output] = hsr_segment_parser(way,Nbpsc,Nes,input)

%only used with a 160MHz channel in 802.11ac
global c_sim

Nss = c_sim.n_streams;
channel = c_sim.w_channel;
Ncbpss = size(input,2);

if channel == 160
    
    if strcmp(way,'transmission')
        Nbpscs = Nbpsc;
        s = max(1,Nbpscs/2);
        Nsubblock = 2;

        output = zeros(Nss,Ncbpss/2,Nsubblock);
        if(mod(Ncbpss,2*s*Nes) == 0)
            for iss = 1:Nss
                for k = 1:(Ncbpss/2)
                    for l = 1:Nsubblock
                        output(iss,k,l) = input(iss,2*s*Nes*floor((k - 1)/(s*Nes)) + (l - 1)*s*Nes + mod((k - 1),s*Nes) + 1);
                    end
                end
            end
        else
            for iss = 1:Nss
                for k = 1:(Ncbpss/2)
                    for l = 1:Nsubblock
                        if(k <= floor(Ncbpss/(2*s*Nes))*s*Nes)
                            output(iss,k,l) = input(iss,2*s*Nes*floor((k - 1)/(s*Nes)) + (l - 1)*s*Nes + mod((k - 1),s*Nes) + 1);
                        else
                            output(iss,k,l) = input(iss,2*s*Nes*floor((k - 1)/(s*Nes)) + 2*s*floor(rem((k - 1),s*Nes)/s) + (l - 1)*s + mod((k - 1),s) + 1);
                        end
                    end
                end
            end
        end
        
    elseif strcmp(way,'reception')
        Ncbpss = size(input,2);
        Nsubblock = 2;
        
        output = zeros(Nss,Ncbpss/2,Nsubblock);
        for n = 1:Ncbpss
            if (n <= Ncbpss/2)
                output(:,n,1) = input(:,n);
            else
                output(:,n - Ncbpss/2,2) = input(:,n);
            end
        end
        
    end
        
else
    Nsubblock = 1;
    output = zeros(Nss,Ncbpss,Nsubblock);
    
    for iss = 1:Nss
        for k = 1:Ncbpss
            for l = 1:Nsubblock
                output(iss,k,l) = input(iss,k);
            end
        end
    end
    
end

end

