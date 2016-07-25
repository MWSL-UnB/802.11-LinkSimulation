function [output] = hsr_stream_parser(Nbpsc,Ncbps,Nes,input)

global c_sim;

version = c_sim.version;
Nss = c_sim.n_streams;

if strcmp(version,'802.11n')
    Nbpscs = Nbpsc;
    s = max(1,Nbpscs/2);

    [d,e] = size(input);
    Ncbpss = (d*e)/Nss;

    k = 0:Ncbpss - 1;
    j = mod(floor(k/s),Nes);
    j = j + 1;

    i = zeros(Nss,Ncbpss);
    output = zeros(Nss,Ncbpss);
    for k = 1:Ncbpss;
        for iss = 1:Nss;
            i(iss,k) = 1 + (iss - 1)*s + s*Nss*floor((k - 1)/(Nes*s)) + mod((k - 1),s);
            output(iss,k) = input(j(k),i(iss,k));
        end
    end
    
elseif strcmp(version,'802.11ac')
    Nbpscs = Nbpsc;
    s = max(1,Nbpscs/2);
    S = s*Nss;
    [d,e] = size(input);
    Ncbpss = (d*e)/Nss;

    Nblock = floor(Ncbps/(Nes*S));
    M = (Ncbps - Nblock*Nes*S)/(s*Nes);

    if M == 0
        k = 0:Ncbpss - 1;
        j = mod(floor(k/s),Nes);
        j = j + 1;

        i = zeros(Nss,Ncbpss);
        output = zeros(Nss,Ncbpss);

        for k = 1:Ncbpss;
            for iss = 1:Nss;
                i(iss,k) = 1 + (iss - 1)*s + s*Nss*floor((k - 1)/(Nes*s)) + mod((k - 1),s);
                output(iss,k) = input(j(k),i(iss,k));
            end
        end

    else
        L = zeros(Nss,Ncbpss);
        for iss = 1:Nss
            for k = 1:Ncbpss
                L(iss,k) = floor(((k - 1) - Nblock*Nes*s)/s)*Nss + (iss - 1);
            end
        end

        j = zeros(Nss,Ncbpss);
        for k = 1:Ncbpss
            for iss = 1:Nss
                if (k <= Nblock*Nes*s)
                    j(iss,k) = mod(floor((k - 1)/s),Nes);
                else
                    j(iss,k) = mod(floor(L(iss,k)/M),Nes);
                end
            end
        end
        j = j + 1;

        i = zeros(Nss,Ncbpss);
        output = zeros(Nss,Ncbpss);
        for k = 1:Ncbpss
            for iss = 1:Nss
                if (k <= Nblock*Nes*s)
                    i(iss,k) = 1 + (iss - 1)*s + S*floor((k - 1)/(Nes*s)) + mod((k - 1),s);
                    output(iss,k) = input(j(iss,k),i(iss,k));
                else
                    i(iss,k) = 1 + mod(L(iss,k),M)*s + Nblock*S + mod((k - 1),s);
                    output(iss,k) = input(j(iss,k),i(iss,k));
                end
            end
        end
    end
    
end
end

