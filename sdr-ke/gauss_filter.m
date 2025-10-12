function b=gauss_filter(bt,over,len)
% b = gauss_filter(bt,over,len)
%
% Calculate Gauss filter
%
%     bt   - B*T product
%     over - oversampling factor
%     len  - length of the filter in samples (not symbols !)
%     norm - normalize coefficients, if norm=1 (default)
%     b    - impulse response of S&H + Gaussian filter
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

if nargin < 3
    len=2*over;
else
    if mod(len,2) == 0
        len=len/2;
    else
        len=(len-1)/2;
    end
end
alpha=sqrt(2/log(2))*pi*bt;
t=(-len:len)/over;
b=0.5*(erf(alpha*(t+0.5))-erf(alpha*(t-0.5)))/over;
