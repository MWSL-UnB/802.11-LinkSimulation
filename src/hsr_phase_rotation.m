function [output] = hsr_phase_rotation(way,input)


global c_sim

channel = c_sim.w_channel;
Nfft = c_sim.Nfft;

% number of subcarriers of the string
L = size(input,1);

switch way
    case 'transmission'
        a = 1i;
    case 'reception'
        a = -1i;
end

output = zeros(size(input));

switch channel
    case 20
        output = 1*input;
    
    case 40
        for d = 1:Nfft
            if d <= L/2
                output(d,:,:) = a*input(d,:,:);
            else
                output(d,:,:) = 1*input(d,:,:);
            end
        end
     
    case 80
        for d = 1:Nfft
            if d <= L/2
                output(d,:,:) = -1*input(d,:,:);
            elseif (d > L/2)&&(d <= ((L/2) + (L/4)))
                output(d,:,:) = 1*input(d,:,:);
            elseif d > ((L/2) + (L/4))
                output(d,:,:) = -1*input(d,:,:);
            end      
        end
        
    case 160
        for d = 1:Nfft
            if d <= L/8
                output(d,:,:) = 1*input(d,:,:);
            elseif (d > L/8)&&(d <= L/2)
                output(d,:,:) = -1*input(d,:,:);
            elseif (d > L/2)&&(d <= ((L/2) + (L/8)))
                output(d,:,:) = 1*input(d,:,:);
            elseif d > ((L/2) + (L/8))
                output(d,:,:) = -1*input(d,:,:);
            end
        end
end

end