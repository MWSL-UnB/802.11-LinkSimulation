function [output] = hsr_segment_deparser(way,Nes,Nbpsc,input)

global c_sim;

channel = c_sim.w_channel;

Nss = size(input,1);
Ncbpss = size(input,2);
output = zeros(Nss,2*Ncbpss);

if channel == 160
    
    if strcmp(way,'transmission')
        for k = 1:2*Ncbpss
            if(k <= Ncbpss)
                output(:,k) = input(:,k,1);
            else
                output(:,k) = input(:,k - Ncbpss,2);
            end
        end
        
    elseif strcmp(way,'reception')
        s = max(1,Nbpsc/2);
        L = Nes*s;
        
        for r = 1:2
            q = 1;
    
            if r == 1
                a = 1;
            else
                a = 0;
            end
    
            for p = r:2:(2*Ncbpss)/L - a
                output(:,(p - 1)*L + 1:p*L) = input(:,(q - 1)*L + 1:q*L,r);
                q = q + 1;
            end
        end
        
    end
    
else
    for k = 1:Ncbpss
        output(:,k) = input(:,k,:);
    end
end

end

