clc
clear all
close all

%% Simulate or load

% fprintf('\n\nSimulate!\n\n');
% hsr_script;

fprintf('\n\nLoad!\n\n');
filename = 'Results\results_16-11-01-1613';
load([filename '.mat']);

fid = fopen([filename '.txt'],'wt');
fprintf(fid,'%s\nGI: %s\nBand: %d MHz\n\n',c_sim.version,...
    c_sim.cyclic_prefix,c_sim.w_channel);

%% Definir SNR

rates1 = zeros(size(c_sim.drates));
for mcs = 1:length(c_sim.drates)
    drP = hsr_drate_param(c_sim.drates(mcs),false);
    rates1(mcs) = drP.data_rate;
end
rates = repmat(rates1',1,size(ber,2));

EbN0 = repmat(c_sim.EbN0s,size(ber,1),1);

SNR = EbN0 + db(rates./c_sim.w_channel,'Power');

%% Plynomials

T2V = zeros(size(rates1));
T1V = zeros(size(T2V));

T1fit = zeros(length(rates1),5);
T2fit = zeros(length(rates1),2);

for k = 1:length(rates1)
    
    perV = per(k,:);
    SNRV = SNR(k,:);
    perIdx = find(perV >= 1);
    T1 = SNRV(perIdx(end) + 1);
    
    T1V(k) = T1;
    
    perIdx = find(perV > 0);
    T2 = SNRV(perIdx(end) - 1);
    
    T2V(k) = T2;
    
    mrgnDo = 0;
    mrgnUp = 0;
    
    SNRIdxT1 = find(SNRV > (T1 - mrgnDo) & SNRV < (T2 + mrgnUp));
    T1x = SNRV(SNRIdxT1);
    T1y = perV(SNRIdxT1);
    T1y = log10(T1y);
    T1fit(k,:) = polyfit(T1x,T1y,4);
    %     fprintf('T1fit = %f +%f*SNR %f*SNR^2 +%f*SNR^3 %f*SNR^4\n',...
    %         T1fit(5),T1fit(4),T1fit(3),T1fit(2),T1fit(1));
    
    perIdxT2 = find(perV == 0);
    if numel(perIdxT2) == 0
        perIdxT2 = length(perV) + 1;
    end
    T2y = perV(perIdxT2(1)-2:perIdxT2(1)-1);
    T2y = log10(T2y);
    T2x = SNRV(perIdxT2(1)-2:perIdxT2(1)-1);
    T2fit(k,:) = polyfit(T2x,T2y,1);
    %     fprintf('T2fit = %f %f*SNR\n',T2fit(2),T2fit(1));
    
end

%% Display

% for k = 1:length(rates1)
%     fprintf(fid,'{%.6f,%.6f,%.6f,%.6f,%.6f},\n',...
%         T1fit(k,5),T1fit(k,4),T1fit(k,3),T1fit(k,2),T1fit(k,1));
% end
% 
% fprintf(fid,'\n{');
% for k = 1:length(rates1)
%     fprintf(fid,'{%.6f,%.6f}',T2fit(k,2),T2fit(k,1));
%     if k ~= length(rates1)
%         fprintf(fid,',');
%     end
% end
% fprintf(fid,'}');
% 
% fprintf(fid,'\n\nmin = {%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f};\n\n',T1V(1),T1V(2),...
%     T1V(3),T1V(4),T1V(5),T1V(6),T1V(7),T1V(8));
% fprintf(fid,'max = {%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f};\n\n',T2V(1),T2V(2),...
%     T2V(3),T2V(4),T2V(5),T2V(6),T2V(7),T2V(8));

%% Plot

plotType = 'log';

if ~strcmp(plotType,'off')
    for k = 1:length(c_sim.drates + 1)
        
        SNR2 = min(SNR(k,:)):0.1:max(SNR(k,:));
        
        tmp1 = abs(SNR2 - T1V(k));
        [~,T1Idx] = min(tmp1);
        
        tmp2 = abs(SNR2 - T2V(k));
        [~,T2Idx] = min(tmp2);
        
        preT1 = log10(ones(1,T1Idx));
        
        posT1 = SNR2((T1Idx + 1):(T2Idx -1));
        posT1 = T1fit(k,5)+T1fit(k,4).*posT1+T1fit(k,3).*posT1.^2+...
            T1fit(k,2).*posT1.^3+T1fit(k,1).*posT1.^4;
        
        snrMaxIdx = T2Idx + 10;
        if snrMaxIdx > length(SNR2)
            snrMaxIdx = length(SNR2);
        end
        
        posT2 = SNR2(T2Idx:snrMaxIdx);
        posT2 = T2fit(k,2)+T2fit(k,1).*posT2;
        
        fitPerLog = [preT1 posT1 posT2];
        fitPer = 10.^fitPerLog;
        
        figure();
        if strcmp(plotType,'log')
            semilogy(SNR(k,:),per(k,:),'bo','LineWidth',2);
            hold on
            semilogy(SNR2(1:snrMaxIdx),fitPer,'r-','LineWidth',2);
%             semilogy(EbN0(k,:),per(k,:),'g-o','LineWidth',2);
            hold off
        else
            plot(SNR(k,:),per(k,:),'bo','LineWidth',2);
            hold on
            plot(SNR2(1:snrMaxIdx),fitPer,'r-','LineWidth',2);
%             plot(EbN0(k,:),per(k,:),'g-o','LineWidth',2);
            hold off
        end
        grid on;
        title(['MCS' num2str(c_sim.drates(k))]);
    end
end

%% Close file

fclose(fid);
