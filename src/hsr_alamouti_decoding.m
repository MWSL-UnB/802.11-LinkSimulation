function [output,sigmaw2r] = hsr_alamouti_decoding(input,H,sigma)

global c_sim

antenna_array = c_sim.antennas;

Ntx = antenna_array(1);
Nrx = antenna_array(2);
Nsd = size(input,1);
Nsym = size(input,2);

if Ntx == 2 && Nrx == 1
        
    output = zeros(Nsd,Nsym);
    H1 = repmat(H(:,1),[1,Nsym/2]);
    H2 = repmat(H(:,2),[1,Nsym/2]);
    
    output(:,1:2:end) = input(:,1:2:end).*conj(H1) + conj(input(:,2:2:end)).*H2;
    output(:,2:2:end) = input(:,1:2:end).*conj(H2) - conj(input(:,2:2:end)).*H1; 
    
    H1 = repmat(H1,[1,2]);
    H2 = repmat(H2,[1,2]);
    
    output = sqrt(Ntx)*output./(abs(H1).^2 + abs(H2).^2);
    sigmaw2r = sum(sigma,2)/sqrt(Ntx);
    sigmaw2r = repmat(sigmaw2r,[1,Nsym]);
    
end

end

