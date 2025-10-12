function daten_beispiel_rauschzahl
% Berechnung der Rauschzahl eines Empfaengers
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

% Komponente 1: Low Noise Amplifier (LNA)
part(1).g_db = 14;
part(1).f_db = 1;
part(1).ip3_dbm = 36;

% Komponente 2: Schaltbares Daempfungsglied
part(2).g_db = -2;
part(2).f_db = 2;
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

% Berechnung der Kettenrauschzahl:

% lineare Rauschzahl der Signalquelle
f = 1;
% Anfangswert fuer die lineare Leistungsverstaerkung
g_zi = 1;

% Schleife fuer die Komponenten
fprintf( 1, ['SigSource:' repmat(' ',1,45) 'F = %4.2f\n'], f );
for i = 1 : length(part)
    
    % linearer Anteil der Komponente zur Rauschzahl
    f_i  = 10^( part(i).f_db / 10 );
    f_zi = ( f_i - 1 ) / g_zi;
    
    % summierte Anteile zur Rauschzahl
    f = f + f_zi;
    
    % Ausgabe der laufenden Parameter
    fprintf( 1, 'Part = %2d:', i );
    fprintf( 1, ' F_i = %7.2f , G_zi = %4.0f', f_i, g_zi );
    fprintf( 1, ' , F_zi = %4.2f , F = %.2f\n', f_zi, f );
    
    % Produkt der Leistungsverstaerkungen
    g_zi = g_zi * 10^( part(i).g_db / 10 );

end

% Ausgabe der Kettenrauschzahl
f_db = 10 * log10( f );
fprintf( 1, 'F = %.2f = %.2f dB\n', f, f_db );
