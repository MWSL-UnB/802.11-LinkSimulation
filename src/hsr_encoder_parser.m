function [output] = hsr_encoder_parser(Nes,Nsym,Ndbps,input)

global c_sim;

% number of multiple encoders
if strcmp(c_sim.version,'802.11n')
    output = zeros(Nes,length(input)/Nes);
    for j = 1:Nes
        for i = 1:(length(input)/Nes)
            output(j,i) = input(Nes*(i - 1) + j);
        end
    end

elseif strcmp(c_sim.version,'802.11ac')
    output = zeros(Nes,length(input)/Nes);
    for j = 1:Nes;
        for i = 1:length(input)
            if (i <= Nsym*(Ndbps/Nes) - c_sim.bcc_tail)
                output(j,i) = input(Nes*(i - 1) + j);
            elseif (i > Nsym*(Ndbps/Nes) - c_sim.bcc_tail)&&(i <= Nsym*(Ndbps/Nes))
                output(j,i) = 0;
            end
        end
    end
    
end


end

