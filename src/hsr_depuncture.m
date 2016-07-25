function data_out = hsr_depuncture(coderate,data_in)
% HSR_DEPUNCTURE Depunctures a block of data using a puncturing pattern
%                according to IEEE 802.11a and ETSI Hiperlan/2.
%
% DATA_OUT = HSR_DEPUNCTURE (CODERATE,DATA_IN)
%    The output DATA_OUT consists of the input DATA_IN with 0's included in
%    the punctured bits. The puncturing pattern P depends on CODERATE:
%       CODERATE = 0, R = 1/2, P = 1
%       CODERATE = 1, R = 2/3, P = 1 1
%                                  1 0
%       CODERATE = 2, R = 3/4, P = 1 1 0
%                                  1 0 1
%       CODERATE = 3, R = 5/6, P = 1 1 0 1 0
%                                  1 0 1 0 1
%

% History:
%         aba 25.07.2001 created
%             14.01.2014 rate 5/6 added

switch coderate
    case 1/2
        data_out = data_in;
        
    case 2/3
        nsymb = size(data_in,2)/3;
        data_out = reshape(data_in,[3,nsymb]);
        data_out = [data_out ; zeros(1,nsymb)];
        data_out = reshape(data_out,[1,4*nsymb]);
        
    case 3/4
        nsymb = size(data_in,2)/4;
        data_out = reshape(data_in,[4,nsymb]);
        data_out = [data_out(1:3,:) ; zeros(2,nsymb) ; data_out(4,:)];
        data_out = reshape(data_out,[1,6*nsymb]);
        
    case 5/6
        nsymb = size(data_in,2)/6;
        data_out = reshape(data_in,[6,nsymb]);
        data_out = [data_out(1:3,:) ; zeros(2,nsymb) ; data_out(4:5,:) ; zeros(2,nsymb) ; data_out(6,:)];
        data_out = reshape(data_out,[1,10*nsymb]);
        
end

end
