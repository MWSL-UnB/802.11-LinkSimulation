clc
clear all
close all

global c_sim;

tic

%% Initialize variables

L2S = true; % Flag for L2S simulation

% Maximum number of channel realizations
L2SStruct.maxChannRea = 40;
% Channel models
L2SStruct.chan_multipath = {'B'};
% Standards to simulate
L2SStruct.version = {'802.11n'};
% Channel bandwidths
L2SStruct.w_channel = [20];
% Cyclic prefixes
L2SStruct.cyclic_prefix = {'long'};
% Data length of PSDUs in bytes
L2SStruct.data_len = [1000];
% Beta range and resolution
L2SStruct.betas = 0.1:0.01:50;
% Random generator seeds (must be of length L2SStruct.maxChannRea)
L2SStruct.seeds = 1:L2SStruct.maxChannRea;

% Display simulation status
L2SStruct.display = true;

L2SStruct.folderName = 'L2SResults4';

hsr_script; % Initialize c_sim

%% Simulate to calculate SNRps and PERs

% L2S_simulate(L2SStruct,parameters);

t1 = toc;
fprintf('\n\nSimulation time: %.3f hours \n\n', t1/(60*60));

%% Optimize beta

tic

configNum = length(L2SStruct.chan_multipath)*length(L2SStruct.version)*...
    length(L2SStruct.w_channel)*length(L2SStruct.cyclic_prefix)*...
    length(L2SStruct.data_len);
totalSimNum = configNum*L2SStruct.maxChannRea;

for numSim = 1:L2SStruct.maxChannRea:(totalSimNum - L2SStruct.maxChannRea + 1)
    
    [SNRp_mtx,per_mtx,snrAWGN_mtx,perAWGN_mtx] = L2S_load(numSim,L2SStruct);
    [beta,rmse,rmse_vec] = L2S_beta(SNRp_mtx,per_mtx,snrAWGN_mtx,perAWGN_mtx,L2SStruct);
    
    betaNum = (numSim + L2SStruct.maxChannRea - 1)/L2SStruct.maxChannRea;
    
    filename = [L2SStruct.folderName '\L2S_beta_results_' num2str(betaNum)];
    save([filename '.mat'],'L2SStruct','beta','rmse','rmse_vec','SNRp_mtx',...
        'per_mtx','snrAWGN_mtx','perAWGN_mtx','t1');
    
    fid = fopen([filename '.txt'],'wt');
    fprintf(fid,'%s\nGI: %s\nBand: %d MHz',L2SStruct.version{betaNum},...
        L2SStruct.cyclic_prefix{betaNum},L2SStruct.w_channel(betaNum));
    fprintf(fid,'\nChannel model: %s',L2SStruct.chan_multipath{betaNum});
    
    fprintf(fid,'\n\nbetas = {');
    for mcs = c_sim.drates + 1
        fprintf(fid,' %.4f',beta(mcs));
        if mcs~= length(c_sim.drates)
            fprintf(fid,',');
        end
    end
    fprintf(fid,'}');
    fclose(fid);
    
end

t2 = toc;
fprintf('\n\nBeta calculation time: %.3f seconds \n\n', t2);

%% Plot
for k = 1:configNum
    filename = [L2SStruct.folderName '\L2S_beta_results_' num2str(k) '.mat'];
    load(filename);
    figure(k);
    set(axes,'LineStyleOrder',{'-','-.',});
    hold all
    plot(L2SStruct.betas,rmse_vec,'LineWidth',2);
    legend('MCS0','MCS1','MCS2','MCS3','MCS4','MCS5','MCS6','MCS7');
    xlabel('\beta');
    ylabel('rmse');
    grid on
    gistr = 'longo';
    if strcmp(L2SStruct.cyclic_prefix,'short')
        gistr = 'curto';
    end
    titname = ['Cenário: ',L2SStruct.version{k},', Modelo de Canal ',...
        L2SStruct.chan_multipath{k},', Largura de Banda de ',num2str(L2SStruct.w_channel(k)),...
        'MHz, Intervalo de guarda ',gistr];
    title(titname);
    hold off;
    
    for mcs = c_sim.drates + 1
        
        figure(configNum + mcs);
        semilogy(db(snrAWGN_mtx(mcs,:),'power'),perAWGN_mtx(mcs,:),...
            'linewidth',2.5);
        xlabel('SNR [dB]');
        ylabel('PER');
        grid on;
        hold on;
        
        subBeta = 1;
        
        drP = hsr_drate_param(mcs - 1,false);
        SNReff = L2S_SNReff(SNRp_mtx.*(drP.data_rate/c_sim.w_channel),subBeta);
        subRmse = L2S_rmse(SNReff,per_mtx(:,:,mcs),snrAWGN_mtx(mcs,:),...
            perAWGN_mtx(mcs,:));
        
        semilogy(db(SNReff,'power'),per_mtx(:,:,mcs),'r.');
        
        title(['MCS' num2str(mcs - 1) ', \beta = ' ...
            num2str(subBeta) ' subótimo, rmse = ' num2str(subRmse)]);
        
        legend('AWGN','Multipercursos','Location','SouthWest');
        
        hold off;
    end
    
    for mcs = c_sim.drates + 1
        
        figure(configNum + mcs + c_sim.drates(end) + 1);
        semilogy(db(snrAWGN_mtx(mcs,:),'power'),perAWGN_mtx(mcs,:),...
            'linewidth',2.5);
        xlabel('SNR [dB]');
        ylabel('PER');
        grid on;
        hold on;
        
        drP = hsr_drate_param(mcs - 1,false);
        SNReff = L2S_SNReff(SNRp_mtx.*(drP.data_rate/c_sim.w_channel),beta(mcs));
        
        semilogy(db(SNReff,'power'),per_mtx(:,:,mcs),'r.');
        
        title(['MCS' num2str(mcs - 1) ', \beta = ' ...
            num2str(beta(mcs)) ' ótimo, rmse = ' num2str(rmse(mcs))]);
        
        legend('AWGN','Multipercursos','Location','SouthWest');
        
        hold off;
    end
    
end

%% 

figure(configNum + mcs + c_sim.drates(end) + 2);
mcs1 = 4;
pl = 5;
%fitC = fit(L2SStruct.betas',rmse_vec(mcs1+1,:)','smoothingspline',...
%    'SmoothingParam',0.01);
%h1 = plot(fitC,'b');
% set(h1,'LineWidth',2);
hold on
%plot(L2SStruct.betas(1:pl:end)',rmse_vec(mcs1+1,1:pl:end)','r.')
plot(L2SStruct.betas',rmse_vec(mcs1+1,:)')
xlabel('\beta');
ylabel('rmse');
legend off
axis([0 50 0.25 0.8])
grid on
title([titname ', MCS' num2str(mcs1)]);
hold off

