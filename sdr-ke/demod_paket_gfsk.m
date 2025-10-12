function demod_paket_gfsk
% Demodulator fuer GFSK-Paketsendungen
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

%---------------------------------
% Parameter der gesendeten Pakete
%---------------------------------

% Symbolrate
f_s = 3200;
% Modulationsindex
h = 1;
% BT-Produkt
BT = 1;
% Ueberabtastung
M = 8;
% Abtastrate
f_a = M * f_s;
% CRC-Polynom 0xBAAD = 1011 1010 1010 1101
% - OHNE die fuehrende Eins und MIT nachfolgender Eins
crc   = [ 0 1 1  1 0 1 0  1 0 1 0  1 1 0 1  1 ];
l_crc = length(crc);
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
% Nutzdatenbits
l_u = 320;
% Gauss-Filter
l_g = 21;
g = gauss_filter( BT, M, l_g );
% Rampe fuer Signal
rmp = sqrt( ( 1 : 5 * M ) / ( 5 * M ) );

%-----------------------------------------
% Parameter fuer die Uebertragungsstrecke
%-----------------------------------------

% Symbol-Rausch-Abstand in dB
Es_N0_dB = 15;
% Rauschleistung bezogen auf die Abtastrate
P_n = M * 10^( -Es_N0_dB / 10 );
% Faktor fuer die Skalierung des Rauschsignals
%  - Amplitude = Wurzel der Leistung
%  - Verteilung auf Real- und Imaginaerteil
k_n = sqrt( P_n / 2 );
% Frequenzoffset
f_off = 0.1 * f_s;
% Taktratenfehler in ppm
t_err_ppm = 100;

%-------------------------------
% Parameter fuer den Empfaenger
%-------------------------------

% Kanalfilter berechnen und initialisieren
h_ch = lowpass_filter( ( 1 + h ) / M );
% Konstante fuer FM-Demodulator
c_fm = M / ( pi * h );
% Mittelungsfilter bilden und initialisieren
h_i = ones( 1, M ) / M;
% Korrelator und Detektor:
% Praeambelsymbole
s_p = 2 * b_p - 1;
n_p = length(s_p);
% Matched Filter fuer Korrelator
h_m = fliplr( kron( s_p, [ 1 zeros( 1, M - 1 ) ] ) );
h_m = h_m( M : end );
l_m = length(h_m);
h_s = abs( h_m );
% Laenge der Daten
l_d = l_u + l_crc;
% Paketlaenge in Abtastwerten
l_pkt = M * ( length(s_p) + l_d );
% Position im Paket (0 = kein Paket detektiert)
p_pkt = 0;
% Paketsignal
s_pkt = zeros( 1, l_pkt );
% Detektionsschwelle
c_m_det = 15;
c_det   = c_m_det;

% -----------------------
% Anzeige initialisieren
%------------------------

% Laenge der FFT
n_fft = 256;
% Spektren
[ S_x, f ] = power_spectrum_density( [], f_a, n_fft );
S_x_1 = power_spectrum_density( [], f_a, n_fft );
figure(1);
s = get(0,'Screensize');
set( gcf, 'Position', [ 0.2*s(3) 0.1*s(4) 0.6*s(3) 0.8*s(4) ] );
% Plot 1: Spektrum des Sendesignals
subplot(3,2,1);
h_S_x = plot( 1e-3 * f, S_x );
grid;
axis( [ 1e-3 * min(f) * [ 1 -1 ] -60 0 ] );
xlabel( 'f [kHz]' );
ylabel( 'S [dB]' );
title( 'Spektrum des Sendesignals' );
% Plot 2: Spektrum des Empfangssignals
subplot(3,2,2);
h_S_x_1 = plot( 1e-3 * f, S_x_1 );
grid;
axis( [ 1e-3 * min(f) * [ 1 -1 ] -60 0 ] );
xlabel( 'f [kHz]' );
ylabel( 'S [dB]' );
title( 'Spektrum des Empfangssignals' );
% Plot 3: Signal der detektierten Pakete
subplot(3,2,3:4);
h_s_pkt = plot( 1000 * ( 1 : l_pkt ) / f_a, zeros( 1, l_pkt ) );
grid;
axis( [ 0 1000 * l_pkt / f_a -3 3 ] );
xlabel( 't [ms]' );
ylabel( 's_i' );
h_t_1 = title( '---' );
% Plot 4: empfangene Symbole
subplot(3,2,5:6);
h_sym = plot( zeros( 1, n_p + l_u + l_crc ), '*' );
grid;
axis( [ 0 n_p + l_u + l_crc + 1 -2 2 ] );
xlabel( 'n' );
ylabel( 's' );
h_t_2 = title( '---' );

%------------
% Simulation
%------------

t = clock;
mix = [];
nr_paket = 0;
while 1
    
  % Sender:
  % Nutzdatenbits erzeugen
  b_u = round( rand( 1, l_u ) );
  % CRC berechnen
  reg = b_u( 1 : l_crc );
  for i = 1 + l_crc : l_u
    reg = mod( [ reg(2:end) b_u(i) ] + reg(1) * crc, 2 );
  end
  for i = 1 : l_crc
    reg = mod( [ reg(2:end) 0 ] + reg(1) * crc, 2 );
  end
  % Bits des Pakets bilden: Praeambel + Nutzdaten + CRC
  b = [ b_p b_u reg ];
  % Symbole des Pakets bilden
  sym = 2 * b - 1;
  % Signal erzeugen
  s = conv( kron( sym, [ M zeros( 1, M - 1 ) ] ), g );
  x = exp( 1i * pi * h / M * cumsum( s ) );
  % Signal mit Rampe versehen und verlaengern
  x_1 = [ rmp * x(1), x, x(end) * fliplr(rmp) ];
  l_x_1 = length(x_1);
  % Spektrum des Sendesignals berechnen
  S_x = power_spectrum_density( x_1, f_a, n_fft );
  
  % Uebertragung:
  % Rauschen addieren
  x_1 = x_1 + k_n * ( randn(1,l_x_1) + 1i * randn(1,l_x_1) );
  % Frequenzoffset erzeugen
  if isempty(mix)
    mix = exp( 2i * pi * ( 1 : l_x_1 ) * f_off / f_a );
  end
  x_1 = x_1 .* mix;
  % Spektrum des Sendesignals berechnen
  S_x_1 = power_spectrum_density( x_1, f_a, n_fft );
  % Spektren anzeigen
  try
    set( h_S_x, 'YData', S_x );
    set( h_S_x_1, 'YData', S_x_1 );
    drawnow;
  catch
    break;
  end
  % Rauschen vor und nach dem Paket ergaenzen
  l_n = floor( ( f_a - l_x_1 ) / 2 );
  n   = k_n * ( randn(1,l_n) + 1i * randn(1,l_n) );
  x_2 = [ n x_1 n ];
  % Abtastratenfehler erzeugen
  x_3 = mexipol( x_2, 1 / ( 1 + 1e-6 * t_err_ppm ) );
  
  % Empfaenger:
  % Kanalfilterung
  x_r = conv( x_3, h_ch );
  % FM-Demodulation
  s_r = c_fm * angle( x_r( 2 : end ) .* conj( x_r(1:end-1) ) );
  % Mittelungsfilter
  s_i = conv( s_r, h_i );
  % Korrelator
  c_m = conv( s_i, h_m );
  c_s = conv( s_i, h_s );
  c_e = conv( s_i.^2, h_s );
  c_m_e = 2 * c_m - c_e + c_s.^2 / n_p;
  % Detektor
  for i = l_m : length(c_m_e) - l_m
    % Schwelle ueberschritten ?
    if c_m_e(i) > c_det
      % ja -> Paketverarbeitung initialisieren:
      % Schwelle auf detektierten Wert anheben
      c_det = c_m_e(i);
      % relativen Frequenzoffset berechnen
      f_off_rel = c_s(i) * h / ( 2 * n_p );
      % Signal der Praeambel in das Paketsignal uebernehmen
      s_pkt( 1 : l_m ) = s_i( i - l_m + 1 : i );
      % Zeiger auf Position im Paketsignal initialisieren
      p_pkt = l_m;
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
          reg = b_d( 1 : l_crc );
          for k = 1 + l_crc : l_d
            reg = mod( [ reg(2:end) b_d(k) ] + reg(1) * crc, 2 );
          end
          crc_ok = ( sum(reg) == 0 );
          % Signal des Pakets anzeigen
          try
            set( h_s_pkt, 'YData', s_pkt );
            set( h_t_1, 'String', sprintf( ...
                 'Paket %d , f_o_f_f / f_s = %.2f', nr_paket, f_off_rel ) );
            set( h_sym, 'Ydata', sym );
            set( h_t_2, 'String', sprintf( 'Symbole , CRC = %d', crc_ok ) );
            drawnow;
          catch
            break;
          end
          % Schwelle zuruecksetzen
          c_det = c_m_det;
          % Position im Paket ruecksetzen
          p_pkt = 0;
        end
      end
    end
  end
  
  d = etime( clock, t );
  if d < 1
      pause( 1 - d );
  end
  t = clock;
  
end
