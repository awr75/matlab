function w = flattop_window(n)
% w = flattop_window(n)
%
% Flat top window of length n
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
w = 1 - 1.93 * cos(2*pi*k/(n-1)) + 1.29 * cos(4*pi*k/(n-1)) ...
      - 0.388 * cos(6*pi*k/(n-1)) + 0.028 * cos(8*pi*k/(n-1));
w = w / 4.636;
