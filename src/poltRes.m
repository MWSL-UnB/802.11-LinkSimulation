clc
clear all
close all

fprintf('\n\nLoad Results!\n\n');
load('results_16-07-18-1641.mat');

%% Definir SNR

rates1 = [6.5; 13; 19.5; 26; 39; 52; 58.5; 65];
rates = repmat(rates1,1,size(ber,2));
bw = 20;

EbN0 = repmat(c_sim.EbN0s,size(ber,1),1);

SNR = EbN0 + db(rates./bw,'Power');

%% Plot
 
for k = 1:8
figure();
semilogy(SNR(k,:),ber(k,:),'b-o','LineWidth',2);
grid on;
title(num2str(rates1(k)));
axis([-20 25 1e-6 1])
end

%% Plynomials

T2V = [-1.03 2.15 4.89 7.14 11.90 16.15 17.16 19.62];
T1V = zeros(size(T2V));

for k = 1:length(rates1)
    fprintf('\n\n -> %f Mbps \n\n',rates1(k));
    
    berV = ber(k,:);
    SNRV = SNR(k,:);
    berIdx = find(berV > 0.475);
    T1 = 0.5*(SNRV(berIdx(end))+SNRV(berIdx(end)+1));
    fprintf('T1 = %f\n\n',T1);
    
    T1V(k) = T1;
    
    T2 = T2V(k);
    fprintf('T2 = %f\n\n',T2);
    
    SNRIdxT1 = find(SNRV > T1 & SNRV < T2);
    T1x = SNRV(SNRIdxT1);
    T1y = berV(SNRIdxT1);
    % T1y = log10(T1y);
    T1fit = polyfit(T1x,T1y,4);
%     fprintf('T1fit = %f +%f*SNR %f*SNR^2 +%f*SNR^3 %f*SNR^4\n',...
%         T1fit(5),T1fit(4),T1fit(3),T1fit(2),T1fit(1));
    fprintf('{%f,%f,%f,%f,%f},\n\n',...
        T1fit(5),T1fit(4),T1fit(3),T1fit(2),T1fit(1));
    
    berIdxT2 = find(berV == 0);
    T2y = berV(berIdxT2(1)-2:berIdxT2(1)-1);
    T2y = log10(T2y);
    T2x = SNRV(berIdxT2(1)-2:berIdxT2(1)-1);
    T2fit = polyfit(T2x,T2y,1);
%     fprintf('T2fit = %f %f*SNR\n',T2fit(2),T2fit(1));
    fprintf('{%f,%f},\n\n',T2fit(2),T2fit(1));
end

fprintf('min = {%f,%f,%f,%f,%f,%f,%f,%f};\n\n',T1V(1),T1V(2),...
    T1V(3),T1V(4),T1V(5),T1V(6),T1V(7),T1V(8));
fprintf('max = {%f,%f,%f,%f,%f,%f,%f,%f};\n\n',T2V(1),T2V(2),...
    T2V(3),T2V(4),T2V(5),T2V(6),T2V(7),T2V(8));
