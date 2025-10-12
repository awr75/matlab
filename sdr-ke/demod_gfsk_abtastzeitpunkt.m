function demod_gfsk_abtastzeitpunkt
% Bestimmung des Abtastzeitpunkts eines GFSK-Signals
% durch Mittelung des Betrags ueber mehrere Symbole
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
M = 8;
% weitere Ueberabtastung ueber pseudo-kontinuierliche Signale
M_t = 8;

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

% Symbole
sym = 2 * b_p - 1;
% Modulationssignal im Sender
g = gauss_filter( BT, M_t * M, 20 * M_t + 1 );
s = conv( kron( sym, [ M_t * M  zeros( 1, M_t * M - 1 ) ] ), g );
% Modulationssignal im Empfaenger
h_i   = ones( 1, M_t * M ) / ( M_t * M );
s_i_t = conv( s, h_i );
% Ausschnitt
K     = 20;
s_i_t = s_i_t( 91 : 90 + K * M_t * M );
t_i   = ( 0 : length(s_i_t) - 1 ) / M_t;
% diskretes Signal
n_i = t_i( 1 : M_t : end);
s_i = s_i_t( 1 : M_t : end);
% Ueberlagerung
v_t = sum( reshape( abs(s_i_t), M_t * M, [] ).' );
t_v = t_i( 1 : M_t * M );
v   = v_t( 1 : M_t : end );
n_v = t_v( 1 : M_t : end );
% Maximum bestimmen
[ v_m, i_max ] = max( v );
% Abtastung der Symbole
s = s_i( i_max : M : end );
n = n_i( i_max : M : end );

% kontinuierlicher Abtastzeitpunkt
i_max = M / ( 2 * pi ) * ...
        angle( v * exp( j * 2 * pi * ( 0 : M - 1 ) / M ).' );
fprintf( 1, 'Abtastzeitpunkt: %4.2f\n', i_max );
% Verschiebung in ganzzahligen und fraktionalen Anteil aufteilen
i_max_int = floor( i_max );
i_max_mod = mod( i_max, 1 );
% Koeffizienten des Interpolators bereitstellen
h_i = interpolator_4( i_max_mod );
% Abtastung mit Interpolation:
% Vektor fuer Symbole
s_inter = zeros( 1, K );
% Position des ersten Symbols
pos = i_max_int;
for k = 1 : K
    % Symbol abtasten
    s_inter(k) = s_i( pos : pos + 3 ) * h_i.';
    % Position des naechsten Symbols
    pos = pos + M;
end
n_inter = i_max + M * ( 0 : K - 1 );

figure(1);
plot(t_i,s_i_t,'b-');
hold on;
plot(n_i,s_i,'bs','Linewidth',2,'Markersize',2);
hold off;
set(gca,'XTick',M*(0:K));
grid;
axis([0 K*M -1.1 1.1]);
xlabel('n = M * t / T_s');
ylabel('s_i');
title('Gemitteltes Signal');

figure(2);
plot(t_i,abs(s_i_t),'b-');
hold on;
plot(n_i,abs(s_i),'bs','Linewidth',2,'Markersize',2);
hold off;
set(gca,'XTick',M*(0:K));
grid;
axis([0 K*M 0 1.1]);
xlabel('n = M * t / T_s');
ylabel('|s_i|');
title('Betrag des gemittelten Signals');

figure(3);
plot(t_v,v_t,'b-','Linewidth',1);
hold on;
plot(n_v,v,'bs','Linewidth',3,'Markersize',3);
hold off;
grid;
axis([0 M 0 K]);
set(gca,'XTick',0:M-1);
xlabel('i = M * t / T_s');
ylabel('v');
title('Ueberlagerung des Betrags des gemittelten Signals');

figure(4);
plot([t_v-2*M t_v-M t_v t_v+M],repmat(v_t,1,4),'b-');
hold on;
plot([n_v-2*M n_v-M n_v n_v+M],repmat(v,1,4),'bs',...
     'Linewidth',3,'Markersize',3);
hold off;
grid;
axis([-2*M 2*M 0 K]);
xlabel('i = M * t / T_s');
ylabel('v_p');
title('Periodische Fortsetzung der Ueberlagerung des Betrags');

figure(5);
plot(t_i,s_i_t,'b-');
hold on;
plot(n,s,'bs','Linewidth',3,'Markersize',3);
hold off;
set(gca,'XTick',n);
grid;
axis([0 K*M -1.1 1.1]);
xlabel('k');
ylabel('s');
title('Abgetastete Symbole ohne Interpolation');

figure(6);
plot(t_i,s_i_t,'b-');
hold on;
plot(n_inter,s_inter,'bs','Linewidth',3,'Markersize',3);
hold off;
grid;
axis([0 K*M -1.1 1.1]);
xlabel('k');
ylabel('s');
title('Abgetastete Symbole mit Interpolator');
