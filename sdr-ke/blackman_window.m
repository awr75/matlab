function w = blackman_window(n)
% w = blackman_window(n)
%
% Blackman window of length n
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

k = 0 : n-1;
w = 0.42 - 0.5 * cos(2*pi*k/(n-1)) + 0.08 * cos(4*pi*k/(n-1));
