function rmse = L2S_rmse(SNReff,per,snrAWGN,perAWGN)

perAWGN_int = interp1(snrAWGN,perAWGN,SNReff,'cubic');

delta_pre = log10(per./perAWGN_int);
delta = delta_pre(isfinite(delta_pre));

Mi = size(delta,2);
Mk = size(delta,1);

rmse = sqrt(sum(sum(delta.^2))/(Mi*Mk));

end