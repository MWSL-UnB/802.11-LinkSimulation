function Kmod = hsr_gain(mod)
% KMOD = HSR_GAIN(MOD) returns the modulation-dependent normalization factor
%   for IEEE 802.11a or Hiperlan/2. MOD is a string, which can be one of
%   the following:
%
%     'bpsk'       Binary phase shift keying modulation.
%     'qpsk'       Quaternary phase shift keying modulation.
%     '16qm'       16 Quadrature amplitude shift-keying modulation.
%     '64qm'       64 Quadrature amplitude shift-keying modulation.

if strcmp(mod,'bpsk')
  Kmod = 1;
elseif strcmp(mod,'qpsk')
  Kmod = 1/sqrt(2);
elseif strcmp(mod,'16qam')
  Kmod = 1/sqrt(10);    
elseif strcmp(mod,'64qam')
  Kmod = 1/sqrt(42);
elseif strcmp(mod,'256qam')
  Kmod = 1/sqrt(170); 
else
  error('Illegal value of MOD.')
end
