function demod_gfsk_signale
% Signale und Spektren im Demodulator bei GFSK
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
b_p = zeros( 1, M_p + 1 );
reg = ones( 1, m_p );
for i = 1 : M_p
    b_p(i) = reg(end);
    reg = mod( [ 0 reg(1:end-1) ] + reg(end) * p_p, 2 );
end

% zufaellige Datenbits
b_d = round( rand( 1, 336 ) );

% Symbole: Praeambel + Daten
sym = 2 * [ b_p b_d ] - 1;

% Sendesignal erzeugen
g = gauss_filter( BT, M, 21 );
s = conv( kron( sym, [ M zeros( 1, M-1 ) ] ), g );
x = exp( 1i * pi * f_shift / f_a * cumsum( s ) );

% Spektrum des Signals vor der Kanalfilterung
[S_x,f] = power_spectrum_density( x, M );

% Kanalfilter
h_ch = lowpass_filter( B_ch / f_a );
x_r  = conv( x, h_ch );

% Spektrum des Signals nach der Kanalfilterung
S_x_r = power_spectrum_density( x_r, M );

% FM-Demodulation
dx_r = x_r( 2 : end ) .* conj( x_r( 1 : end-1 ) );
s_r = M / ( pi * h ) * angle( dx_r );

% T-Integrator
h_i = ones( 1, M ) / M;
s_i = conv( s_r, h_i );

% Ein- und Ausschwingvorgang abschneiden
d_c = ( length(h_ch) - 1 ) / 2;
d_i = floor( length(h_i) / 2 );
s_r = s_r( 2 + d_c : end - d_c - 2 );
s_i = s_i( 2 + d_c + d_i : end - d_c - d_i - 2 );
s   = s( length(s) - length(s_i) - 2 : end - 2 );

% normierte Zeitachse
t = ( 0 : length(s) - 1 ) / M;

figure(1);
plot(t,s,'b-');
hold on;
plot(t,s,'bs','Linewidth',2,'Markersize',2);
hold off;
grid;
axis([ 0 30 -1.2 1.2 ]);
set(gca,'XTick',0:30);
xlabel('t / T_s');
title('FM-Modulationssignal im Sender');

figure(2);
plot(t,s_r,'b-');
hold on;
plot(t,s_r,'bs','Linewidth',2,'Markersize',2);
hold off;
grid;
axis([ 0 30 -1.2 1.2 ]);
set(gca,'XTick',0:30);
xlabel('t / T_s');
title('FM-demoduliertes Signal im Empfaenger');

figure(3);
plot(t(2:end),s_i,'b-');
hold on;
plot(t(2:end),s_i,'bs','Linewidth',2,'Markersize',2);
hold off;
grid;
axis([ 0 30 -1.2 1.2 ]);
set(gca,'XTick',0:30);
xlabel('t / T_s');
title('Gemitteltes Signal im Empfaenger');

figure(4);
plot(f,S_x,'b-','Linewidth',1);
grid;
axis([ -M/2 M/2 -100 0 ]);
xlabel('f / f_s');
title('Spektrum des Signals vor der Kanalfilterung');

figure(5);
plot(f,S_x_r,'b-','Linewidth',1);
grid;
axis([ -M/2 M/2 -100 0 ]);
xlabel('f / f_s');
title('Spektrum des Signals nach der Kanalfilterung');
