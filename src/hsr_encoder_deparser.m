function [output] = hsr_encoder_deparser(Nes,Nservice,psdu_length,input)

useful_data = Nservice + 8*psdu_length;
L = useful_data/Nes;
output = zeros(1,useful_data);

m = 1;
for k = 1:L
    output((m - 1)*Nes + 1:m*Nes) = input(:,k);
    m = m + 1;
end


end

