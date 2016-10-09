function rmse = L2S_rmse(SNReff,per,snrAWGN,perAWGN)

Mi = size(per,2);
Mk = size(per,1);

perAWGN_int = interp1(snrAWGN,perAWGN,SNReff);

delta = log10(per./perAWGN_int);

rmse = sqrt(sum(sum(delta))/(Mi*Mk));

end