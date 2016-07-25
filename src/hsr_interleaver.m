function [output] = hsr_interleaver(version,channel,Ncbps,Nbpsc,Nss,Nsym,input)
% HSR_INTERLEAVER Data (de)interleaver according to IEEE 802.11a and
%                 ETSI Hiperlan2.
%
%   HSR_INTERLEAVER('init',NCBPS, LEGACY)
%     initializes the module, depending on the number of coded bit per OFDM
%     symbol NCBPS.
%     If LEGACY is true, then 802.11a parameters are used
%     The interleaver is defined by two permutations. Let K be
%     the bit index before interleaving. The first permutation is defined by:
%        N = (NCBPS/16)*rem(K,16)+floor(K/16)
%     The bit index at the interlever output will be 
%        M = max(S,1)*floor(N/S)+rem((N+NCBPS-floor(16*N/NCBPS)),S)+1,
%     where S=max(NCBPS/96,1)
%       
%   DATA_OUT = HSR_INTERLEAVER('interleave',DATA_IN)
%     interleaves DATA_IN.
%     DATA_IN and DATA_OUT are row vectors of length NCBPS*Nsymb, with Nsymb
%     the number of OFDM symbols in a block
%
%   DATA_OUT = HSR_INTERLEAVER('deinterleave',DATA_IN)
%     deinterleaves DATA_IN.
%     DATA_IN and DATA_OUT are matrices of size NCBPS x Nsymb, with Nsymb the
%     number of OFDM symbols in a block
%

% Andre Noll Barreto, 25.07.2001  Created
%                     07.01.2014  802.11n, 40MHz

if strcmp(version,'802.11a')
    s = max(1,(Nbpsc/2));
    
    k = 0:(Ncbps - 1);
    n = (Ncbps/16)*mod(k,16) + floor(k/16);
    m = s*floor(n/s) + mod((n + Ncbps - floor(16*n/Ncbps)),s);
    m = m + 1;
    k = k + 1;
    
    L = length(input);
    input = reshape(input,Ncbps,L/Ncbps);
    output(m,:) = input(k,:);    
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
    
    k = 0:Ncbpss - 1;
    i = Nrow*mod(k,Ncol) + floor(k/Ncol);
    j = s*floor(i/s) + mod((i + Ncbpss - floor(Ncol*i/Ncbpss)),s);

    k = k + 1;
    
    r = zeros(Nss,Ncbpss);
    for iss = 1:Nss
        for n = 1:Ncbpss
            r(iss,n) = 1 + mod(j(n) - (mod(2*(iss - 1),3) + 3*floor((iss - 1)/3)*Nrot*Nbpscs),Ncbpss);
        end
    end
    
    utgang = zeros(Ncbpss,Nsym);
    output = zeros(Nss,Ncbpss*Nsym);
    for iss = 1:Nss
        ingang = reshape(input(iss,:),[Ncbpss,Nsym]);
        utgang(r(iss,:),:) = ingang(k,:);
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

    k = 0:Ncbpssi - 1;
    i = Nrow*mod(k,Ncol) + floor(k/Ncol);
    j = s*floor(i/s) + mod((i + Ncbpssi - floor((Ncol*i)/Ncbpssi)),s);

    k = k + 1;

    r = zeros(Nss,Ncbpssi,Nsubblock);

    if Nss <= 4
        for iss = 1:Nss
            for l = 1:Nsubblock
                for n = 1:Ncbpssi
                    r(iss,n,l) = 1 + mod(j(n) - (mod(2*(iss - 1),3) + 3*floor((iss - 1)/3)*Nrot*Nbpscs),Ncbpssi);
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
                        r(iss,n,l) = 1 + mod((j(n) - Jiss*Nrot*Nbpsc),Ncbpssi);
                    end
                end
        end
    end

    utgang = zeros(Ncbpssi,Nsym);
    output = zeros(Nss,Ncbpssi*Nsym,Nsubblock);
    for iss = 1:Nss
        for l = 1:Nsubblock
            ingang = reshape(input(iss,:,l),[Ncbpssi,Nsym]);
            utgang(r(iss,:,l),:) = ingang(k,:);
            output(iss,:,l) = reshape(utgang,[1,Ncbpssi*Nsym]);
        end
    end

end

end