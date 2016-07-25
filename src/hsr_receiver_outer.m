function [data_out] = hsr_receiver_outer(data_in,sigmaw2r,p_sim_param, ...
                                         scr_init,ldpc,EbN0_dB)
% HSR_RECEIVER_OUTER Outer Receiver for IEEE 802.11a / Hiperlan2
%
%   DATA_OUT = HSR_RECEIVER_OUTER (DATA_IN, SIGMAW2R,SIM_PARAM,DATALEN,SCR_INIT)
%     The received values in the logical subcarriers are input in DATA_IN, which
%     is a 48 x Nsymb matrix, with NSymb the number of OFDM symbols in a block.
%     Based on the DATA_IN, on the data rate parameter SIM_PARAM (see function
%     HSR_DRATE_PARAM), and on the reciprocal of the noise variance SIGMAW2R
%     (row vector of length 48),the outer receiver obtains the log likelihood
%     ratio of the coded bits. After deinterleaving and depuncturing these values
%     are input to a soft-input Viterbi decoder.
%
%     DATALEN is the packet length in bits (SERVICE field and PSDU), excluding
%     the termination bits.
%
%     SCR_INIT a non-negative integer representing the initial state of the
%     scrambler.
%     
%     LDPC is a struct containing the main LDPC code parameters.
%  
%     EbN0_dB is the current estimated RSR, needed for LDPC decoding only.
%
%     The decoded bits excluding termination and pad bits are output in DATA_OUT
%

% History:
%  Andre Noll Barreto  25.07.2001  created
%  29.10.2001 continuous decoding considered (see c_sim)

global c_sim;

% if strcmp(c_sim.encoder,'BCC')
%     Nsym = size(data,2);
%     data = reshape(data,[c_sim.n_streams,numel(data)/c_sim.n_streams]);
%     
%     % segment parser
%     if c_sim.w_channel == 160
%         data = hsr_segment_parser('downlink',p_sim_param.Nbpsc,p_sim_param.Nes,data);
%     end
%     
%     data = hsr_deinterleaver(p_sim_param.Ncbps,p_sim_param.Nbpsc,Nsym,data);
%     
%     % segment deparser
%     if c_sim.w_channel == 160
%         data = hsr_segment_deparser('downlink',p_sim_param.Nes,p_sim_param.Nbpsc,data);
%     end
%     
%     % Stream deparser
%     if ~strcmp(c_sim.version,'802.11a')
%         data = hsr_stream_deparser(p_sim_param.Nbpsc,p_sim_param.Nes,data);
%     end
%     
%     % depuncture
%     data = hsr_depuncture(p_sim_param.code_rate,data);
%     
%     lengthc = 2*(len + 6);
%     
%     data = data(1:lengthc);
%     
%     % viterbi decoder
%     codetrellis = poly2trellis(7,[133,171]);
%     data = vitdec(-data,codetrellis,c_sim.dec_delay,'term','unquant');
%     data_out = data(1:len);

version = c_sim.version;
channel = c_sim.w_channel;
encoder = c_sim.encoder;
decoder_delay = c_sim.dec_delay;
Nservice = c_sim.service_length;
psdu_length = c_sim.psdu_len;
Nss = c_sim.n_streams;
Nbpsc = p_sim_param.Nbpsc;
Ncbps = p_sim_param.Ncbps;
Nes = p_sim_param.Nes;
code_rate = p_sim_param.code_rate;
modulation = p_sim_param.modulation;
%persistent codetrellis;

% STBC decoder

% demapper and LLR
Kmod = hsr_gain(modulation);
Data = data_in/Kmod;
Data2 = hsr_llrcomp(Data,Nbpsc,sigmaw2r);

samples = size(Data2,1);
symbols = size(Data2,2);
Data3 = zeros(Nss,samples*symbols);
for i = 1:Nss
    for n = 1:symbols
        Data3(i,(n - 1)*samples + 1:n*samples) = Data2(1:samples,n,i);
    end
end

% Segment parser
if strcmp(version,'802.11ac')
    Data4 = hsr_segment_parser('reception',Nbpsc,Nes,Data3);
else
    Data4 = Data3;
end

% Deinterleaver
if strcmp(encoder,'BCC')
    Data5 = hsr_deinterleaver(version,channel,Ncbps,Nbpsc,Nss,symbols,Data4);
elseif strcmp(encoder,'LDPC')
    Data5 = Data4;
end
    
% Segment deparser
if strcmp(version,'802.11ac')
    Data6 = hsr_segment_deparser('reception',Nes,Nbpsc,Data5);
else
    Data6 = Data5;
end

% Stream deparser
if ~strcmp(version,'802.11a')
    Data7 = hsr_stream_deparser(Ncbps,Nbpsc,Nes,Data6);
else
    Data7 = Data6;
end

if strcmp(encoder,'BCC')
    codetrellis = poly2trellis(7,[133,171]);
    if ~strcmp(version,'802.11a')
        Data8 = zeros(Nes,2*code_rate*size(Data7,2));
        Data9 = zeros(Nes,size(Data8,2)/2);
        for n = 1:Nes
            % Depuncture
            Data8(n,:) = hsr_depuncture(code_rate,Data7(n,:));

            % BCC Viterbi decoder
            Data9(n,:) = vitdec(-Data8(n,:),codetrellis,decoder_delay,'term','unquant');
        end

        % Encoder deparser
        Data10 = hsr_encoder_deparser(Nes,Nservice,psdu_length,Data9);
                
    else
        % depuncture
        Data8 = hsr_depuncture(code_rate,Data7);
        
        useful_data = Nservice + 8*psdu_length;
        L = 2*(useful_data + 6);
        Data8 = Data8(1:L);
        
        % BCC Viterbi decoder
        Data9 = vitdec(-Data8,codetrellis,decoder_delay,'term','unquant');
        Data10 = Data9(1:useful_data);
    end

elseif strcmp(encoder,'LDPC')
    
    %inicializando as variáveis
    index=1;
    data_out = [];
    f0_v = [];
    f1_v = [];
    
    snr = 10^(EbN0_dB/10);
    nsr = 1./snr;

    f0 = 1./(1+exp(Data7./nsr));
    f0 = reshape(f0,numel(f0),1);
    f1 = 1-f0;
    
    f0  = reshape(f0,1,[]);
    f1  = reshape(f1,1,[]);
    
    for i=1:1:ldpc.Ncw

        v = ldpc.vector(i);
        v2 = ldpc.vector2(i);
        
        f0_v = f0(index:index+v2-1);
        f1_v = f1(index:index+v2-1);
        
        shrt = ones(1,ldpc.Nshrt);
        shrt = shrt.*f0_v(end);

        if f0_v(end) > 0.5
            f0_v = [f0_v shrt];
        else
             f0_v = [f0_v 1-shrt];
        end
        
        f1_v = 1-f0_v;
        
        f0_v = [f0_v f0(index+v2:index+v-1)];
        f1_v = [f1_v f1(index+v2:index+v-1)];
                       
        pad = ldpc.Lldpc - length(f0_v);

        if pad > 0
            f0_v = [f0_v rand(1,pad)];
            f1_v = [f1_v rand(1,pad)];

        elseif pad < 0
            f0_v = [f0_v(1:end+pad)];
            f1_v = [f1_v(1:end+pad)];

        end

        index = index + v;

        data = SomaProduto(f0_v,f1_v,ldpc.pcm,c_sim.ldpc_max_it);

        data = data(1:ldpc.vector2(i));
        Data10 = [data_out data];
    end
end

% Descrambler

data_out = hsr_scrambler(scr_init,Data10);

end


function [x_hat,sucesso,iteracoes] = SomaProduto(f0,f1,H,max_iter)
%
% [x_hat, sucesso, iteracoes] = SomaProduto(f0,f1,H,max_iter)
%
% Entradas:
% "f0" e "f1" são as probabilidades posteriores do canal (vetores coluna)
% "H" é a matriz de verificação de paridade
% "max_iter" é o número de iterações do algoritmo
%
% Saídas:
% "x_hat" é a estimativa do vetor codificado
% "sucesso" indica se houve ou não falha na decodificação
% "iterações" retorna o número de iterações até a convergência (caso ocorra)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inicializações
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dimensões da matriz
% M = linhas (equações de paridade)
% N = colunas (comprimento do vetor de entrada)
[M, N] = size(H);

% Inicialização do algoritmo
iteracoes = 0;
sucesso = 0;

r_ij_0 = zeros(M, N);
r_ij_1 = zeros(M, N);

q0_temp = zeros(M, N);
q1_temp = zeros(M, N);

%disp('size H')
%disp(size(H))
%disp('size f0')
%disp(size(f0))

% Estimativa inicial para qij^(0) e qij^(1)
q_ij_0 = H.*repmat(f0, M, 1);
q_ij_1 = H.*repmat(f1, M, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Laço de decodificação
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while ((sucesso == 0) && (iteracoes < max_iter))

    x_hat = zeros(N,1);

    % Incrementa iterações
    iteracoes = iteracoes + 1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Passo horizontal
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    delta_q = q_ij_0 - q_ij_1;

    % Varre todas as linhas
    for ii = 1:M

        % Encontra a posição dos elementos não nulos da matriz de paridade
        % (para uma dada linha)
        indices = find(H(ii,:));

        % Determina o valor do produto
        for jj = 1:length(indices)

            delta_r_ij = 1;

            for kk = 1:length(indices)
                if (kk ~= jj)
                    delta_r_ij = delta_r_ij*delta_q(ii,indices(kk));
                end
            end % fim kk

            r_ij_0(ii,indices(jj)) = (1/2)*(1 + delta_r_ij);
            r_ij_1(ii,indices(jj)) = (1/2)*(1 - delta_r_ij);

        end % fim jj
    
    end % fim ii

    % r_ij_1

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Passo vertical
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Varre todas as colunas
    for ii = 1:N

        % Encontra a posição dos elementos não nulos da matriz de paridade
        % (para uma dada coluna)

        indices = find(H(:,ii));

        for jj = 1:length(indices)

            prod_rij_0 = 1;
            prod_rij_1 = 1;

            for kk = 1:length(indices)
                if (kk ~= jj)
                    prod_rij_0 = prod_rij_0*r_ij_0(indices(kk),ii);
                    prod_rij_1 = prod_rij_1*r_ij_1(indices(kk),ii);
                end
            end % fim kk

            % Atualização
            q0_temp(indices(jj), ii) = f0(ii)*prod_rij_0;
            q1_temp(indices(jj), ii) = f1(ii)*prod_rij_1;

            % Normalização
            soma = q0_temp(indices(jj), ii) + q1_temp(indices(jj), ii);
            q_ij_0(indices(jj), ii) = q0_temp(indices(jj), ii)./soma;
            q_ij_1(indices(jj), ii) = q1_temp(indices(jj), ii)./soma;


        end % fim jj

        % Atualização - probabilidade "pseudo posterior"
        qi0_temp = f0(ii)*prod(r_ij_0(indices, ii));
        qi1_temp = f1(ii)*prod(r_ij_1(indices, ii));

        % Normalização
        soma = qi0_temp + qi1_temp;
        Qi0 = qi0_temp/soma;
        Qi1 = qi1_temp/soma;

        % Decisão
        if (Qi1 > Qi0)
            x_hat(ii) = 1;
        else
            x_hat(ii) = 0;
        end

    end % fim ii

    % q_ij_1

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Tentativa de decodificação
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if (rem(H*x_hat,2) == 0)
        sucesso = 1;
    end
     x_hat = x_hat.';
end % fim laço de decodificação (while)

end