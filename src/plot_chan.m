clc

%% Load variables

load('test_results.mat');

%% Plot time domain

figure(1);
plot((t-min(t))*1e9,abs(c)*1e3,'LineWidth',1.2);
axis([0 1900 0 600]);
xlabel('Tempo t [ns]');
ylabel('|h(t)| [mV]');
print('-dpng','figs\channel_response_time.png');

%% Plot S

figure(2);
plot((t-min(t))*1e9,abs(c.^2)*1e3,'LineWidth',1.2);
axis([0 1800 0 320]);
xlabel('Atraso \tau [ns]');
ylabel('|S(\tau)| [mW]');
print('-dpng','figs\channel_response_S.png');

%% Plot frequency

C = fftshift(fft(c,parameters.Nfft,2));
bw2 = c_sim.w_channel/2;
freq = linspace(-bw2,bw2,length(R));

figure(3);
plot(freq,abs(C),'LineWidth',1.2);

xlabel('Frequência normalizada f [MHz]');
ylabel('|C(f)| [mV]');
print('-dpng','figs\channel_response_freq.png');

%% Plot R

R = fftshift(fft(abs(c.^2),parameters.Nfft,2));
bw2 = c_sim.w_channel/2;
freq = linspace(-bw2,bw2,length(R));

figure(4);
plot(freq,10*log10(abs(R)),'LineWidth',1.2);

xlabel('Frequência normalizada f [MHz]');
ylabel('|R(\Deltaf)| [dB]');
print('-dpng','figs\channel_response_R.png');
