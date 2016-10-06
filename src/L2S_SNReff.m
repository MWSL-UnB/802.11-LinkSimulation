function SNReff = L2S_SNReff(SNRp,beta)

Np = size(SNRp,2);

SNReff = -beta.*log((1/Np).*sum(exp(-SNRp./beta),2));

end
