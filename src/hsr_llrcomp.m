function y = hsr_llrcomp(x,nbpsc,sigmaw2r)

% HSR_LLRCOMP - Computes log-likelihood ratios (LLRs) for OFDM according to
%   IEEE 802.11a and ETSI Hiperlan/2. The LLR computation follows
%
%   F. Neeser, "OFDM: Coding Aspects", Internal Report, Rev. 1.5, 08/2000.
%
%   Y = HSR_LLRCOMP(X, NBPSC, SIGMAW2R)
%     computes LLRs Y based on channel outputs X, given the number of bits per
%     subcarrier NBPSC and the reciprocal logical subcarrier noise variances
%     SIGMAW2R. The input signal X is assumed to be de-normalized so that, in
%     the absence of noise, the values of their real and imaginary parts are
%     odd integers.
%     NBPSC must be an integer blonging to {1,2,4,6}.
%     SIGMAW2R must be a column vector of length 48.
%     X must be a 48 x N matrix.
%     Y has dimension 48*NBPSC x N.

% History:
% Andre Noll Barreto  25.07.2001  created

global c_sim

ndsc = c_sim.Nsd;
nsymb = size(x,2);
Nss = c_sim.n_streams;

switch nbpsc
    case 1
        y = real(x).*sigmaw2r;
        %y = real(x).*repmat(sigmaw2r,[1,nsymb,Nss]);
    case 2
        x = x.*sigmaw2r;
        %x = x.*repmat(sigmaw2r,1,nsymb);
        y(1:2:ndsc*2 - 1,:) = real(x);
        y(2:2:ndsc*2,:) = imag(x);
    case 4
        %sigmaw2r = repmat(sigmaw2r,[1,nsymb,Nss]);
        y(1:4:ndsc*4 - 3,:) = f_type2(real(x),0).*sigmaw2r;
        y(2:4:ndsc*4 - 2,:) = f_type2(real(x),1).*sigmaw2r;
        y(3:4:ndsc*4 - 1,:) = f_type2(imag(x),0).*sigmaw2r;
        y(4:4:ndsc*4,:) = f_type2(imag(x),1).*sigmaw2r;
    case 6
        %sigmaw2r = repmat(sigmaw2r,[1,nsymb,Nss]);
        y(1:6:ndsc*6 - 5,:) = f_type3(real(x),0).*sigmaw2r;
        y(2:6:ndsc*6 - 4,:) = f_type3(real(x),1).*sigmaw2r;
        y(3:6:ndsc*6 - 3,:) = f_type3(real(x),2).*sigmaw2r;
        y(4:6:ndsc*6 - 2,:) = f_type3(imag(x),0).*sigmaw2r;
        y(5:6:ndsc*6 - 1,:) = f_type3(imag(x),1).*sigmaw2r;
        y(6:6:ndsc*6,:) = f_type3(imag(x),2).*sigmaw2r;
    case 8
        %sigmaw2r = repmat(sigmaw2r,[1,nsymb,Nss]);
        y(1:8:ndsc*8 - 7,:) = f_type4(real(x),0).*sigmaw2r;
        y(2:8:ndsc*8 - 6,:) = f_type4(real(x),1).*sigmaw2r;
        y(3:8:ndsc*8 - 5,:) = f_type4(real(x),2).*sigmaw2r;
        y(4:8:ndsc*8 - 4,:) = f_type4(real(x),3).*sigmaw2r;
        y(5:8:ndsc*8 - 3,:) = f_type4(imag(x),0).*sigmaw2r;
        y(6:8:ndsc*8 - 2,:) = f_type4(imag(x),1).*sigmaw2r;
        y(7:8:ndsc*8 - 1,:) = f_type4(imag(x),2).*sigmaw2r;
        y(8:8:ndsc*8,:) = f_type4(imag(x),3).*sigmaw2r;
        
otherwise
    error('HSR_LLRCOMP: invalid NBPSC');
end
end


function f = f_type2(x,n)
    d = 1;
    if n == 0
        %f = x + (abs(x)>2).*(x - 2*sign(x));
        f = (x <= -2*d).*(4*d*(d + x)) + (x > -2*d & x <= 2*d).*(2*d*x) + (x > 2*d).*(-4*d*(d - x));
    else
        %f = 2 - abs(x);
        f = (x <= 0).*(2*d*(2*d + x)) + (x > 0).*(2*d*(2*d - x));
    end
end
    

function f = f_type3(x,n)
    d = 1;
    %xAbs = abs(x);
    switch n
        case 0
%             aux = min(floor(xAbs/2),3);
%             f = (aux + 1).*(xAbs - aux);
%             f = f.*sign(x);
            f = (x <= -6*d).*(4*d*(3*d + x)) + (x > -6*d & x <= -4*d).*(3*d*(2*d + x)) + (x > -4*d & x <= -2*d).*(2*d*(d + x)) + ...
                (x > -2*d & x <= 2*d).*(d*x) + (x > 2*d & x <= 4*d).*(-2*d*(d - x)) + (x > 4*d & x <= 6*d).*(-3*d*(2*d - x)) + (x > 6*d).*(-4*d*(3*d - x));
        case 1
            %f = (xAbs > 6).*(2*(5 - xAbs)) + (xAbs > 2 & xAbs <= 6).*(4 - xAbs) + (xAbs <= 2).*(2*(3 - xAbs));
            f = (x <= -6*d).*(2*d*(5*d + x)) + (x > -6*d & x <= -2*d).*(d*(4*d + x)) + (x > -2*d & x <= 0).*(2*d*(3*d + x)) + ...
                (x > 0 & x <= 2*d).*(2*d*(3*d - x)) + (x > 2*d & x <= 6*d).*(d*(4*d - x)) + (x > 6*d).*(2*d*(5*d - x));
        case 2
            %f = 2 - abs(4 - xAbs);
            f = (x <= -4*d).*(d*(6*d + x)) + (x > -4*d & x <= 0).*(-d*(2*d + x)) + (x > 0 & x <= 4*d).*(-d*(2*d - x)) + (x > 4*d).*(d*(6*d - x));
    end
end

function f = f_type4(x,n)
    d = 1;
    switch n
        case 0
            f = (x <= -14*d).*(4*d*(7*d + x)) + (x > -14*d & x <= -12*d).*(3.5*d*(6*d + x)) + (x > -12*d & x <= -10*d).*(3*d*(5*d + x)) + ...
                (x > -10*d & x <= -8*d).*(2.5*d*(4*d + x)) + (x > -8*d & x <= -6*d).*(2*d*(3*d + x)) + (x > -6*d & x <= -4*d).*(1.5*d*(2*d + x)) + ...
                (x > -4*d & x <= -2*d).*(d*(d + x)) + (x > -2*d & x <= 2*d).*(0.5*d*x) + (x > 2*d & x <= 4*d).*(-d*(d - x)) + ...
                (x > 4*d & x <= 6*d).*(-1.5*d*(2*d - x)) + (x > 6*d & x <= 8*d).*(-2*d*(3*d - x)) + (x > 8*d & x <= 10*d).*(-2.5*d*(4*d - x)) + ...
                (x > 10*d & x <= 12*d).*(-3*d*(5*d - x)) + (x > 12*d & x <= 14*d).*(-3.5*d*(6*d - x)) + (x > 14*d).*(-4*d*(7*d - x));
            
        case 1
            f = (x <= -14*d).*(2*d*(11*d + x)) + (x > -14*d & x <= -12*d).*(1.5*d*(10*d + x)) + (x > -12*d & x <= -10*d).*(d*(9*d + x)) + ...
                (x > -10*d & x <= -6*d).*(0.5*d*(8*d + x)) + (x > -6*d & x <= -4*d).*(d*(7*d + x)) + (x > -4*d & x <= -2*d).*(1.5*d*(6*d + x)) + ...
                (x > -2*d & x <= 0).*(2*d*(5*d + x)) + (x > 0 & x <= 2*d).*(2*d*(5*d - x)) + (x > 2*d & x <= 4*d).*(1.5*d*(6*d - x)) + ...
                (x > 4*d & x <= 6*d).*(d*(7*d - x)) + (x > 6*d & x <= 10*d).*(0.5*d*(8*d - x)) + (x > 10*d & x <= 12*d).*(d*(9*d - x)) + ...
                (x > 12*d & x <= 14*d).*(1.5*d*(10*d - x)) + (x > 14*d).*(2*d*(11*d - x));
            
        case 2
            f = (x <= -14*d).*(d*(13*d + x)) + (x > -14*d & x <= -10*d).*(0.5*d*(12*d + x)) + (x > -10*d & x <= -8*d).*(d*(11*d + x)) + ...
                (x > -8*d & x <= -6*d).*(-d*(5*d + x)) + (x > -6*d & x <= -2*d).*(-0.5*d*(4*d + x)) + (x > -2*d & x <= 0).*(-d*(3*d + x)) + ...
                (x > 0 & x <= 2*d).*(-d*(3*d - x)) + (x > 2*d & x <= 6*d).*(-0.5*d*(4*d - x)) + (x > 6*d & x <= 8*d).*(-d*(5*d - x)) + ...
                (x > 8*d & x <= 10*d).*(d*(11*d - x)) + (x > 10*d & x <= 14*d).*(0.5*d*(12*d - x)) + (x > 14*d).*(d*(13*d - x));
            
        case 3
            f = (x <= -12*d).*(0.5*d*(14*d + x)) + (x > -12*d & x <= -8*d).*(-0.5*d*(10*d + x)) + (x > -8*d & x <= -4*d).*(0.5*d*(6*d + x)) + ...
                (x > -4*d & x <= 0).*(-0.5*d*(2*d + x)) + (x > 0 & x <= 4*d).*(-0.5*d*(2*d -x)) + (x > 4*d & x <= 8*d).*(0.5*d*(6*d - x)) + ...
                (x > 8*d & x <= 12*d).*(-0.5*d*(10*d - x)) + (x > 12*d).*(0.5*d*(14*d - x));
    end
end

