clc
clear all
close all

%% Load variables

L2S = true;
hsr_script;

hsr_chan_multipath('init',c_sim.chan_multipath, ...
    1/c_sim.sampling_freq,c_sim.ch_rolloff, ...
    c_sim.rnd_state,c_sim.antennas, ...
    c_sim.chan_vel,c_sim.frame_interval/2);
c = hsr_chan_multipath('fade',c_sim.chan_norm);

t = (-2:(length(c)-3)).*(1/(c_sim.w_channel*1e6));

% load('test_results.mat');

%% Plot time domain

figure(1);
h = abs(c);
plot((t)*1e9,h,'LineWidth',1.2);
% axis([0 max(t*1e9) 0 0.7]);
xlabel('t [ns]');
ylabel('|h(t)|');
print('-dpng','figs\channel_response_time.png');

%% Plot S

figure(2);
S = abs(c.^2);
plot((t+min(t))*1e9,10*log10(S),'LineWidth',1.2);
% axis([0 max(t*1e9) -100 0]);
xlabel('Atraso \tau [ns]');
ylabel('|S(\tau)| [dB]');
print('-dpng','figs\channel_response_S.png');

%% Plot frequency

Sh = fftshift(fft(c.^2,parameters.Nfft,2));
bw2 = c_sim.w_channel/2;
freq = linspace(-bw2,bw2,length(Sh));

figure(3);
plot(freq,10*log10(abs(Sh)),'LineWidth',1.2);

xlabel('Frequência normalizada f [MHz]');
ylabel('|S_h(f)| [dB]');
print('-dpng','figs\channel_response_freq.png');

%% Plot R

R = fftshift(fft(S,parameters.Nfft,2));
bw2 = c_sim.w_channel/2;
freq = linspace(-bw2,bw2,length(R));

figure(4);
plot(freq,10*log10(abs(R)),'LineWidth',1.2);

xlabel('Frequência normalizada f [MHz]');
ylabel('|R(\Deltaf)| [dB]');
print('-dpng','figs\channel_response_R.png');
