function y=bessel_i0(x)
% y = bessel_i0(x)
%
% Bessel function I_0
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

t  = 1e-8;
y  = 1;
dy = 1;
for i = 1 : 25
    dy = 0.5 * x * dy / i;
    dy2 = dy * dy;
    y = y + dy2;
    if y * t - dy2 > 0
        break;
    end
end
