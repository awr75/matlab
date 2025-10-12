function sdr_kanal_symbole_verteilung
% Verteilung der Symbole bei QPSK mit einem Symbol-Rausch-Abstand von 10 dB
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% QPSK-Alphabet
s_m = sqrt(0.5) * [ 1+1i -1+1i 1-1i -1-1i ];
l_m = length( s_m );

% Symbol-Rausch-Abstand
SNR = 10;

% Symbolleistung
P_s = real( s_m * s_m' ) / l_m;

% Rauschleistung
P_n = P_s / SNR;

% Verteilung der Symbole
x   = -2 : 0.05 : 2;
y   = -2 : 0.05 : 2;
l_x = length( x );
l_y = length( y );
n   = repmat( x, l_y, 1 ) + 1i * repmat( fliplr( y ).', 1, l_x );
p   = zeros( l_y, l_x );
for i = 1 : l_m
    p = p + exp( - abs( n - s_m(i) ).^2 / P_n ) / P_n;
end
p = p / ( pi * l_m );

figure(1);
colormap([0 0 1;0 0 1]);
mesh(x,y,p);
set(gca,'PlotBoxAspectRatio',[1 1 0.5]);
set(gca,'CameraPosition',[-10 -20 3]);
title('Verteilung von QPSK-Symbolen fuer SNR = 10 dB');
