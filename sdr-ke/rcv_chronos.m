function rcv_chronos
% Demodulator fuer TI Chronos
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Empfangsfrequenz
f_0 = 867.977e6;

% Symbolrate
f_s = 3198.6;
% Shift
f_shift = 2 * 1586.9;
% Modulationsindex
h = f_shift / f_s;

% Ueberabtastung
M = 8;
% Abtastrate
f_a = M * f_s;

% Kanalfilter berechnen und initialisieren
h_ch = lowpass_filter( ( 1 + h ) / M );
[ x_r, z_ch ] = filter( h_ch, 1, 0 );

% FM-Demodulator:
% Konstane fuer Skalierung
c_fm = M / ( pi * h );
% Zustand
z_r = 0;

% Mittelungsfilter bilden und initialisieren
h_i = ones( 1, M ) / M;
[ x_i, z_i ] = filter( h_i, 1, 0 );

% Korrelator und Detektor:
% Praeambelsymbole
s_p = repmat( [ 1 1 -1 1 -1 -1 1 1 1 -1 -1 1 -1 -1 -1 1 ], 1, 2 );
n_p = length(s_p);
% Matched Filter fuer Korrelator
h_m = fliplr( kron( s_p, [ 1 zeros( 1, M - 1 ) ] ) );
h_m = h_m( M : end );
h_s = abs( h_m );
[ c_m, z_m ] = filter( h_m, 1, 0 );
[ c_s, z_s ] = filter( h_s, 1, 0 );
[ c_e, z_e ] = filter( h_s, 1, 0 );
% Vorlauf zur Speicherung des Signals der Praeambel
% (der Detektionszeitpunkt entspricht dem letzten Symbol der Praeambel)
l_v = length(h_m);
s_v = zeros( 1, l_v );
% Laenge der Daten
l_d = 8 * 64;
% Paketlaenge in Abtastwerten
l_pkt = M * ( length(s_p) + l_d );
% Position im Paket (0 = kein Paket detektiert)
p_pkt = 0;
% Paketsignal
s_pkt = zeros( 1, l_pkt );
% Detektionsschwelle
c_m_det = 15;
c_det   = c_m_det;
% relativer Frequenzoffset
f_off_rel = 0;

% CRC:
% ANSI-16 = 0xC002 = 1100 0000 0000 0010 (Darstellung nach Koopman)
% - OHNE die fuehrende Eins und MIT nachfolgender Eins
crc   = [ 1 0 0  0 0 0 0  0 0 0 0  0 0 1 0  1 ];
l_crc = length(crc);

% Bloecke pro Sekunde
bps = 20;
% Konstante fuer AGC (2 Sekunden)
c_agc = 1 / ( 2 * bps );

% Anzeige initialisieren:
% Laenge der FFT
n_fft = 256;
% Laenge des Spektrogramms (10 sec)
l_spec = 10 * bps;
% Spektrum
[ S_x, f ] = power_spectrum_density( [], f_a, n_fft );
% Spektrogramm
S_w = -60 * ones( l_spec, n_fft );
t_w = ( 0 : l_spec - 1 ) / bps;
figure(1);
s = get( 0, 'Screensize' );
fig_pos = [ 0.2*s(3) 0.2*s(4) 0.6*s(3) 0.6*s(4) ];
set( gcf, 'Position', fig_pos );
% Plot 1: Spektrum
subplot(2,2,1);
h_S_x = plot( 1e-3 * f, S_x );
grid;
axis( [ 1e-3 * min(f) * [ 1 -1 ] -60 0 ] );
xlabel( 'f [kHz]' );
ylabel( 'S [dB]' );
title( sprintf( 'PSD: f_0 = %g MHz', 1e-6 * f_0 ) );
% Plot 2: Spektrogramm
subplot(2,2,2);
h_S_w = imagesc( 1e-3 * f, t_w, S_w, [ -60 0 ] );
grid;
axis( [ 1e-3 * min(f) * [ 1 -1 ] min(t_w) max(t_w) ] );
xlabel( 'f [kHz]' );
ylabel( 't [s]' );
title( sprintf( 'Spektrogramm: f_0 = %g MHz', 1e-6 * f_0 ) );
% Plot 3: Signale der detektierten Pakete
subplot(2,2,3:4);
h_s_pkt = plot( 1000 * ( 1 : l_pkt ) / f_a, zeros( 1, l_pkt ) );
grid;
axis( [ 0 1000 * l_pkt / f_a -3 3 ] );
xlabel( 't [ms]' );
ylabel( 's_i' );
h_s_nr = title( '---' );

% Empfaenger initialisieren
mexrtlsdr( 'open' );
l_max = mexrtlsdr( 'init', f_a, 0.8 * f_a, f_0, bps, 4, 1 );

% Audio-Ausgabe initialisieren
z_m_audio = 1;
f_m_audio = 3000;
f_a_audio = 24000;
mix_audio = exp( 2i * pi * f_m_audio * ( 0 : l_max ) / f_a );
M_audio   = f_a / f_a_audio;
[ x_audio, z_audio ] = mexipol( 0, M_audio );
mexaudioout( 'init', f_a_audio, bps, 4 );

run = 1;
agc = 1;
id_next = 0;
nr_paket = 0;
update_psd = 0;
while run == 1
  % Basisbandsignal einlesen
  [ x_sdr, id ] = mexrtlsdr( 'data', 0 );
  if isempty(x_sdr)
    % Spektrumanzeige aktualisieren ?
    if update_psd == 1
      % ja -> ruecksetzen
      update_psd = 0;
      % Spektrum und Spektrogramm aktualisieren:
      % Spektrum berechnen ...
      S_x = power_spectrum_density( x, f_a, n_fft);
      % ... und in Spektrogramm uebernehmen
      S_w = [ S_x ; S_w( 1 : l_spec - 1, : ) ];
      % Anzeige aktualisieren
      try
        set( h_S_x, 'YData', S_x );
        set( h_S_w, 'CData', S_w );
        set( gcf, 'Position', fig_pos );
        drawnow;
      catch
        run = 0;
      end
    else
      pause( 0.01 );
    end
  else
    % Sequenznummer pruefen
    if id > id_next
      fprintf( 1, '%d Paket(e) verloren\n', id - id_next );
    end
    id_next = id + 1;
    % AGC:
    % Signal skalieren
    x = agc * x_sdr;
    % Leistung ermitteln und pruefen
    P_x = real( x * x' ) / length(x);
    % Uebersteuerung ?
    if P_x > 10
      % ja -> Abschwaechung um 20 dB
      agc = 0.1 * agc;
    else
      % nein -> Signal zu schwach ?
      if P_x < 0.0001
        % ja -> Anhebung um 20 dB
        agc = 10 * agc;
      else
        % nein -> Regelung auf Sollwert 0.01
        agc = agc * ( 0.01 / P_x )^c_agc;
      end
    end
    % Spektrumanzeige kann aktualisiert werden
    update_psd = 1;
    % Kanalfilterung
    [ x_r, z_ch ] = filter( h_ch, 1, x, z_ch );
    l_r = length(x_r);
    % Audio-Ausgabe
    m = z_m_audio * mix_audio;
    x_audio = real( x_r .* m(1:l_r) );
    z_m_audio = m(l_r + 1);
    [ x_audio, z_audio ] = mexipol( x_audio, M_audio, z_audio );
    mexaudioout( 'data', x_audio );
    % FM-Demodulation
    s_r = c_fm * angle( x_r .* conj( [ z_r x_r(1:end-1) ] ) );
    z_r = x_r(end);
    % Mittelungsfilter
    [ s_i, z_i ] = filter( h_i, 1, s_r, z_i );
    % Korrelator
    [ c_m, z_m ] = filter( h_m, 1, s_i, z_m );
    [ c_s, z_s ] = filter( h_s, 1, s_i, z_s );
    [ c_e, z_e ] = filter( h_s, 1, s_i.^2, z_e );
    c_m_e = 2 * c_m - c_e + c_s.^2 / n_p;
    % Detektor
    for i = 1 : l_r
      % Schwelle ueberschritten ?
      if c_m_e(i) > c_det
        % ja -> Paketverarbeitung initialisieren:
        % Schwelle auf detektierten Wert anheben
        c_det = c_m_e(i);
        % relativen Frequenzoffset berechnen
        f_off_rel = c_s(i) * h / ( 2 * n_p );
        % Vorlauf und aktuelles Signal verketten
        s_i_v = [ s_v s_i ];
        % Signal der Praeambel in das Paketsignal uebernehmen
        s_pkt( 1 : l_v + 1 ) = s_i_v( i : i + l_v );
        % Zeiger auf Position im Paketsignal initialisieren
        p_pkt = l_v + 1;
      else
        % nein -> wird ein Paket verarbeitet ?
        if p_pkt > 0
          % ja -> Position im Paket erhoehen
          p_pkt = p_pkt + 1;
          % Signalwert in Paketsignal uebernehmen
          s_pkt(p_pkt) = s_i(i);
          % Ende des Pakets erreicht ?
          if p_pkt >=  l_pkt
            % ja -> Paketnummer erhoehen
            nr_paket = nr_paket + 1;
            % Symbole entnehmen
            sym = s_pkt( 2 : M : end ) - 2 * f_off_rel;
            % Datenbits entscheiden
            b_d = double( sym( 1 + n_p : end ) > 0 );
            l_d = length(b_d);
            % CRC pruefen
            % (Achtung: es handelt sich nicht um die normale Berechnung,
            %           da der TI Chip eine andere Berechnung verwendet !)
            reg = ones( 1, l_crc );
            for k = 1 : l_d
              fbk = mod( reg(1) + b_d(k), 2 ) * crc;
              reg = mod( [ reg(2:end) 0 ] + fbk, 2 );
            end
            crc_ok = ( sum(reg) == 0 );
            % Signal des Pakets anzeigen
            try
              set( h_s_pkt, 'YData', s_pkt );
              set( h_s_nr, 'String', sprintf( ...
                   'Paket %d , f_o_f_f/f_s = %.2f , CRC = %d', ...
                   nr_paket, f_off_rel, crc_ok ) );
            catch
              run = 0;
            end
            % Schwelle zuruecksetzen
            c_det = c_m_det;
            % Position im Paket ruecksetzen
            p_pkt = 0;
          end
        end
      end
    end
    % Vorlauf setzen
    s_v = s_i( end - l_v + 1 : end );
  end
end
mexrtlsdr( 'stop' );
mexrtlsdr( 'close' );
mexaudioout( 'stop' );
