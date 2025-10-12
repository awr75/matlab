function ddc_beamforming_filter
% Filter fuer Beamforming fuer einen linearen Antennen-Array mit 4 Elementen
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Verzoegerung zwischen zwei Elementen
delta_0 = 0.2;

% Basis-Tiefpass-Filter fuer Unterabtastung mit M=2 berechnen
h = resampling_filter( 2 );

% PFIR-Filter fuer die DDCs berechnen
h_1 = filter_delay( h, 3 * delta_0 );
h_2 = filter_delay( h, 2 * delta_0 );
h_3 = filter_delay( h, delta_0 );
h_4 = [ h 0 ];

% Frequenzgaenge berechnen
[ H_1, f ] = freqz( h_1, 1, 1024, 1 );
H_2 = freqz( h_2, 1, 1024, 1 );
H_3 = freqz( h_3, 1, 1024, 1 );
H_4 = freqz( h_4, 1, 1024, 1 );

% Betragsfrequenzgaenge
H_1 = 20 * log10( abs( H_1 ) );
H_2 = 20 * log10( abs( H_2 ) );
H_3 = 20 * log10( abs( H_3 ) );
H_4 = 20 * log10( abs( H_4 ) );

% Ueberabtastung um den Faktor 32 zur Darstellung
% der zugehoerigen kontinuierlichen Impulsantwort
h_i_1 = fft_interpolation( h_1, 32 );
h_i_2 = fft_interpolation( h_2, 32 );
h_i_3 = fft_interpolation( h_3, 32 );
h_i_4 = fft_interpolation( h_4, 32 );

% Zeitachsen (n = diskret, t = kontinuierlich)
n = 0 : length(h_1) - 1;
t = ( 0 : length(h_i_1) - 1 ) / 32;

figure(1);
plot(f,H_1,'b-','Linewidth',1);
hold on;
plot(f,H_2,'r-','Linewidth',1);
plot(f,H_3,'-','Color',[0 0.5 0],'Linewidth',1);
plot(f,H_4,'k-','Linewidth',1);
hold off;
grid;
axis([0 0.5 -100 10]);
xlabel('f / f_a');
ylabel('|H_i| [dB]');
title('Frequenzgaenge der PFIR Filter');
legend('1','2','3','4');

figure(2);
plot(t,h_i_1,'b-');
hold on;
plot(t,h_i_2,'r-');
plot(t,h_i_3,'-','Color',[0 0.5 0]);
plot(t,h_i_4,'k-');
plot(n,h_1,'bs','Linewidth',2,'Markersize',2);
plot(n,h_2,'rs','Linewidth',2,'Markersize',2);
plot(n,h_3,'s','Color',[0 0.5 0],'Linewidth',2,'Markersize',2);
plot(n,h_4,'ks','Linewidth',2,'Markersize',2);
hold off;
grid;
axis([25.5 38.5 -0.15 0.501]);
set(gca,'XTick',26:38);
xlabel('t / T_a');
title('Impulsantworten der PFIR Filter');
legend('1','2','3','4');

function h_i = fft_interpolation(h,n)
l_h = length(h);
l_f = 2^( ceil( log2( l_h + 1 ) ) );
H_f = fft( [ h zeros( 1, l_f - l_h ) ] );
H_i_f = [ H_f( 1 : l_f / 2 ) ...
          zeros( 1, ( n - 1 ) * l_f + 1 ) ...
          H_f( l_f / 2 + 2 : end ) ];
h_i = ifft( H_i_f );
h_i = n * h_i( 1 : ( l_h - 1 ) * n + 1 );
