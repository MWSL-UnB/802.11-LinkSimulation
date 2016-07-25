function data_out = hsr_subcload(data_in,pilot_in)

%HSR_SUBCLOAD Subcarrier loading for IEEE 802.11a / Hiperlan2
%
%  DATA_OUT = HSR_SUBCLOAD (DATA_IN,PILOT_IN)
%    loads the physical subcarriers with data subcarriers DATA_IN (48xN matrix)
%    and pilot subcarriers PILOT_IN (4 x N matrix). The output DATA_OUT is a
%    64 x N matrix.

%History:
%  Andre Noll Barreto  25.07.2001  created

global c_sim

version = c_sim.version;
Nfft = c_sim.Nfft;
Nsd_index = c_sim.Nsd_index;
Nsp_index = c_sim.Nsp_index;


% determine method to execute */
% load subcarriers with data and pilots

Nsym = size(data_in,2);
Nsts = size(data_in,3);

if strcmp(version,'802.11a')
    data_out = zeros(Nfft,Nsym);
    data_out(Nsd_index,:) = data_in;
    data_out(Nsp_index,:) = pilot_in;
    
elseif strcmp(c_sim.version,'802.11n')
    data_out = zeros(Nfft,Nsym,Nsts);
    data_out(Nsd_index,:,:) = data_in;
    for n = 1:Nsts
        data_out(Nsp_index,:,n) = pilot_in(:,:,n);
    end
    
elseif strcmp(c_sim.version,'802.11ac')
    data_out = zeros(Nfft,Nsym,Nsts);
    data_out(Nsd_index,:,:) = data_in;
    data_out(Nsp_index,:,:) = pilot_in;
    
end
end

