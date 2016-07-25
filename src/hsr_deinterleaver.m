function [output] = hsr_deinterleaver(version,channel,Ncbps,Nbpsc,Nss,Nsym,input)

if strcmp(version,'802.11a')
    s = max(1,(Nbpsc/2));
    
    j = 0:Ncbps - 1;
    i = s*floor(j/s) + mod(j + floor(16*j/Ncbps),s);
    k = 16*i - (Ncbps - 1)*floor(16*i/Ncbps);
    
    j = j + 1;
    k = k + 1;
    
    L = length(input);
    input = reshape(input,Ncbps,L/Ncbps);
    output(k,:) = input(j,:);    
    output = reshape(output,1,L);
    
elseif strcmp(version,'802.11n')
    Nbpscs = Nbpsc;
    s = max(1,(Nbpscs/2));
    Ncbpss = size(input,2)/Nsym;
        
    switch channel
        case 20
            Ncol = 13;
            Nrow = 4*Nbpscs;
            Nrot = 11;
        case 40
            Ncol = 18;
            Nrow = 6*Nbpscs;
            Nrot = 29;
    end
    
    r = 0:Ncbpss - 1;
    j = zeros(Nss,Ncbpss);
    i = zeros(Nss,Ncbpss);
    k = zeros(Nss,Ncbpss);
    for iss = 1:Nss
        for n = 1:Ncbpss
            j(iss,n) = mod(r(n) + (mod(2*(iss - 1),3) + 3*floor((iss - 1)/3)*Nrot*Nbpscs),Ncbpss);
            i(iss,n) = s*floor(j(iss,n)/s) + mod(j(iss,n) + floor(Ncol*j(iss,n)/Ncbpss),s);
            k(iss,n) = Ncol*i(iss,n) - (Ncbpss - 1)*floor(i(iss,n)/Nrow);
        end
    end
    
    k = k + 1;
    r = r + 1;
    
    utgang = zeros(Ncbpss,Nsym);
    output = zeros(Nss,Ncbpss*Nsym);
    for iss = 1:Nss
        ingang = reshape(input(iss,:),[Ncbpss,Nsym]);
        utgang(k(iss,:),:) = ingang(r,:);
        output(iss,:) = reshape(utgang,[1,Ncbpss*Nsym]);
    end
    
elseif strcmp(version,'802.11ac')
    Nbpscs = Nbpsc;
    s = max(1,(Nbpscs/2));
    Nsubblock = size(input,3);
    Ncbpssi = size(input,2)/Nsym;
    
    switch channel
        case 20
            Ncol = 13;
            Nrow = 4*Nbpscs;
            if Nss <= 4
                Nrot = 11;
            else
                Nrot = 6;
            end
        case 40
            Ncol = 18;
            Nrow = 6*Nbpscs;
            if Nss <= 4
                Nrot = 29;
            else
                Nrot = 13;
            end
        case 80
            Ncol = 26;
            Nrow = 9*Nbpscs;
            if Nss <= 4
                Nrot = 58;
            else
                Nrot = 28;
            end
        case 160
            Ncol = 26;
            Nrow = 9*Nbpscs;
            if Nss <= 4
                Nrot = 58;
            else
                Nrot = 28;
            end
    end
    
    r = 0:Ncbpssi - 1;
    j = zeros(Nss,Ncbpssi);
    i = zeros(Nss,Ncbpssi);
    k = zeros(Nss,Ncbpssi);
    if Nss <= 4
        for iss = 1:Nss
            for l = 1:Nsubblock
                for n = 1:Ncbpssi
                    j(iss,n,l) = mod(r(n) + (mod(2*(iss - 1),3) + 3*floor((iss - 1)/3)*Nrot*Nbpscs),Ncbpssi);
                    i(iss,n,l) = s*floor(j(iss,n,l)/s) + mod(j(iss,n,l) + floor(Ncol*j(iss,n,l)/Ncbpssi),s);
                    k(iss,n,l) = Ncol*i(iss,n,l) - (Ncbpssi - 1)*floor(i(iss,n,l)/Nrow);
                end
            end
        end 
    else
        for iss = 1:Nss
            switch iss
                case 1
                    Jiss = 0;
                case 2
                    Jiss = 5;
                case 3
                    Jiss = 2;
                case 4
                    Jiss = 7;
                case 5
                    Jiss = 3;
                case 6
                    Jiss = 6;
                case 7
                    Jiss = 1;
                case 8
                    Jiss = 4;
            end
                for l = 1:Nsubblock
                    for n = 1:Ncbpssi
                        j(iss,n,l) = mod(r(n) + Jiss*Nrot*Nbpscs,Ncbpssi);
                        i(iss,n,l) = s*floor(j(iss,n,l)/s) + mod(j(iss,n,l) + floor(Ncol*j(iss,n,l)/Ncbpssi),s);
                        k(iss,n,l) = Ncol*i(iss,n,l) - (Ncbpssi - 1)*floor(i(iss,n,l)/Nrow);
                    end
                end
        end
    end
    
    k = k + 1;
    r = r + 1;
    
    utgang = zeros(Ncbpssi,Nsym);
    output = zeros(Nss,Ncbpssi*Nsym,Nsubblock);
    for iss = 1:Nss
        for l = 1:Nsubblock
            ingang = reshape(input(iss,:,l),[Ncbpssi,Nsym]);
            utgang(k(iss,:,l),:) = ingang(r,:);
            output(iss,:,l) = reshape(utgang,[1,Ncbpssi*Nsym]);
        end
    end
end
end

