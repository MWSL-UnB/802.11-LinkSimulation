function [output] = hsr_stream_deparser(Ncbps,Nbpsc,Nes,input)

global c_sim

Nss = c_sim.n_streams;

Nbpscs = Nbpsc;
s = max(1,Nbpscs/2);
S = s*Nss;
Ncbpss = size(input,2);

Nblock = floor(Ncbps/(Nes*S));
M = (Ncbps - Nblock*Nes*S)/(s*Nes);

L = (Ncbpss*Nss)/Nes;
output = zeros(Nes,L);

if M == 0
    for m = 1:Nes
        k = 1;
        for n = m:Nes:Ncbpss/s
            ingang = input(:,(n - 1)*s + 1:n*s);
            utgang = ingang.';
            output(m,(k - 1)*S + 1:k*S) = reshape(utgang,[1,S]);
            k = k + 1;
        end
    end
    
else
    for m = 1:Nes
        k = 1;
        for n = m:Nes:Nblock*Nes
            inngang = input(:,(n - 1)*s + 1:n*s);
            utgang = inngang.';
            output(m,(k - 1)*S + 1:k*S) = reshape(utgang,[1,S]);
            k = k + 1;        
        end
    end
    
    if Nss == 5
        for m = 1:Nes
            inngang = input(m,(Nblock*Nes*s + 1):(Nblock*Nes*s + s));
            utgang = inngang.';
            output(m,(Nblock*Nes*s + 1):L) = reshape(utgang,[1,s*M]);
        end
        
    elseif Nss == 7
        x = 1;
        y = M;
        w = y - x + 1;
        z = y;
        n = 1;
        inngang = zeros(M,s);
        for m = 1:Nes
            if x <= (Nes - M + 1)
                inngang(1:w,1:s) = input(x:z,(Nblock*Nes*s + (n - 1)*s + 1):(Nblock*Nes*s + n*s));
                utgang = inngang.';
                output(m,(Nblock*Nes*s + 1):L) = reshape(utgang,[1,s*M]);
                x = z + 1;
                if x > (Nes - M + 1)
                    y = Nes;
                    w = y - x + 1;
                    z = M - w;
                else
                    y = x + M - 1;
                    w = y - x + 1;
                    z = y;
                end
                
            else
                inngang(1:w,1:s) = input(x:y,(Nblock*Nes*s + (n - 1)*s + 1):(Nblock*Nes*s + n*s));
                n = n + 1;
                inngang(w + 1:M,1:s) = input(1:z,(Nblock*Nes*s + (n - 1)*s + 1):(Nblock*Nes*s + n*s));
                utgang = inngang.';
                output(m,(Nblock*Nes*s + 1):L) = reshape(utgang,[1,s*M]);
                x = z + 1;
                if x > (Nes - M + 1)
                    y = Nes;
                    w = y - x + 1;
                    z = M - w;
                else
                    y = x + M - 1;
                    w = y - x + 1;
                    z = y;
                end
            end
        end
        
    end
    
end

end

