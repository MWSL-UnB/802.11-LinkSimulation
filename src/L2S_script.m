clc
clear all
close all

global c_sim;

%% Initialize variables

L2S = true; % Flag for L2S simulation

% Maximum number of channel realizations
L2SStruct.maxChannRea = 2;
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

% Display simulation status
L2SStruct.display = true;

hsr_script; % Initialize c_sim

%% Simulate to calculate SNRps and PERs

L2S_simulate(L2SStruct,parameters);
