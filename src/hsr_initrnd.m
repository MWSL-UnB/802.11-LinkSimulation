function hsr_initrnd (j)
%HSR_INITRND initializes random number generators.
%
%  HSR_INITRND
%    Resets all the random number generators used in the simulation.
%  HSR_INITRND (J)
%    Sets all the random number generators used in the simulation to the
%    J-th state.

%	      Andre Noll Barreto, 26.10.00  Initial version
%

if nargin == 0
   j = 0;
end

rand ('state',j);
randn ('state',j);