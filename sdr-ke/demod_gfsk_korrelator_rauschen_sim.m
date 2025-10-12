function demod_gfsk_korrelator_rauschen_sim
% Simulation der Verteilungsdichte des Korrelatorsignals
% der GFSK-Praeambeldetektion bei Rauschen am Eingang
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Signalparameter:
% Modulationsindex
h = 1;
% Ueberabtastfaktor
M = 8;

% Praeambel
p_p = [ 1 0 1 0 0 ];
m_p = length(p_p);
M_p = 2^m_p - 1;
n_p = M_p + 1;
b_p = zeros( 1, n_p );
reg = ones( 1, m_p );
for i = 1 : M_p
    b_p(i) = reg(end);
    reg = mod( [ 0 reg(1:end-1) ] + reg(end) * p_p, 2 );
end
% Kanalfilter
h_ch = lowpass_filter( ( 1 + h ) / M );
l_ch = length(h_ch);
% Mittelungsfilter
h_i = ones( 1, M ) / M;
% Matched Filter
h_m = fliplr( kron( 2 * b_p - 1, [ 1 zeros( 1, M - 1 ) ] ) );
h_m = h_m( M : end );
l_m = length(h_m);
% Filter fuer Mittelwert und Energie
h_s = abs( h_m );

% Rauschsignal
x = randn( 1, 1e7 ) + 1i * randn( 1, 1e7 );
% Kanalfilterung
x = conv( x, h_ch );
x = x( l_ch : end - l_ch + 1 );
% FM-Demodulation
dx = x( 2 : end ) .* conj( x( 1 : end-1 ) );
s_r = M / ( pi * h ) * angle( dx );
% Mittelung
s_i = conv( s_r, h_i );
s_i = s_i( M : end - M + 1 );
% Korrelation
c_m   = conv( s_i, h_m );
c_s   = conv( s_i, h_s );
c_e   = conv( s_i.^2, h_s );
c_m_e = 2 * c_m - c_e + c_s.^2 / n_p;
% Signale abschneiden
c_m   = c_m( l_m : end - l_m + 1 );
c_m_e = c_m_e( l_m : end - l_m + 1 );

% Varianzen am Ausgang des Korrelators
var   = c_m * c_m.' / length(c_m);
x_m_g = -30 : 0.5 : 30;
y_m_g = 1 / sqrt( 2 * pi * var ) * exp( -x_m_g.^2 / ( 2 * var ) );
fprintf( 1, 'Sigma(c_m) = %g\n', sqrt( var ) );
m_m_e   = mean( c_m_e );
d_m_e   = c_m_e - m_m_e;
var_e   = d_m_e * d_m_e.' / length(d_m_e);
x_m_e_g = -80 : 30; 
y_m_e_g = 1 / sqrt( 2 * pi * var_e ) * ...
          exp( - ( x_m_e_g - m_m_e ).^2 / ( 2 * var_e ) );
fprintf( 1, 'Mean(c_m_e) = %g\n', m_m_e );
fprintf( 1, 'Sigma(c_m_e) = %g\n', sqrt( var_e ) );

% Berechnung der AKF
l_akf = 40;
R_akf = zeros( 1, l_akf + 1 );
for i = 0 : l_akf
    R_akf( i + 1 ) = c_m( 1 : 1e5 ) * c_m( 1 + i : 1e5 + i ).';
end
R_akf = [ fliplr( R_akf( 2 : end ) ) R_akf ] / 1e5;
x_akf = -l_akf : l_akf;

figure(1);
histogramm( s_r, 1e-3, 1 );
xlabel('s_r');
ylabel('PDF(s_r)');
title('Verteilungsdichte des FM-demodulierten Signals');

figure(2);
histogramm( s_i, 1e-4, 1 );
xlabel('s_i');
ylabel('PDF(s_i)');
title('Verteilungsdichte des gemittelten Signals');

figure(3);
[ x_m, y_m ] = histogramm( c_m, 1e-4, 0.1 );
hold on;
plot(x_m_g,y_m_g,'r-');
hold off;
xlabel('c_m');
ylabel('PDF(c_m)');
title('Verteilungsdichte des Korrelationssignals');

figure(4);
[ x_m_e, y_m_e ] = histogramm( c_m_e, 1e-4, 0.1 );
hold on;
semilogy(x_m,y_m,'k-','Linewidth',2);
plot(x_m_e_g,y_m_e_g,'k--');
hold off;
axis([-80 20 1e-4 0.1]);
xlabel('c_m_,_e_x_t');
ylabel('PDF(c_m_,_e)');
title('Verteilungsdichte des erweiterten Korrelationssignals');

save('demod_gfsk_korrelator_rauschen.mat',...
     'x_m','y_m','x_m_e','y_m_e','x_akf','R_akf',...
     'x_m_g','y_m_g','x_m_e_g','y_m_e_g');

% Histogramm
function [ x, y ] = histogramm(s,y_min,y_max)
s_max = ceil( max( abs( s ) ) );
bin = 0.1;
[ y, x ] = hist( s , -s_max : bin : s_max );
y = y / ( bin * length(s) );
semilogy(x,y+1e-12,'k-','Linewidth',2);
grid;
axis([-s_max s_max y_min y_max]);
