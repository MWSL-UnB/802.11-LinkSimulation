function [data_out] = hsr_timewindow(method,data_in)
% HSR_TIMEWINDOW - Simple windowing funtion according to IEEE 802.11a and 
%   ETSI Hiperlan/2. 
%
%   Usage: HSR_TIMEWINDOW('init',TTr) to initialize the windowing function
%          Y=HSR_TIMEWINDOW('execute',X) to window symbol X
%
%   The following time window of length TTr in samples (symbol interval T) is applied:
%     w(t) = sin(0.5*pi*t/TTr)^2,         if 0 < t < TTr
%            1,                           if TTr <= t < T
%            sin(0.5*pi*(1-(t-T)/TTr))^2, if T <= t < T+TTr
%            0,                           otherwise

% Simeon Furrer, 20.09.00   Created help file.
% Andre Noll Barreto, 27.03.2001, TTr larger than 1 sample
%                     16.08.2001, can be applied on whole packets

% Note: The specification example indicates that the windowing is done in the 
%       first part of the guard interval. Therefore, we cyclically extend the
%       symbols at its end by the length of the overlap time TTTr (see spec.) 
%       and then do the windowing over the symbol.
%
%
%       Windowing generates ISI between the current and the next OFDM symbol.

persistent w1;
persistent w2;
persistent TTr;

% determine method to execute */
if strcmp(method,'init')
  T = 80;
  if ~exist('data_in') || isempty(data_in)
      TTr = 2.5;
  else
      TTr = data_in;
  end
  t = 1:(T+TTr);
  w = (sin(0.5*pi*t/TTr).^2).*(t<TTr) + ((t>=TTr)&(t<T)) + (sin(0.5*pi*(1-(t-T)/TTr)).^2).*(t>=T);
  TTr = floor(TTr);
  w1 = w(1:TTr);
  w2 = w(T+1:T+TTr);
elseif strcmp(method,'execute')
  [nants,len] = size(data_in);
  wtmp1 = repmat(w1,nants,1);
  wtmp2 = repmat(w2,nants,1);
  nsymb = len/80;
  data_out = data_in;
  data_out(:,1:TTr) = data_out(:,1:TTr).*wtmp1;
  for count = 1:nsymb-1
      first = 80*count+1;
      last = first+TTr-1;
      data_out(:,first:last) = data_out(:,first:last).*wtmp1 + data_out(:,(first:last)-64).*wtmp2;
  end
else
  % unknown method
  error('hsr_timewindow: method unknown');
end;
