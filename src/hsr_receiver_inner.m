function [data_out,signal,long_preamble] = hsr_receiver_inner(data_in)
%HSR_RECEIVER_INNER Inner Receiver for IEEE 802.11a / Hiperlan2
%
%  DATA_OUT = HSR_RECEIVER_INNER (DATA_IN)
%    eliminates the short preamble and the cyclic extension of
%    the received block.
%
%    For a block containing Nsymb data OFDM symbols, DATA_IN is a row vector
%    with (400+Nsymb)*80 elements.
%
%    The long preamble is returned in LONG_PREAMBLE (1x128 row vector) in the time domain;
%    The signal field in SIGNAL (64x1 vector) and
%    the data symbols in DATA_OUT, which is a 64 x Nsymb matrix,
%    are returned in the frequency domain.

% History:
%  Andre Noll Barreto  25.07.2001  created
%                      21.08.2001  long preamble and SIGNAL field returned


global c_sim

version = c_sim.version;
Nfft = c_sim.Nfft;
antenna_array = c_sim.antennas;
Tcp = c_sim.cp_length;
Nss = c_sim.n_streams;
sampling_freq = c_sim.sampling_freq;

Ntx = antenna_array(1);
Nrx = antenna_array(2);

% define positions of different preambles
l_stf_len = 2.5*Nfft;
l_ltf_len = l_stf_len;
l_sig_len = 1.25*Nfft;

if strcmp(c_sim.version,'802.11n')
    ht_sig_len = 2.5*Nfft;
    ht_stf_len = 1.25*Nfft;
    nltf = Ntx;

    if nltf == 3
        nltf = 4;
    end

    ht_ltf_len = nltf*1.25*Nfft;

elseif strcmp(c_sim.version,'802.11ac')
    vht_siga_len = 2.5*Nfft;
    vht_stf_len = 1.25*Nfft;
    vht_sigb_len = 1.25*Nfft;

    nltf = Ntx;

    if nltf == 3
        nltf = 4;
    elseif nltf == 5
        nltf = 6;
    elseif nltf == 7
        nltf = 8;
    end

    vht_ltf_len = nltf*1.25*Nfft;
end

% legacy LTF begins after legacy STF
l_ltf1 = l_stf_len + 1;
long_preamble = data_in(:,l_ltf1:(l_ltf1 + l_ltf_len - 1));

% legacy signal begins after legacy LTF
signal1 = l_stf_len + l_ltf_len + 1;
signal = data_in(:,signal1:(signal1 + l_sig_len - 1));

% discard prefix signal and calculate FFT from signal field
Tg = Nfft/4;
signal = signal(:,Tg + 1:end);

% evaluate FFT
signal = fft(signal)/sqrt(Nfft);

% Data

if strcmp(c_sim.version,'802.11a')
    data_out1 = l_stf_len + l_ltf_len + l_sig_len + 1;
    
elseif strcmp(c_sim.version,'802.11n')
    data_out1 = l_stf_len + l_ltf_len + l_sig_len + ht_sig_len + ...
                ht_stf_len + ht_ltf_len + 1;
            
elseif strcmp(c_sim.version,'802.11ac')
    data_out1 = l_stf_len + l_ltf_len + l_sig_len + vht_siga_len + ...
                vht_stf_len + vht_ltf_len + vht_sigb_len + 1;
            
else
    error('invalid version')
end

Ns = Tcp + Nfft;
data_field = data_in(:,data_out1:end);
Nsym = size(data_field,2)/Ns;

data_out = zeros(Ns,Nsym,Nss);
for i = 1:Nss
    for n = 1:Nsym
        data_out(1:Ns,n,i) = data_field(i,(n - 1)*Ns + 1:n*Ns);
    end
end

% discard prefix cyclic of the data field
data_out = data_out(Tcp + 1:end,:,:);

% evaluate FFT
data_out = fft(data_out)/sqrt(Nfft);

% cyclic shift for multiple antenna
if Ntx == Nrx
    if strcmp(version,'802.11a')
        cs = 0;
    elseif strcmp(version,'802.11n')
        cs = hsr_cyclic_shift('HT',Ntx);
    elseif strcmp(version,'802.11ac')
        cs = hsr_cyclic_shift('VHT',Ntx);
    end

    shiftsamps = zeros(1,Ntx);
    for k = 1:Ntx
        shiftsamps(k) = cs(k)*sampling_freq;
        shiftsamps(k) = 1e-9*shiftsamps(k);
        data_out(:,:,k) = circshift(data_out(:,:,k),-shiftsamps(k));
    end
end

% phase rotation
data_out = hsr_phase_rotation('reception',data_out);

end


