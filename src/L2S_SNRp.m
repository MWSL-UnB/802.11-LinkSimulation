function varargout = L2S_SNRp(c_sim,C_channel)

switch c_sim.w_channel
    case 20
        subSpacing = c_sim.w_channel/64;
        if strcmp(c_sim.version,'802.11a')
            subIdxs = [-26:-1,1:26];
        else
            subIdxs = [-28:-1,1:28];
        end
    case 40
        subSpacing = c_sim.w_channel/128;
        subIdxs = [-58:-2,2:58];
    case 80
        subSpacing = c_sim.w_channel/256;
        subIdxs = [-122:-2,2:122];
    case 160
        subSpacing = c_sim.w_channel/512;
        subIdxs = [-250:-130,-126:-6,6:126,130:250];
end
subFreqs = subSpacing.*subIdxs;

bw2 = c_sim.w_channel/2;
freq = linspace(-bw2,bw2,length(C_channel));

varargout{1} = zeros(length(c_sim.EbN0s),length(subFreqs));
for k = 1:length(c_sim.EbN0s)
    SNR = (10.^(c_sim.EbN0s(k)/10)).*(abs(C_channel)).^2;
    varargout{1}(k,:) = interp1(freq,SNR,subFreqs,'linear');
end

varargout{2} = freq;

end