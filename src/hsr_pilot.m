function [pilot] = hsr_pilot(Nsym)
% HSR_PILOT Pilot generation for IEEE 802.11a / Hiperlan2
%
%   PILOT = HSR_PILOT (NSYMBS, NANTS)
%     Outputs a 4 x NSYMBS x NANTS matrix containing the pilot subcarriers
%     for NSYMBS OFDM data symbols and NANTS transmit antennas

% History
% Andre Noll Barreto  25.07.2001  created
%                     15.01.2014  included multiple antennas
global c_sim

version = c_sim.version;
pilot_values = c_sim.pilot;
Nsts = c_sim.n_sts;

p_polarity = [1  1  1  1 -1 -1 -1  1 -1 -1 -1 -1  1  1 -1  1 ...
        -1 -1  1  1 -1  1  1 -1  1  1  1  1  1  1 -1  1 ...
        1  1 -1  1  1 -1 -1  1  1  1 -1  1 -1 -1 -1  1 ...
        -1  1 -1 -1  1 -1 -1  1  1  1  1  1 -1 -1  1  1 ...
        -1 -1  1 -1  1 -1  1  1 -1 -1 -1  1  1 -1 -1 -1 ...
        -1  1 -1 -1  1 -1  1  1  1  1 -1  1 -1  1 -1  1 ...
        -1 -1 -1 -1 -1  1 -1  1  1 -1  1 -1  1  1  1 -1 ...
        -1  1 -1 -1 -1  1  1  1 -1 -1 -1 -1 -1 -1 -1];

    
n = ceil((Nsym + 1)/length(p_polarity));
polarity = repmat(p_polarity,1,n);

switch version
    case '802.11a'
        z = 2;
    case '802.11n'
        z = 4;
    case '802.11ac'
        z = 5;
end

if strcmp(version,'802.11a')
    pilot = pilot_values.'*polarity(z:(Nsym + (z - 1)));
    
elseif strcmp(version,'802.11n')
    pilot = zeros(size(pilot_values,2),Nsym,Nsts);
    for ists = 1:Nsts
        pilot(:,:,ists) = pilot_values(ists,:).'*polarity(z:(Nsym + (z - 1)));
    end
    
elseif strcmp(version,'802.11ac')
    pilot = zeros(size(pilot_values,2),Nsym,Nsts);
    for ists = 1:Nsts
        pilot(:,:,ists) = pilot_values.'*polarity(z:(Nsym + (z - 1)));
    end
end

end

