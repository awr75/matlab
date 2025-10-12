function w = kaiser_window(n,beta)
% w = kaiser_window(n,beta)
%
% Kaiser window of length n with parameter beta
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

n = floor(n);
if n < 4
    error('n >= 4 is required');
end
beta = abs(beta);

norm = 1 / bessel_i0(beta);
x = (1:n) - (n+1)/2;
a = beta * sqrt( 1 - (2*x/n).^2 );
w = zeros(1,n);
for i = 1 : n
    w(i) = norm * bessel_i0(a(i));
end
