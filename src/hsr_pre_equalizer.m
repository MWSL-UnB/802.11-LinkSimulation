function [output,Hchannel,pilot_tracker,sigma] = hsr_pre_equalizer(input,H)


global c_sim

Nsp_index = c_sim.Nsp_index;
Nsd_index = c_sim.Nsd_index;

Ntx = size(H,1);
Nrx = size(H,3);

pilot_tracker = input(Nsp_index,:,:);
output = input(Nsd_index,:,:);
H = H(:,Nsd_index,:);

k = 1;
Nsd = size(output,1);
Hchannel = zeros(Nsd,Ntx*Nrx);
sigma = zeros(Nsd,Ntx*Nrx);
for n = 1:Nrx
    for m = 1:Ntx
        Hchannel(:,k) = H(m,:,n);
        sigma(:,k) = Hchannel(:,k).*conj(Hchannel(:,k));

        if k == Ntx*Nrx
            break;
        else
            k = k + 1;
        end
    end
end


end

