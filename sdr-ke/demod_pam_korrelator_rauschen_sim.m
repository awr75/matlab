function demod_pam_korrelator_rauschen_sim
% Simulation der Verteilungsdichte der normierten Korrelation
% der PAM-Praeambeldetektion bei Rauschen am Eingang
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Signalparameter:
% Rolloff-Faktor
r = 0.33;
% Ueberabtastfaktor
M = 8;

% Praeambel-Symbole
n_p = 31;
n   = 0 : n_p - 1;
s_p = exp( 1i * pi * n .* ( n + 1 ) / n_p );
% Root Raised Cosine Filter
l_g = 32;
g = root_raised_cosine_filter( l_g, M, r );
% Matched Filter
h_m = fliplr( conj( kron( s_p, [ 1 zeros( 1, M - 1 ) ] ) ) );
h_m = h_m( M : end );
% Ueberlappung in Symbolen
D = 4;
% Mittelungsfilter
N_r = ( n_p + 2 * D + 1 ) * M;
h_r = ones( 1, N_r ) / N_r;

% Rauschsignal
x = randn( 1, 1e7 ) + 1i * randn( 1, 1e7 );
% Filterung
x = conv( x, g );
x = x( l_g : end - l_g + 1 );
% Differenzsignal
x_d = x .* conj( [ zeros( 1, M ) x( 1 : end - M ) ] );
% Korrelator
c_m = filter( h_m, 1, x_d );
% Leistung berechnen
p_r = filter( h_r, 1, abs(x).^2 );
% verzoegerte Korrelation
c_m = [ zeros( 1, M * D ) c_m( 1 : end - M * D ) ];
% normierte Korrelation
c_m_n = abs( c_m ) ./ p_r;
c_m_n = c_m_n( N_r + M * D : end );

figure(1);
[ x_m, y_m ] = histogramm( c_m_n, 0.99e-5, 0.2 );
xlabel('c_m_n');
ylabel('PDF(c_m_n)');
title('Verteilungsdichte der normierten Korrelation');

save('demod_pam_korrelator_rauschen.mat','x_m','y_m');

% Histogramm
function [ x, y ] = histogramm(s,y_min,y_max)
s_max = ceil( max( abs( s ) ) );
bin = 0.1;
[ y, x ] = hist( s , 0 : bin : s_max );
y = y / ( bin * length(s) );
semilogy(x,y+1e-12,'k-','Linewidth',2);
grid;
axis([0 s_max y_min y_max]);
