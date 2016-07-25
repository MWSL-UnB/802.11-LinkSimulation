function data_out = hsr_puncture (coderate,data_in)
% HSR_PUNCTURE - Punctures a block of data using a puncturing pattern
%                according to IEEE 802.11a and ETSI Hiperlan/2.
%
% DATA_OUT = HSR_DEPUNCTURE (CODERATE,DATA_IN)
%    The puncturing pattern P depends on CODERATE:
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
        data_out = reshape(data_in,4,length(data_in)/4);
        data_out = data_out(1:3,:);
        data_out = reshape(data_out,1,3*size(data_out,2));
    case 3/4
        data_out = reshape(data_in,6,length(data_in)/6);
        data_out = data_out([1:3,6],:);
        data_out = reshape(data_out,1,4*size(data_out,2));
    case 5/6
        data_out = reshape(data_in,10,length(data_in)/10);
        data_out = data_out([1:3,6,7,10],:);
        data_out = reshape(data_out,1,6*size(data_out,2));
    otherwise
        error ('HSR_PUNCTURE: invalid code rate');
end
    