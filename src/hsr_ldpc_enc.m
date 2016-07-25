function [ data_out, ldpc] = hsr_ldpc_enc( data_in, p_TXVECTOR)
%HSR_LDPC encoder for IEEE 802.11a / Hiperlan2
%
% [DATA, LDPC] = HSR_LDPC(DATA_IN, TXVECTOR)
%   outputs in DATA a PHY burst defined by the bits in DATA_IN and encoded
%   with LDPC.
%   The PHY burst is defined by TXVECTOR, which has the
%   following fields:
%      .LENGTH      number of bytes per packet/ofdm frame
%      .DATARATE    data rate index, see hsr_drate_param.m
%      .SERVICE     SERVICE field, e.g. [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
%      .TXPWR_LEVEL TX power level 1..8 (not implemented yet)
%   LDPC is a struct with LDPC parameters
%

%History:
%  Andre Noll Barreto  15.01.2014  created, based on code by João Paulo
%                                  Leite and Marley Mattos


global c_sim;
sim_param = hsr_drate_param(p_TXVECTOR.datarate);

if c_sim.antennas(1) > c_sim.n_streams
    mSTBC = 2;
else
    mSTBC = 1;
end

ldpc.Npld = p_TXVECTOR.length * 8 + c_sim.service_length;

R = sim_param.code_rate; %data rate

p_Ncbps = sim_param.Ncbps;

%total number of coded bits
ldpc.Navbits = p_Ncbps * mSTBC * ceil(ldpc.Npld/(p_Ncbps*R*mSTBC));

%calculate LDPC codewords and ldpc.Lldpc
if ldpc.Navbits <= 648
    ldpc.Ncw = 1;
    if ldpc.Navbits >= (ldpc.Npld+(912*(1-R)))
        ldpc.Lldpc = 1296;
    else
        ldpc.Lldpc = 648;
    end
elseif (ldpc.Navbits > 648) && (ldpc.Navbits <= 1296)
    ldpc.Ncw = 1;
    if ldpc.Navbits >= (ldpc.Npld+(1464*(1-R)))
        ldpc.Lldpc = 1944;
    else
        ldpc.Lldpc = 1296;
    end
elseif (ldpc.Navbits > 1296) && (ldpc.Navbits <= 1944)
    ldpc.Ncw = 1;
    ldpc.Lldpc = 1944;
elseif (ldpc.Navbits > 1944) && (ldpc.Navbits <= 2592)
    ldpc.Ncw = 2;
    if ldpc.Navbits >= (ldpc.Npld+(2916*(1-R)))
        ldpc.Lldpc = 1944;
    else
        ldpc.Lldpc = 1296;
    end
elseif ldpc.Navbits > 2592
    ldpc.Ncw = ceil(ldpc.Npld/(1944*R));
    ldpc.Lldpc = 1944;
end

ldpc.Nshrt = max(0,(ldpc.Ncw*ldpc.Lldpc*R)-ldpc.Npld); %shortened bits
ldpc.Npunc = max(0,(ldpc.Ncw*ldpc.Lldpc)-ldpc.Navbits-ldpc.Nshrt); %puncture

if ((ldpc.Npunc > 0.1*ldpc.Ncw*ldpc.Lldpc*(1-R)) && (ldpc.Nshrt < 1.2*ldpc.Npunc*R/(1-R))) || (ldpc.Npunc > 0.3*ldpc.Ncw*ldpc.Lldpc*(1-R))
    ldpc.Navbits = ldpc.Navbits + p_Ncbps*mSTBC;
    ldpc.Npunc = max(0,(ldpc.Ncw*ldpc.Lldpc)-ldpc.Navbits-ldpc.Nshrt);
end

p_Nsym = ldpc.Navbits/p_Ncbps; %number of OFDM symbols
ldpc.Nrep = max(0,ldpc.Navbits-ldpc.Ncw*ldpc.Lldpc*(1-R)-ldpc.Npld); %coded bits to be repeated
Nspcw = floor(ldpc.Nshrt/ldpc.Ncw); %minimum number of shortening bits per code word

data_out = data_in;

vector = [];
vector2 = [];

%transmitting ldpc.Ncw packets
if ldpc.Ncw == 1
    ldpc.parity = ldpc.Lldpc*(1-R);
    data1 = [data_out zeros(1,ldpc.Nshrt)];
    [data2,ldpc.pcm] = ldpc_encoder(data1, (1/R)*length(data1), sim_param.crate); %encoder
    
    ldpc.vector2 = length(data_out);
    
    %discarding shortened bits
    data_out = data2(1:ldpc.Npld);
    data_out = [data_out data2(ldpc.Npld+ldpc.Nshrt+1:end)];
    
    if ldpc.Npunc > 0
        data_out = data_out(1:end-ldpc.Npunc);
        ldpc.vector = (ldpc.Lldpc*(1-R))-ldpc.Npunc+ldpc.vector2;
    elseif ldpc.Nrep > 0
        data_out = [data_out data_out(1:ldpc.Nrep)];
        ldpc.vector = (ldpc.Lldpc*(1-R))+ldpc.Nrep+ldpc.vector2;
    elseif ldpc.Nrep == o && ldpc.Npunc == 0
        data_out = data_out(1:end);
        ldpc.vector = (ldpc.Lldpc*(1-R))+ldpc.vector2;
    end
    
else
    count = 1;
    aux = 1;
    min_shrt = ldpc.Nshrt - (ldpc.Ncw*Nspcw);
    
    b_Ncw = floor(ldpc.Npld/ldpc.Ncw);
    ldpc.parity = ldpc.Lldpc*(1-R); %parity bits
    
    if min_shrt ~= 0
        for i=1:b_Ncw:min_shrt*b_Ncw
            data1 = [data_out(i:i+b_Ncw-1) zeros(1,Nspcw) 0];
            [data2,ldpc.pcm] = ldpc_encoder(data1, (1/R)*length(data1), ...
                                            sim_param.crate); %encoder
            
            vector = [vector b_Ncw];
            
            %discarding shortened bits
            data3(aux:aux+b_Ncw-1) = data2(1:b_Ncw);
            aux=length(data3)+1;
            data3(aux:aux+ldpc.parity-1) = data2(b_Ncw+Nspcw+2:end);
            aux=length(data3)+1;
            
            %puncturing
            if ldpc.Npunc > 0
                r = rem(ldpc.Npunc,ldpc.Ncw);
                Nppcw = floor(ldpc.Npunc/ldpc.Ncw); %minimum number of punctured parity bits per code word
                if count <= r
                    data3 = data3(1:end-Nppcw-1);
                    vector2 = [vector2 Nppcw+1];
                elseif count > r
                    data3 = data3(1:end-Nppcw);
                    vector2 = [vector2 Nppcw];
                end
                aux=length(data3)+1;
                count=count+1;
            end
            
            %repetition
            if ldpc.Nrep > 0
                r = rem(ldpc.Nrep,ldpc.Ncw);
                Nrpcw = floor(ldpc.Nrep/ldpc.Ncw);
                if count <= r
                    data3 = [data3 data2(1:Nrpcw+1)];
                    vector2 = [vector2 Nrpcw+1];
                elseif count > r
                    data3 = [data3 data2(1:Nrpcw)];
                    vector2 = [vector2 Nrpcw];
                end
                aux=length(data3)+1;
                count=count+1;
            end
        end
        
        for j=(min_shrt*b_Ncw)+1:b_Ncw+1:ldpc.Npld
            
            data1 = [data_out(j:j+b_Ncw) zeros(1,Nspcw)];
            [data2,ldpc.pcm] = ldpc_encoder(data1, (1/R)*length(data1), ...
                                            sim_param.crate);
            
            %discarding shortened bits
            data3(aux:aux+b_Ncw) = data2(1:b_Ncw+1);
            aux=length(data3)+1;
            data3(aux:aux+ldpc.parity-1) = data2(b_Ncw+Nspcw+2:end);
            aux=length(data3)+1;
            
            vector = [vector b_Ncw+1];
            
            %puncturing
            if ldpc.Npunc > 0
                r = rem(ldpc.Npunc,ldpc.Ncw);
                Nppcw = floor(ldpc.Npunc/ldpc.Ncw); %minimum number of punctured parity bits per code word
                if count <= r
                    data3 = data3(1:end-Nppcw-1);
                    vector2 = [vector2 Nppcw+1];
                elseif count > r
                    data3 = data3(1:end-Nppcw);
                    vector2 = [vector2 Nppcw];
                end
                count=count+1;
                aux=length(data3)+1;
            end
            
            %Repetition
            if ldpc.Nrep > 0
                r = rem(ldpc.Nrep,ldpc.Ncw);
                Nrpcw = floor(ldpc.Nrep/ldpc.Ncw);
                if count <= r
                    data3 = [data3 data2(1:Nrpcw+1)];
                    vector2 = [vector2 Nrpcw+1];
                elseif count > r
                    data3 = [data3 data2(1:Nrpcw)];
                    vector2 = [vector2 Nrpcw];
                end
                aux=length(data3)+1;
                count=count+1;
            end
        end
        
        data_out=data3;
        
    elseif min_shrt == 0
        aux=1;
        aux1=1;
        count=1;
        for c=1:1:ldpc.Ncw
            data1 = [data_out(aux1:c*b_Ncw) zeros(1,Nspcw)];
            [data2, ldpc.pcm] = ldpc_encoder( data1, (1/R)*length(data1), ...
                                              sim_param.code_rate);
            
            aux1=aux1+b_Ncw;
            
            vector = [vector b_Ncw];
            
            %discarding shortened bits
            data3(aux:aux+b_Ncw-1) = data2(1:b_Ncw);
            aux=length(data3)+1;
            data3(aux:aux+ldpc.parity-1) = data2(ldpc.Lldpc-ldpc.parity+1:end);
            aux=length(data3)+1;
            
            %puncturing
            if ldpc.Npunc > 0
                r = rem(ldpc.Npunc,ldpc.Ncw);
                Nppcw = floor(ldpc.Npunc/ldpc.Ncw); %minimum number of punctured parity bits per code word
                if r==0
                    data3 = data3(1:end-Nppcw);
                    vector2 = [vector2 Nppcw];
                else
                    if count <= r
                        data3 = data3(1:end-Nppcw-1);
                        vector2 = [vector2 Nppcw-1];
                    elseif count > r
                        data3 = data3(1:end-Nppcw);
                        vector2 = [vector2 Nppcw];
                    end
                end
                aux=length(data3)+1;
                count=count+1;
            end
            
            %Repetition
            if ldpc.Nrep > 0
                r = rem(ldpc.Nrep,ldpc.Ncw);
                Nrpcw = floor(ldpc.Nrep/ldpc.Ncw);
                if r == 0
                    data3 = [data3 data2(1:Nrpcw)];
                    vector2 = [vector2 Nrpcw];
                else
                    if count <= r
                        data3 = [data3 data2(1:Nrpcw+1)];
                        vector2 = [vector2 Nrpcw+1];
                    elseif count > r
                        data3 = [data3 data2(1:Nrpcw)];
                        vector2 = [vector2 Nrpcw];
                    end
                end
                aux=length(data3)+1;
                count=count+1;
            end
        end
        data_out=data3;
    end
    
    if ldpc.Nrep > 0
        vector2 = (ldpc.Lldpc*(1-R))+vector2;
        ldpc.vector = vector+vector2;
        ldpc.vector2 = vector;
    elseif ldpc.Npunc > 0
        vector2 = (ldpc.Lldpc*(1-R))-vector2;
        ldpc.vector = vector+vector2;
        ldpc.vector2 = vector;
    elseif ldpc.Nrep == 0 && ldpc.Npunc == 0
        vector2 = (ldpc.Lldpc*(1-R))+vector2;
        ldpc.vector = vector+vector2;
        ldpc.vector2 = vector;
    end
end


function [C, H] = ldpc_encoder(X, N, R)
%% Codificador LPDC para protocolo 802.11n
% [x_hat, sucesso, iteracoes] = SomaProduto(f0,f1,H,max_iter)
%
% Entradas:
% "N" é o comprimento do bloco de palavras-código
% "R" é a taxa de codificação
% "X" é o vetor de dados de entrada
%
% Saídas:
% "C" é o vetor de dados codificado
% "H" é a matrix de verificação de paridade (PCM) para o código
%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inicializações
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%K = comprimento do bloco de informação
l = length(X);
K = round(N.*R);

%HP = load('PCM_N_648_R_1%2.txt');
 %   Z = 27;

%X1 = Divisão do vetor de bits de entrada em blocos de comprimento K
X1 = reshape(X,K,[])';

%HP = Protótipo da matrix de paridade com as sub-matrizes de deslocamento
%     cíclico da matriz identidade I[Z X Z](vide norma 802.11n anexo R)
if (N==648 && R==1/2)
    HP = [0 NaN NaN NaN 0 0 NaN NaN 0 NaN NaN 0 1 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;
          22 0 NaN NaN 17 NaN 0 0 12 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN;
          6 NaN 0 NaN 10 NaN NaN NaN 24 NaN 0 NaN NaN NaN 0 0 NaN NaN NaN NaN NaN NaN NaN NaN;
          2 NaN NaN 0 20 NaN NaN NaN 25 0 NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN NaN NaN NaN;
          23 NaN NaN NaN 3 NaN NaN NaN 0 NaN 9 11 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN NaN NaN;
          24 NaN 23 1 17 NaN 3 NaN 10 NaN NaN NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN NaN;
          25 NaN NaN NaN 8 NaN NaN NaN 7 18 NaN NaN 0 NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN;
          13 24 NaN NaN 0 NaN 8 NaN 6 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN;
          7 20 NaN 16 22 10 NaN NaN 23 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0 0 NaN NaN;
          11 NaN NaN NaN 19 NaN NaN NaN 13 NaN 3 17 NaN NaN NaN NaN NaN NaN NaN NaN NaN 0 0 NaN;
          25 NaN 8 NaN 23 18 NaN 14 9 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0 0;
          3 NaN NaN NaN 16 NaN NaN 2 25 5 NaN NaN 1 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0];
    Z = 27;
elseif (N==648 && R==2/3)
    HP = [25 26 14 NaN 20 NaN 2 NaN 4 NaN NaN 8 NaN 16 NaN 18 1 0 NaN NaN NaN NaN NaN NaN;
          10 9 15 11 NaN 0 NaN 1 NaN NaN 18 NaN 8 NaN 10 NaN NaN 0 0 NaN NaN NaN NaN NaN;
          16 2 20 26 21 NaN 6 NaN 1 26 NaN 7 NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN;
          10 13 5 0 NaN 3 NaN 7 NaN NaN 26 NaN NaN 13 NaN 16 NaN NaN NaN 0 0 NaN NaN NaN;
          23 14 24 NaN 12 NaN 19 NaN 17 NaN NaN NaN 20 NaN 21 NaN 0 NaN NaN NaN 0 0 NaN NaN;
          6 22 9 20 NaN 25 NaN 17 NaN 8 NaN 14 NaN 18 NaN NaN NaN NaN NaN NaN NaN 0 0 NaN;
          14 23 21 11 20 NaN 24 NaN 18 NaN 19 NaN NaN NaN NaN 22 NaN NaN NaN NaN NaN NaN 0 0;
          17 11 11 20 NaN 21 NaN 26 NaN 3 NaN NaN 18 NaN 26 NaN 1 NaN NaN NaN NaN NaN NaN 0];
    Z = 27;
elseif (N==648 && R==3/4)
    HP = [16 17 22 24 9 3 14 NaN 4 2 7 NaN 26 NaN 2 NaN 21 NaN 1 0 NaN NaN NaN NaN;
          25 12 12 3 3 26 6 21 NaN 15 22 NaN 15 NaN 4 NaN NaN 16 NaN 0 0 NaN NaN NaN;
          25 18 26 16 22 23 9 NaN 0 NaN 4 NaN 4 NaN 8 23 11 NaN NaN NaN 0 0 NaN NaN;
          9 7 0 1 17 NaN NaN 7 3 NaN 3 23 NaN 16 NaN NaN 21 NaN 0 NaN NaN 0 0 NaN;
          24 5 26 7 1 NaN NaN 15 24 15 NaN 8 NaN 13 NaN 13 NaN 11 NaN NaN NaN NaN 0 0;
          2 2 19 14 24 1 15 19 NaN 21 NaN 2 NaN 24 NaN 3 NaN 2 1 NaN NaN NaN NaN 0];
    Z = 27;
elseif (N==648 && R==5/6)
    HP = [17 13 8 21 9 3 18 12 10 0 4 15 19 2 5 10 26 19 13 13 1 0 NaN NaN;
          3 12 11 14 11 25 5 18 0 9 2 26 26 10 24 7 14 20 4 2 NaN 0 0 NaN;
          22 16 4 3 10 21 12 5 21 14 19 5 NaN 8 5 18 11 5 5 15 0 NaN 0 0;
          7 7 14 14 4 16 16 24 24 10 1 7 15 6 10 26 8 18 21 14 1 NaN NaN 0];
    Z = 27;
elseif (N==1296 && R==1/2)
    HP = [40 NaN NaN NaN 22 NaN 49 23 43 NaN NaN NaN 1 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;
          50 1 NaN NaN 48 35 NaN NaN 13 NaN 30 NaN NaN 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN;
          39 50 NaN NaN 4 NaN 2 NaN NaN NaN NaN 49 NaN NaN 0 0 NaN NaN NaN NaN NaN NaN NaN NaN;
          33 NaN NaN 38 37 NaN NaN 4 1 NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN NaN NaN NaN;
          45 NaN NaN NaN 0 22 NaN NaN 20 42 NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN NaN NaN;
          51 NaN NaN 48 35 NaN NaN NaN 44 NaN 18 NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN NaN;
          47 11 NaN NaN NaN 17 NaN NaN 51 NaN NaN NaN 0 NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN;
          5 NaN 25 NaN 6 NaN 45 NaN 13 40 NaN NaN NaN NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN;
          33 NaN NaN 34 24 NaN NaN NaN 23 NaN NaN 46 NaN NaN NaN NaN NaN NaN NaN NaN 0 0 NaN NaN;
          1 NaN 27 NaN 1 NaN NaN NaN 38 NaN 44 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0 0 NaN;
          NaN 18 NaN NaN 23 NaN NaN 8 0 35 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0 0;
          49 NaN 17 NaN 30 NaN NaN NaN 34 NaN NaN 19 1 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0];
    Z = 54;
elseif (N==1296 && R==2/3)
    HP = [ 39 31 22 43 NaN 40 4 NaN 11 NaN NaN 50 NaN NaN NaN 6 1 0 NaN NaN NaN NaN NaN NaN;
           25 52 41 2 6 NaN 14 NaN 34 NaN NaN NaN 24 NaN 37 NaN NaN 0 0 NaN NaN NaN NaN NaN;
           43 31 29 0 21 NaN 28 NaN NaN 2 NaN NaN 7 NaN 17 NaN NaN NaN 0 0 NaN NaN NaN NaN;
           20 33 48 NaN 4 13 NaN 26 NaN NaN 22 NaN NaN 46 42 NaN NaN NaN NaN 0 0 NaN NaN NaN;
           45 7 18 51 12 25 NaN NaN NaN 50 NaN NaN 5 NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN;
           35 40 32 16 5 NaN NaN 18 NaN NaN 43 51 NaN 32 NaN NaN NaN NaN NaN NaN NaN 0 0 NaN;
           9 24 13 22 28 NaN NaN 37 NaN NaN 25 NaN NaN 52 NaN 13 NaN NaN NaN NaN NaN NaN 0 0;
           32 22 4 21 16 NaN NaN NaN 27 28 NaN 38 NaN NaN NaN 8 1 NaN NaN NaN NaN NaN NaN 0];
    Z = 54;
elseif (N==1296 && R==3/4)
    HP = [ 39 40 51 41 3 29 8 36 NaN 14 NaN 6 NaN 33 NaN 11 NaN 4 1 0 NaN NaN NaN NaN;
           48 21 47 9 48 35 51 NaN 38 NaN 28 NaN 34 NaN 50 NaN 50 NaN NaN 0 0 NaN NaN NaN;
           30 39 28 42 50 39 5 17 NaN 6 NaN 18 NaN 20 NaN 15 NaN 40 NaN NaN 0 0 NaN NaN;
           29 0 1 43 36 30 47 NaN 49 NaN 47 NaN 3 NaN 35 NaN 34 NaN 0 NaN NaN 0 0 NaN;
           1 32 11 23 10 44 12 7 NaN 48 NaN 4 NaN 9 NaN 17 NaN 16 NaN NaN NaN NaN 0 0;
           13 7 15 47 23 16 47 NaN 43 NaN 29 NaN 52 NaN 2 NaN 53 NaN 1 NaN NaN NaN NaN 0];
    Z = 54;
elseif (N==1296 && R==5/6)
    HP = [ 48 29 37 52 2 16 6 14 53 31 34 5 18 42 53 31 45 NaN 46 52 1 0 NaN NaN;
           17 4 30 7 43 11 24 6 14 21 6 39 17 40 47 7 15 41 19 NaN NaN 0 0 NaN;
           7 2 51 31 46 23 16 11 53 40 10 7 46 53 33 35 NaN 25 35 38 0 NaN 0 0;
           19 48 41 1 10 7 36 47 5 29 52 52 31 10 26 6 3 2 NaN 51 1 NaN NaN 0];
    Z = 54;
elseif (N==1944 && R==1/2)
    HP = [ 57 NaN NaN NaN 50 NaN 11 NaN 50 NaN 79 NaN 1 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;
           3 NaN 28 NaN 0 NaN NaN NaN 55 7 NaN NaN NaN 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN;
           30 NaN NaN NaN 24 37 NaN NaN 56 14 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN NaN NaN NaN NaN;
           62 53 NaN NaN 53 NaN NaN 3 35 NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN NaN NaN NaN;
           40 NaN NaN 20 66 NaN NaN 22 28 NaN NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN NaN NaN;
           0 NaN NaN NaN 8 NaN 42 NaN 50 NaN NaN 8 NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN NaN;
           69 79 79 NaN NaN NaN 56 NaN 52 NaN NaN NaN 0 NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN;
           65 NaN NaN NaN 38 57 NaN NaN 72 NaN 27 NaN NaN NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN;
           64 NaN NaN NaN 14 52 NaN NaN 30 NaN NaN 32 NaN NaN NaN NaN NaN NaN NaN NaN 0 0 NaN NaN;
           NaN 45 NaN 70 0 NaN NaN NaN 77 9 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0 0 NaN;
           2 56 NaN 57 35 NaN NaN NaN NaN NaN 12 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0 0;
           24 NaN 61 NaN 60 NaN NaN 27 51 NaN NaN 16 1 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0];
    Z = 81;
elseif (N==1944 && R==2/3)
    HP = [ 61 75 4 63 56 NaN NaN NaN NaN NaN NaN 8 NaN 2 17 25 1 0 NaN NaN NaN NaN NaN NaN;
           56 74 77 20 NaN NaN NaN 64 24 4 67 NaN 7 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN NaN;
           28 21 68 10 7 14 65 NaN NaN NaN 23 NaN NaN NaN 75 NaN NaN NaN 0 0 NaN NaN NaN NaN;
           48 38 43 78 76 NaN NaN NaN NaN 5 36 NaN 15 72 NaN NaN NaN NaN NaN 0 0 NaN NaN NaN;
           40 2 53 25 NaN 52 62 NaN 20 NaN NaN 44 NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN;
           69 23 64 10 22 NaN 21 NaN NaN NaN NaN NaN 68 23 29 NaN NaN NaN NaN NaN NaN 0 0 NaN;
           12 0 68 20 55 61 NaN 40 NaN NaN NaN 52 NaN NaN NaN 44 NaN NaN NaN NaN NaN NaN 0 0;
           58 8 34 64 78 NaN NaN 11 78 24 NaN NaN NaN NaN NaN 58 1 NaN NaN NaN NaN NaN NaN 0];
    Z = 81;
elseif (N==1944 && R==3/4)
    HP = [ 48 29 28 39 9 61 NaN NaN NaN 63 45 80 NaN NaN NaN 37 32 22 1 0 NaN NaN NaN NaN;
           4 49 42 48 11 30 NaN NaN NaN 49 17 41 37 15 NaN 54 NaN NaN NaN 0 0 NaN NaN NaN;
           35 76 78 51 37 35 21 NaN 17 64 NaN NaN NaN 59 7 NaN NaN 32 NaN NaN 0 0 NaN NaN;
           9 65 44 9 54 56 73 34 42 NaN NaN NaN 35 NaN NaN NaN 46 39 0 NaN NaN 0 0 NaN;
           3 62 7 80 68 26 NaN 80 55 NaN 36 NaN 26 NaN 9 NaN 72 NaN NaN NaN NaN NaN 0 0;
           26 75 33 21 69 59 3 38 NaN NaN NaN 35 NaN 62 36 26 NaN NaN 1 NaN NaN NaN NaN 0];
    Z = 81;
elseif (N==1944 && R==5/6)
    HP = [ 13 48 80 66 4 74 7 30 76 52 37 60 NaN 49 73 31 74 73 23 NaN 1 0 NaN NaN;
           69 63 74 56 64 77 57 65 6 16 51 NaN 64 NaN 68 9 48 62 54 27 NaN 0 0 NaN;
           51 15 0 80 24 25 42 54 44 71 71 9 67 35 NaN 58 NaN 29 NaN 53 0 NaN 0 0;
           16 29 36 41 44 56 59 37 50 24 NaN 65 4 65 52 NaN 4 NaN 73 52 1 NaN NaN 0];
    Z = 81;
end



I=eye(Z);

%H = [H1 H2], H1 = [(n-K) K], H2 = [(N-K) (N-K)]
%HP = [H1P H2P]
m = round((N-K)./Z);
b = round(R.*N/Z);
H1P = HP(:,1:b);
H2P = HP(:,b+1:b+m);

%Construindo a matrix H1
H1 = zeros(m.*Z,b.*Z); 
[lin, col] = find(isfinite(H1P));

for cont1 = 1:length(H1P(:,1))
    indices1 = find(lin==cont1);
    for cont2 = 1:length(indices1)
       H1((lin(indices1(cont2))-1)*Z+1:lin(indices1(cont2))*Z,(col(indices1(cont2))-1)*Z+1:col(indices1(cont2))*Z) =...
           circshift(I,[0 H1P(lin(indices1(cont2)),col(indices1(cont2)))]);
    end    
end

%Construindo a matrix H2
H2 = zeros(m.*Z,m.*Z); 
[lin2, col2] = find(isfinite(H2P));

%Varre as linhas de H2P
for cont3 = 1:length(H2P(:,1))
    indices2 = find(lin2==cont3);
    %Varre os elementos não nulos da linha de índice "cont3"
    for cont4 = 1:length(indices2)
       H2((lin2(indices2(cont4))-1)*Z+1:lin2(indices2(cont4))*Z,(col2(indices2(cont4))-1)*Z+1:col2(indices2(cont4))*Z) =...
           circshift(I,[0 H2P(lin2(indices2(cont4)),col2(indices2(cont4)))]);
    end    
end

%Construindo H
H = [H1 H2];

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Processo de codificação
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Como o código é sistemático, c = [m ldpc], em que m é o bloco de informação 
%de entrada e ldpc são os bits de paridade para esse bloco. Os bits de
%paridade são calculados segundo demonstração em [2].

%
c = zeros(length(X1(:,1)), N);
%Varre os blocos de informação de entrada
for cont5 = 1:length(X1(:,1))
    
    ldpc = [];
    parcial = mod(H1*X1(cont5,:)', 2);
    parcial = reshape(parcial, Z, []);
    
    %Varre os m sub-blocos de dimensão 1 X Z do vetor de paridade ldpc
    for cont6 = 1:m
        a = cont6;
        %Cálculo dos sub-blocos de dimensão 1 X Z do vetor de paridade 
        if(cont6==1)
            p0T = mod(sum(parcial,2), 2);
            parcial2 = p0T;
        elseif(cont6==2)
            parcial2 = mod(parcial(:,a-1) + H2(((a-2)*Z+1):((a-1)*Z),1:Z)*p0T, 2);
        else
            parcial2 = mod(parcial(:,a-1) + H2(((a-2)*Z+1):((a-1)*Z),1:Z)*p0T + parcial2 ,2);
        end %fim if
        %Montagem dos bits de paridade do bloco de entrada de indice "cont5"
        ldpc = [ldpc parcial2'];
        
    end %fim cont6
    
    %c = blocos de palavra-código
    c(cont5,:)=[X1(cont5,:) ldpc];
    
end %fim cont5

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Construindo vetor serial de dados codificados
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C = reshape(c',1,[]);

%% Referências
%[1] IEEE Standard for Information Technology- IEEE Std 802.11n. Part 11:
%    Wireless LAN Medium Access Control (MAC) and Physical Layer(PHY) 
%    Specifications. 2009.
%[2] Yang Sun, Marjan Karkooti and Joseph R. Cavallaro. High Throughput,
%    Parallel, Scalable LDPC Encoder/Decoder Architecture for OFDM Systems
%    Design, Applications, Integration and Software. Pp. 39-42. Dallas,
%    EUA, outubro, 2006.
