function [data_out] = hsr_map(data_in,modulation)
%HSR_MAP Gray coded PAM / QAM mapping from a binary input vector
%       to a vector of complex subcarrier symbols according to 
%       802.11/Hiperlan2.
%
%       Y = HSR_MAP(X, METHOD) 
%
%       X is an input row vector with binary elements.
%
%       METHOD is a string, which can be one of the following:
%       'bpsk'       Binary phase shift keying modulation.
%       'qpsk'       Quaternary phase shift keying modulation.
%       '16qm'       16 Quadrature amplitude shift-keying modulation.
%       '64qm'       64 Quadrature amplitude shift-keying modulation.
%
%       The real and imaginary parts of Y are odd integers, i.e.,
%       Y is not normalized to unit power.

%       Simeon Furrer, 26.06.00  Updated
%	      Simeon Furrer, 31.01.00  Initial version
%       Fredy Neeser,  07.08.00  Moved normalization to main program
%                                for consistency with h2_llrcomp

if strcmp(modulation,'bpsk')
    tmp = 2*data_in - 1;

elseif strcmp(modulation,'qpsk')
    tmp = vec2mat(data_in,2);
    tmp = (2*tmp(:,1) - 1) + 1i*(2*tmp(:,2) - 1);

elseif strcmp(modulation,'16qam')
    tmp = vec2mat(data_in,4);
    tmp = (2*tmp(:,1) - 1).*(3 - 2*tmp(:,2)) + 1i*(2*tmp(:,3) - 1).*(3 - 2*tmp(:,4));

elseif strcmp(modulation,'64qam')
    tmp = vec2mat(data_in,6);
    tmp = ((2*tmp(:,2) - 1).*(3 - 2*tmp(:,3)) - 4).*(1 - 2*tmp(:,1)) + ...
            1i*((2*tmp(:,5) - 1).*(3 - 2*tmp(:,6)) - 4).*(1 - 2*tmp(:,4));

elseif strcmp(modulation,'256qam')
    tmp = vec2mat(data_in,8);
    tmp = ((((2*tmp(:,3) - 1).*(3 - 2*tmp(:,4)) - 4).*(1 - 2*tmp(:,2))) - 8).*(1 - 2*tmp(:,1)) + ...
              1i*((((2*tmp(:,7) - 1).*(3 - 2*tmp(:,8)) - 4).*(1 - 2*tmp(:,6))) - 8).*(1 - 2*tmp(:,5));

end
    
data_out = tmp.';
end

% order inputs for ifft, except pilots
%pilot = 0;
%data_out = [0;0;0;0;0;0; ...
%            tmp(1:5);pilot;tmp(6:18);pilot;tmp(19:24);0; ...
%			      tmp(25:30);pilot;tmp(31:43);pilot;tmp(44:48); ...
%			      0;0;0;0;0];


% info (alternate mapping method)
% modmap('qask/arb',[-1 1 -1 1],[-1 -1 1 1])