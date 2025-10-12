function demod_gfsk_korrelation
% Praeambel-Korrelation bei GFSK
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Signalparameter:
% Symbolrate
f_s = 1;
% Modulationsindex
h = 1;
% BT-Produkt
BT = 1;
% Ueberabtastfaktor
M = 8;
% Signal-Rausch-Abstand des Basisbandsignals
% innerhalb der Kanalbandbreite
SNR_x_db = 40;
% Frequenzoffset
f_off = 0;

% abhaengige Parameter:
% Shift
f_shift = h * f_s;
% Abtastrate
f_a = M * f_s;
% Kanalbandbreite
B_ch = f_s + f_shift;

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
% Datensymbole
l_d = 336;
% Kanalfilter
h_ch = lowpass_filter( B_ch / f_a );
l_ch = length(h_ch);
% Gauss-Filter
l_g = 21;
g = gauss_filter( BT, M, l_g );
% Rampe fuer Signal
rmp = [ zeros( 1, 201 * M + 4 ), sqrt( ( 1 : 5 * M ) / ( 5 * M ) ) ];
% Laenge des Signals
l_x_t = ( n_p + l_d ) * M + l_g - 1 + 2 * length(rmp); 
% Drehvektor fuer Mischer
mix = exp( 2i * pi * f_off / f_a * ( 1 : l_x_t ) );
% Skalierungsfaktor fuer Rauschen
P_n_n = f_a / ( B_ch * 10^( SNR_x_db / 10 ) );
k_n   = sqrt( P_n_n / 2 );
% Mittelungsfilter
h_i = ones( 1, M ) / M;
l_i = length(h_i);
% Matched Filter
h_m = fliplr( kron( 2 * b_p - 1, [ 1 zeros( 1, M - 1 ) ] ) );
h_m = h_m( M : end );
l_m = length(h_m);
% Summationsfilter
h_s = abs( h_m );

% Symbole: Praeambel + zufaellige Daten
sym = 2 * [ b_p round( rand( 1, l_d ) ) ] - 1;
% Signal erzeugen
s = conv( kron( sym, [ M zeros( 1, M - 1 ) ] ), g );
x = exp( 1i * pi * h / M * cumsum( s ) );
% Signal mit Rampe versehen und verlaengern
x_t = [ rmp * x(1), x, x(end) * fliplr(rmp) ];
% Mischen und Rauschen addieren
x_n = x_t .* mix + k_n * ( randn(1,l_x_t) + 1i * randn(1,l_x_t) );
% Kanalfilter
x_r = conv( x_n, h_ch );
x_r = x_r( l_ch : end - l_ch + 1 );
% FM-Demodulation
dx_r = x_r( 2 : end ) .* conj( x_r( 1 : end-1 ) );
s_r  = M / ( pi * h ) * angle( dx_r );
% Mittelungsfilterung
s_i = conv( s_r, h_i );
% Korrelator
c_m = conv( s_i, h_m );
% euklidische Norm
c_s   = conv( s_i, h_s );
c_e   = conv( s_i.^2, h_s );
c_m_e = 2 * c_m - c_e + c_s.^2 / n_p;
% Ueberhang abschneiden
c_m   = c_m( l_m + l_i : end - l_m + 1 );
c_s   = c_s( l_m + l_i : end - l_m + 1 );
c_m_e = c_m_e( l_m + l_i : end - l_m + 1 );
% Maximum suchen
[ m, idx ] = max( c_m_e );
offset = c_s( idx ) / n_p;

% Zeitachsen
n_i = ( 0 : length(s_i) - 1 ) / M;
n_m = n_i( l_m + l_i : end );

figure(1);
plot(n_i,s_i,'b-');
grid;
axis([0 max(n_i) -3 3]);
xlabel('t / T_s');
title('Ausgangssignal des LDI-Demodulators');

figure(2);
plot(n_m,c_m,'b-');
grid;
axis([0 max(n_i) -20 30]);
xlabel('t / T_s');
title('Ausgangssignal des Korrelators');

figure(3);
plot(n_m,c_m,'b-','Linewidth',1);
grid;
axis([200 262 -20 30]);
xlabel('t / T_s');
title('Ausgangssignal des Korrelators (Ausschnitt)');

figure(4);
plot(n_m,c_m,'b-');
hold on;
plot(n_m,c_m,'bs','Linewidth',3,'Markersize',2);
hold off;
grid;
axis([229 233 -5 30]);
xlabel('t / T_s');
title('Ausgangssignal des Korrelators (Verlauf der Spitze)');

figure(5);
s1=s_i(1+M*(200+(0:31)));
s2=2*b_p-1;
plot(n_i-200,s_i,'b-');
hold on;
plot(0:31,s1,'ro','Linewidth',2,'Markersize',2);
plot(0:31,s2,'ro','Linewidth',2,'Markersize',2);
for i=1:32
    plot((i-1)*[1 1],[s1(i) s2(i)],'r-','Linewidth',2);
end
hold off;
grid;
axis([-1 32 -1.5 1.5]);
xlabel('t / T_s');
title('Abstaende');

figure(6);
plot(n_i-200,s_i-offset,'b-','Linewidth',1);
hold on;
plot(n_i(1:8:end)-200,s_i(1:8:end)-offset,'bs','Linewidth',3,'Markersize',2);
hold off;
grid;
axis([-0.5 47.5 -1.25 1.25]);
xlabel('t / T_s');
title('Ausgangssignal des LDI-Demodulators');

figure(7);
plot(n_m-200,c_m_e,'b-','Linewidth',1);
grid;
axis([-0.5 47.5 -50 35]);
xlabel('t / T_s');
title('Ausgangssignal des Detektors mit euklidischer Norm');
