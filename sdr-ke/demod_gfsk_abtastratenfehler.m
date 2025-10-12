function demod_gfsk_abtastratenfehler
% Symbolabtastung eines GFSK-Signals mit einem
% relativen Fehler von 1 Prozent
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Signalparameter:
% BT-Produkt
BT = 1;
% Ueberabtastfaktor
M = 100;

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

% Symbole
sym = 2 * b_p - 1;
% Modulationssignal im Sender
g = gauss_filter( BT, M, 161 );
s = conv( kron( sym, [ M zeros( 1, M-1 ) ] ), g );
% Modulationssignal im Empfaenger
h_i = [ 0.5 ones( 1, M-1 ) 0.5 ] / M;
s_i = conv( s, h_i );
% Verzoegerung
d   = ( length(g) + length(h_i) ) / 2 - 1;
t_i = ( ( 0 : length(s_i) - 1 ) - d ) / M - 6;
% Abtastung mit Verschiebung
n_r = 6 * M + d + ( 0 : 20 ) * ( M - 1);
t_r = ( 0 : 20 ) * ( M - 1 ) / M;

figure(1);
plot(t_i,s_i,'b-');
hold on;
plot(t_r,s_i(n_r),'bs','Linewidth',3,'Markersize',3);
hold off;
set(gca,'XTick',0:20);
grid;
axis([-0.5 20.5 -1.5 1.5]);
xlabel('t / T_s');
ylabel('s_i');
title('Symbolabtastung bei einem Abtastratenfehler');
