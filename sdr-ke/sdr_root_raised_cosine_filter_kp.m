function sdr_root_raised_cosine_filter_kp
% Verhaeltnis der Nutzleistungen am Eingang und am
% Ausgang eines Root Raised Cosine Filters im Empfaenger
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

M   = 8;
N   = 256;
r   = 0.1:0.01:1;
l_r = length(r);
k_p = zeros( 1, l_r );
for i = 1 : l_r
    g = root_raised_cosine_filter( N, M, r(i) );
    h = conv( g, g );
    k_p(i) = M * h * h';
end

figure(1);
plot(r,k_p,'b-');
grid;
xlabel('Rolloff-Faktor r');
ylabel('k_P');
title('Verhaeltnis k_P der Nutzleistungen');
