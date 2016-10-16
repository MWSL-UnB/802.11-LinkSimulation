function SNReff = L2S_SNReff(SNRp,beta)

Np = size(SNRp,2);

SNReff_mtx = -beta.*log((1/Np).*sum(exp(-SNRp./beta),2));

SNReff = permute(SNReff_mtx,[3 1 2]);

end
