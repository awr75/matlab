function daten_beispiel_iip3
% Berechnung des Eingangs-Interceptpunkts 3.Ordnung eines Empfaengers
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

% Berechnung des Eingangs-Interceptpunkts:

% Summe initialisieren
s = 0;
% Anfangswert fuer die lineare Verstaerkung
a_si = 1;

% Schleife fuer die Komponenten
for i = 1 : length(part)
    
    % Produkt der Verstaerkungen
    a_si = a_si * 10^( part(i).g_db / 20 );
    
    % nichtlineare Komponente ?
    if part(i).ip3_dbm < 100
        
        % IP3 der Komponente
        ip3_i = 10^( ( part(i).ip3_dbm - 10 ) / 20 );
        % IIP3 der Komponente
        iip3_i = ip3_i / a_si;
        % laufende Summe
        s = s + 1 / iip3_i^2;
        % laufender IIP3
        iip3 = 1 / sqrt( s );
        
    end
    
    % Ausgabe der laufenden Parameter
    fprintf( 1, 'Part = %2d: ', i );
    if s == 0
        fprintf( 1, 'A_si = %4.1f\n', a_si );
    else
        fprintf( 1, 'A_si = %4.1f , ', a_si );
        if part(i).ip3_dbm < 100
            fprintf( 1, 'IP3_i = %4.1f , ', ip3_i );
            fprintf( 1, 'IIP3_i = %5.2f , ', iip3_i );
            fprintf( 1, 'IIP3 = %4.2f\n', iip3 );
        else
            fprintf( 1, repmat( ' ', 1, 32 ) );
            fprintf( 1, 'IIP3 = %4.2f\n', iip3 );
        end
    end
    
end

% Ausgabe des Eingangs-Interceptpunkts IIP3
if s > 0
    fprintf( 1, 'IIP3 = %4.2f (Amplitude)\n', iip3 );
    fprintf( 1, 'IIP3 = %3.1f dBm \n', 10 + 20 * log10( iip3 ) );
end
