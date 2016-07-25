
function y = invraisedcos(t,W,rolloff)
% y = INVRAISEDCOS(t,W,rolloff) - Evaluates the inverse Fourier transform of a
%   raised-cosine spectral shape with bandwidth W [Hz] and specified rolloff
%   parameter at time instances given by vector t. The inverse Fourier
%   transform is given by [Proakis, p. 338]
%
%     y = (sin(phi)/phi) * (cos(rolloff*phi) / (1 - 4 * (rolloff*W*t)^2))
%
%   where   phi = pi*W*t.

% History:
% 27.07.94, F. Neeser: Created acf.m from acfx.m
% 05.10.00, F. Neeser: Created raisedcos.m from acf.m

temp = W*t;
phi = pi*temp;
delta = 1.0e-8;
%
% Compute y1 = sin(phi)/phi:
%
y1 = zeros(size(phi));
for i=1:length(phi)
  if abs(phi(i)) < delta
    y1(i) = 1;
  else
    y1(i) = sin(phi(i))/phi(i);
  end
end
%
% Compute y2 = cos(rolloff*phi) / (1 - 4 * (rolloff*W*t)^2):
%
y2 = zeros(size(phi));
temp = rolloff*temp;
for i=1:length(phi)
  if abs(abs(temp(i))-0.5) < delta
    y2(i) = pi/4; % found using de l'Hopital's rule
  else
    y2(i) = cos(rolloff*phi(i)) / (1 - 4 * temp(i)^2);
  end
end
%
% Component-wise multiplication:
%
y = y1 .* y2;
