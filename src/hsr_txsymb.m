function data = hsr_txsymb(p_TXVECTOR,p_PSDU,scr_init)
%HSR_TXSYMB Transmitted symbols in IEEE 802.11a / Hiperlan2
%
% DATA = HSR_TXSYMB(TXVECTOR,PSDU,TX_ANT)
%   outputs in DATA the symbols transmitted on the data subcarriers of a PHY burst
%   defined by the struct TXVECTOR, which has the
%   following fields:
%      .LENGTH      number of bytes per packet/ofdm frame
%      .DATARATE    data rate index, see hsr_drate_param.m
%      .SERVICE     SERVICE field, e.g. [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
%      .TXPWR_LEVEL TX power level 1..8 (not implemented yet) 
%   ,by PSDU, the data unit (vector with binary elements)
%   DATA consists of the PSK/QAM symbols of the PDU only.

%History:
%  Andre Noll Barreto  30.10.2001  created

% import basic simulation parameters
global c_sim; 

NSC_LOG = 48;   % number of logical subcarriers

sim_param = hsr_drate_param(p_TXVECTOR.DATARATE);  

%data
p_Ndbps = sim_param.Ndbps;
p_Nsym = ceil((16+8*p_TXVECTOR.LENGTH+6)/p_Ndbps);
Npad = p_Nsym*p_Ndbps-(16+8*p_TXVECTOR.LENGTH+6);
service = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
tail = [0 0 0 0 0 0];
pad = zeros(1,Npad);
% add service, tail and pad bits
data = [p_TXVECTOR.SERVICE p_PSDU tail pad];


%data = convenc(data,codetrellis);
hsr_convenc27('init',data);
data = hsr_convenc27('encode',data);
data = hsr_scrambler(scr_init,data);

%zero tail bits
tail_index = 16+8*p_TXVECTOR.LENGTH;
data(tail_index+1:tail_index+6) = 0;
data = hsr_puncture(sim_param.coderate,data);
hsr_interleaver('init',sim_param.Ncbps);
data = hsr_interleaver('interleave',data);
data = hsr_gain(sim_param.modulation) * hsr_map(data,sim_param.modulation);

% load subcarriers with signal data and pilots
data = reshape(data,48,p_Nsym);
data = hsr_subcload(data,hsr_pilot(p_Nsym));
