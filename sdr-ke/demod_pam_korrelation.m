function demod_pam_korrelation
% Praeambel-Korrelation bei PAM
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
% Rolloff-Faktor
r = 0.33;
% Ueberabtastfaktor
M = 4;
% Symbol-Rausch-Abstand
Es_N0_dB = 100;
% Frequenzoffset
f_off = 0;

% abhaengige Parameter:
% Abtastrate
f_a = M * f_s;

% Praeambel-Symbole
n_p = 31;
n   = 0 : n_p - 1;
s_p = exp( 1i * pi * n .* ( n + 1 ) / n_p );
% Datenbits
n_b = 336;
% Datensymbole
n_d = n_b / 2;
% Anzahl der absoluten Symbole
n_a = n_p + n_d + 1;
% Alphabet fuer Datensymbole
s_m = [ 1 1i -1i -1 ];
% Root Raised Cosine Filter
l_g = 32;
g = root_raised_cosine_filter( l_g, M, r );
% Vorlauf- und Nachlauf
null = zeros( 1, 200 * M );
% Laenge des Signals
l_x_t = n_a * M + l_g - 1 + 2 * length(null); 
% Drehvektor fuer Mischer
mix = exp( 2i * pi * f_off / f_a * ( 1 : l_x_t ) );
% Skalierungsfaktor fuer Rauschen
P_n_n = M * 10^( -Es_N0_dB / 10 );
k_n   = sqrt( P_n_n / 2 );
% Matched Filter
h_m = fliplr( conj( kron( s_p, [ 1 zeros( 1, M - 1 ) ] ) ) );
h_m = h_m( M : end );
% Ueberlappung in Symbolen
D = 4;
% Mittelungsfilter
N_r = ( n_p + 2 * D + 1 ) * M;
h_r = ones( 1, N_r ) / N_r;

% zufaellige Daten
b = round( rand( 1, n_b ) );
% Datensymbole bilden
b_s = reshape( b, 2, [] );
i_s = b_s( 1, : ) + 2 * b_s( 2, : );
s_d   = s_m( i_s + 1 );
% Praeambel- und Datensymbole verketten
s = [ s_p s_d ];
% absolute Symbole erzeugen
s_a = ones( 1, n_a );
for i = 2 : n_a
    s_a(i) = s_a(i-1) * s(i-1);
end
% Signal erzeugen
x = conv( kron( s_a, [ M zeros( 1, M - 1 ) ] ), g );
% Signal verlaengern
x_t = [ null x null ];
% Mischen und Rauschen addieren
x_n = x_t .* mix + k_n * ( randn(1,l_x_t) + 1i * randn(1,l_x_t) );
% Root Raised Cosine Filter
x_r = conv( x_n, g );
x_r = x_r( l_g : end - l_g + 1 );
% Differenzsignal
x_d = x_r .* conj( [ zeros( 1, M ) x_r( 1 : end - M ) ] );
% Korrelator
c_m = filter( h_m, 1, x_d );
% Leistung berechnen
p_r = filter( h_r, 1, abs(x_r).^2 );
% verzoegerte Korrelation
c_m_d = [ zeros( 1, M * D ) c_m( 1 : end - M * D ) ];
% normierte Korrelation
c_m_n = abs( c_m_d ) ./ p_r;
% Ueberabtastung fuer hochaufloesende Darstellung
M_i = 8;
h_i = resampling_filter( M_i );
l_i = ( length(h_i) - 1 ) / 2;
c_m_i = conv( kron( c_m_d, [ M_i zeros( 1, M_i - 1 ) ] ), h_i );
c_m_i = c_m_i( 1 + l_i : end - l_i );
c_m_n_i = abs( c_m_i ) ./ kron( p_r, ones( 1, M_i ) );
% verschobene Abtastung (delta = 0.5 )
c_m_n_delta = c_m_n_i( 1 + M_i / 2 : M_i : end );

% Zeitachsen
n   = ( 0 : length(x_r) - 1 ) / M;
n_i = ( 0 : length(c_m_i) - 1 ) / ( M * M_i );

figure(1);
plot(n,abs(x_r),'b-');
grid;
axis([0 max(n) 0 3]);
xlabel('t / T_s');
title('Betrag des Basisbandsignals x_r');

figure(2);
plot(n,abs(c_m),'b-');
grid;
axis([0 max(n) 0 40]);
xlabel('t / T_s');
title('Betrag der Korrelation');

figure(3);
plot(n(N_r:end),p_r(N_r:end),'b-');
grid;
axis([0 max(n) 0 1.5]);
xlabel('t / T_s');
title('Leistung des relevanten Signalabschnitts');

figure(4);
plot(n(N_r:end),c_m_n(N_r:end),'b-');
grid;
axis([0 max(n) 0 50]);
xlabel('t / T_s');
title('Betrag der normierten Korrelation');

figure(5);
plot(n_i,abs(c_m_n_i),'b-');
hold on;
plot(n,abs(c_m_n),'bs','Linewidth',3,'Markersize',3);
plot(n+1/M_i,abs(c_m_n_delta),'bs','Linewidth',1,'Markersize',4);
hold off;
grid;
axis([233 237 0 50]);
xlabel('t / T_s');
title('Betrag der normierten Korrelation');
