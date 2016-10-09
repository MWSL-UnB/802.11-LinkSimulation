function [minbeta,rmse,rmse_vec] = L2S_beta(SNRp_mtx,per_mtx,snrAWGN_mtx,perAWGN_mtx)

rmse_vec = zeros(size(L2SStruct.betas));

for mcs = c_sim.drates
    
    per = per_mtx(:,:,mcs);
    snrAWGN = snrAWGN_mtx(mcs,:);
    perAWGN = perAWGN_mtx(mcs,:);
    
    j = 1;
    
    for beta = L2SStruct.betas
        
        SNReff_mtx = L2S_SNReff(SNRp_mtx,beta);
        SNReff = permute(SNReff_mtx,[1 3 2]);
        
        rmse_vec(j) = L2S_rmse(SNReff,per,snrAWGN,perAWGN);
        
        j = j + 1;
    end
end

[rmse,minIdx] = min(rmse_vec);
minbeta = beta(minIdx);

end