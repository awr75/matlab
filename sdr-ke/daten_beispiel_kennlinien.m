function daten_beispiel_kennlinien
% Berechnung der Rauschzahl und Eingangs-Interceptpunkts
% eines Empfaengers in Abhaengigkeit von der Verstaerkung
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Komponente 1: Low Noise Amplifier (LNA)
part(1).g_db = 14;
part(1).f_db = 1;
part(1).ip3_dbm = 36;

% Komponente 2: Schaltbares Daempfungsglied
part(2).g_db = -2 : -1 : -33;
part(2).f_db = - part(2).g_db;
part(2).ip3_dbm = 46;

% Komponente 3: HF-SAW-Filter 900 MHz
part(3).g_db = -2;
part(3).f_db = 2;
part(3).ip3_dbm = 100;

% Komponente 4: HF-Verstaerker
part(4).g_db = 14;
part(4).f_db = 3;
part(4).ip3_dbm = 44;

% Komponente 5: Regelbares Daempfungsglied
part(5).g_db = -4;
part(5).f_db = 4;
part(5).ip3_dbm = 43;

% Komponente 6: Mischer 900 MHz -> 280 MHz
part(6).g_db = -8;
part(6).f_db = 8;
part(6).ip3_dbm = 24;

% Komponente 7: ZF-Verstaerker 1
part(7).g_db = 15;
part(7).f_db = 3;
part(7).ip3_dbm = 43;

% Komponente 8: ZF-SAW-Filter 1
part(8).g_db = -12;
part(8).f_db = 12;
part(8).ip3_dbm = 100;

% Komponente 9: ZF-Verstaerker 2
part(9).g_db = 15;
part(9).f_db = 3;
part(9).ip3_dbm = 43;

% Komponente 10: ZF-SAW-Filter 2
part(10).g_db = -12;
part(10).f_db = 12;
part(10).ip3_dbm = 100;

% Komponente 11: Mischer 280 MHz -> 26 MHz
part(11).g_db = -6;
part(11).f_db = 6;
part(11).ip3_dbm = 21;

% Komponente 12: Tiefpass-Filter 1 (80 MHz)
part(12).g_db = -1;
part(12).f_db = 1;
part(12).ip3_dbm = 100;

% Komponente 13: Treiber-Verstaerker fuer A/D-Umsetzer
part(13).g_db = 27;
part(13).f_db = 8;
part(13).ip3_dbm = 46;

% Komponente 14: Tiefpass-Filter 2 (80 MHz)
part(14).g_db = -1;
part(14).f_db = 1;
part(14).ip3_dbm = 100;

% Komponente 15: A/D-Umsetzer
part(15).g_db = 0;
part(15).f_db = 33;
part(15).ip3_dbm = 100;

% Berechnung:
% Anzahl
len = length( part(2).g_db );
% lineare Rauschzahl der Signalquelle
f = ones( 1, len );
% Anfangswert fuer die lineare Leistungsverstaerkung
g = ones( 1, len );
% Summen initialisieren
s = zeros( 1, len );
% Schleife fuer die Komponenten
for i = 1 : length(part)
    if i == 2
        % linearer Anteil der Komponente zur Rauschzahl
        f_i = ( 10.^( part(i).f_db / 10 ) - 1 ) ./ g;
        % Produkt der Leistungsverstaerkungen
        g = g .* 10.^( part(i).g_db / 10 );
    else
        % linearer Anteil der Komponente zur Rauschzahl
        f_i = ( 10^( part(i).f_db / 10 ) - 1 ) * ones( 1, len ) ./ g;
        % Produkt der Leistungsverstaerkungen
        g = g * 10.^( part(i).g_db / 10 );
    end
    % summierte Anteile zur Rauschzahl
    f = f + f_i;
    % nichtlineare Komponente ?
    if part(i).ip3_dbm < 100
        % Amplitude zum IP3 der Komponente
        ip3 = 10^( ( part(i).ip3_dbm - 10 ) / 20 );
        % laufende Summe
        s = s + g / ip3^2;
    end
end

% Verstaerkung in dB
g_db = 10 * log10( g );
% Rauschzahl in dB
f_db = 10 * log10( f );
% Eingangs-Interceptpunkt
iip3_dbm = 10 - 10 * log10( s );

% Inband-Dynamikbereich fuer eine Rauschbandbreite von 200 kHz
b_n_hz = 2e5;
idr_db = 2 / 3 * ( 174 + iip3_dbm - f_db - 10 * log10( b_n_hz ) );

figure(1);
plot(g_db,f_db,'b-','Linewidth',1);
hold on;
plot(g_db,iip3_dbm,'r-','Linewidth',1);
hold off;
grid;
axis([6 37 0 32]);
xlabel('G [dB]');
ylabel('F [dB] / IIP3 [dBm]');
title('Rauschzahl F und Eingangs-Interceptpunkt IIP3');
legend('F','IIP3');

figure(2);
plot(g_db,idr_db,'b-','Linewidth',1);
grid;
axis([6 37 70 85]);
xlabel('G [dB]');
ylabel('IDR [dB]');
title('Inband-Dynamikbereich');
