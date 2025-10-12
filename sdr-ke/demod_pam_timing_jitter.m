function demod_pam_timing_jitter
% Abtast-Unsicherheit (timing jitter) bei der
% Berechnung des Abtastzeitpunkts bei PAM
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
M = 4;

% Symbol-Rausch-Abstand
Es_N0_dB = 5 : 30;

% Praeambel-Symbole
n_p = 31;
n   = 0 : n_p - 1;
s_p = exp( 1i * pi * n .* ( n + 1 ) / n_p );
% Datenbits
n_b = 336;
% Datensymbole
n_d = n_b / 2;
% absoluten Symbole
n_a = n_p + n_d + 1;
s_a = ones( 1, n_a );
% Alphabet fuer Datensymbole
s_m = [ 1 1i -1i -1 ];
% Root Raised Cosine Filter
l_g = 32;
g = root_raised_cosine_filter( l_g, M, r );
% Vorlauf- und Nachlauf
null = zeros( 1, 10 * M );
% Laenge des Signals
l_x_t = n_a * M + l_g - 1 + 2 * length(null); 
% Skalierungsfaktor fuer Rauschen
P_n_n = M * 10.^( -Es_N0_dB / 10 );
k_n   = sqrt( P_n_n / 2 );
l_n   = length(k_n);
% Skalierungsfaktor fuer Verschiebung
k_i = M / ( 2 * pi );

% Anzahl
sim_len = 10000;
% Abtastzeitpunkte
i_max_1 = zeros( sim_len, l_n );
i_max_2 = zeros( sim_len, l_n );
% Auswertebereich
idx = l_g + length(null) + ( 0 : M * n_a - 1 );

for i = 1 : sim_len

    % zufaellige Daten
    b = round( rand( 1, n_b ) );
    % Datensymbole bilden
    b_s = reshape( b, 2, [] );
    i_s = b_s( 1, : ) + 2 * b_s( 2, : );
    s_d   = s_m( i_s + 1 );
    % Praeambel- und Datensymbole verketten
    s = [ s_p s_d ];
    % absolute Symbole erzeugen
    for k = 1 : n_a - 1
        s_a(k+1) = s_a(k) * s(k);
    end
    % Signal erzeugen
    x = conv( kron( s_a, [ M zeros( 1, M - 1 ) ] ), g );
    % Signal verlaengern
    x_t = [ null x null ];
    
    for k = 1 : l_n
        % Rauschen addieren
        x_n = x_t + k_n(k) * ( randn(1,l_x_t) + 1i * randn(1,l_x_t) );
        % Root Raised Cosine Filter
        x_r = conv( x_n, g );
        % Betrag des Signals im Auswertebereich
        x_b = abs( x_r(idx) );
        % Vektoren zur Berechnung der Verschiebung
        v_1 = sum( reshape( x_b, 4, [] ).' );
        v_2 = sum( reshape( x_b.^2, 4, [] ).' );
        % Verschiebungen
        i_max_1( i, k ) = k_i * atan2( v_1(2) - v_1(4), v_1(1) - v_1(3) );
        i_max_2( i, k ) = k_i * atan2( v_2(2) - v_2(4), v_2(1) - v_2(3) );
    end
    
end

% Effektivwert der Abtast-Unsicherheit
tau_rms_1 = sqrt( sum( i_max_1.^2 ) / sim_len );
tau_rms_2 = sqrt( sum( i_max_2.^2 ) / sim_len );

figure(1);
plot(Es_N0_dB,tau_rms_1,'b-','Linewidth',1);
hold on;
plot(Es_N0_dB,tau_rms_2,'r-','Linewidth',1);
hold off;
grid;
axis([min(Es_N0_dB) max(Es_N0_dB) 0 0.12]);
xlabel('E_s / N_0 [dB]');
ylabel('RMS(tau)');
title('Timing Jitter bei einem PAM-Paket');
legend('Betrag','Betragsquadrat');
