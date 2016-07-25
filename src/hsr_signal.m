function [LSIG] = hsr_signal()
%HSR_SIGNAL returns the SIGNAL symbol for IEEE 802.11a or Hiperlan/2. 
%
%  Y = HSR_SIGNAL(DRATE,NDBYTES,TX_ANT)
%   returns in Y the SIGNAL symbol for IEEE 802.11a, returns in BITS the
%   signal bits
%   DRATE is the bit rate in Mbits/sec. DRATE must belong to
%    {6,9,12,18,24,36,48,54,72}
%   NDBYTES is the packet length in bytes

% Simeon Furrer, 21.09.00   Created help file.
% Andre Noll Barreto 08.01.01 multiple transmit antennas considered
%                    26.10.10 coding using matlab functions (vitenc)
%                    07.01.14 40MHz


% construct the signal fields
% generate rate field

global c_sim;

mcs =  hsr_drate_param(0,true);
nbits = mcs.Ndbps - c_sim.bcc_tail; % - 6 tail bits
f = randi([0,1],[1,nbits]);

% tail bits
fsignal_tail = zeros(1,c_sim.bcc_tail);

% construct signal
c_signal = [f fsignal_tail];

% encode
codetrellis = poly2trellis(7,[133,171]);
c_signal = convenc(c_signal,codetrellis);

% interleaver
c_signal = hsr_interleaver('802.11a',20,mcs.Ncbps,mcs.Nbpsc,1,1,c_signal);

% map
Kmod = hsr_gain(mcs.modulation);
mapping = hsr_map(c_signal,mcs.modulation);
c_signal = Kmod*mapping; 

% load subcarriers with signal data and pilots
tmp = zeros(1,c_sim.legacy.Nfft);
tmp(c_sim.legacy.c_ps_index) = c_signal;
tmp(c_sim.legacy.pilot_index) = c_sim.legacy.pilot;
c_signal = tmp;

% replicate over multiple 20 MHz channels
switch c_sim.w_channel
    case 20
        N = 1;
    case 40
        N = 2;
    case 80
        N = 4;
    case 160
        N = 8;
end
    
c_signal = repmat(c_signal,1,N);

% phase rotation
c_signal = hsr_phase_rotation('transmission',c_signal.');
c_signal = c_signal.';

%support for multiple antennas
ntx = c_sim.antennas(1);

% same preamble is transmitted from all antennas with circular shifts
if strcmp(c_sim.version,'802.11a')
    cs = 0;
elseif strcmp(c_sim.version,'802.11n')
    cs = hsr_cyclic_shift('legacy',ntx);
elseif strcmp(c_sim.version,'802.11ac')
    cs = hsr_cyclic_shift('legacy',ntx);
end

shiftsamps = zeros(1,ntx);
signal = zeros(ntx,length(c_signal));
for nant = 1:ntx
    shiftsamps(nant) = cs(nant)*c_sim.sampling_freq;
    shiftsamps(nant) = 1e-9*shiftsamps(nant);
    signal(nant,:) = circshift(c_signal,[0,shiftsamps(nant)]);
end

% cyclic extension (long = Ts/4)
L = size(signal,2);
Tg = signal(:,L - (L/4) + 1:end);
LSIG = [Tg signal];

end
