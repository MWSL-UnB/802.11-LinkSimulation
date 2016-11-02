function [SNRp_mtx,per_mtx,snrAWGN_mtx,perAWGN_mtx] = L2S_load(numSim,L2SStruct)

chanUse = L2SStruct.maxChannRea;

filename = [L2SStruct.folderName '\L2S_results_' num2str(numSim) '.mat'];
load(filename);

L2SStruct.maxChannRea = chanUse;

SNRp_mtx = zeros([size(SNRp) L2SStruct.maxChannRea]);
per_mtx_pre = zeros([size(per) L2SStruct.maxChannRea]);

for simIdx = numSim:(numSim + L2SStruct.maxChannRea - 1)
    
    filename = [L2SStruct.folderName '\L2S_results_' num2str(simIdx) '.mat'];
    load(filename);
    
    SNRp_mtx(:,:,simIdx) = SNRp;
    per_mtx_pre(:,:,simIdx) = per;
    
end % Channel realizations loop

per_mtx = permute(per_mtx_pre,[3 2 1]);

snrAWGN_mtx = zeros([length(c_sim.drates) length(c_sim.EbN0s)]);
for mcs = c_sim.drates
    drP = hsr_drate_param(mcs,false);
    snrAWGN_mtx(mcs + 1,:) = c_sim.EbN0s + db(drP.data_rate./c_sim.w_channel,'power');
end % Data rates loop

snrAWGN_mtx = 10.^(snrAWGN_mtx./10);

end