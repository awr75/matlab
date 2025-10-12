function ddc_halbband_filter_iteration
% Entwicklung des Frequenzgangs bei der Approximation
% eines Halbband-Filters
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Berechnung
[ h, h_hb, h_hb_iter ] = halfband_filter( 3, 80 );
fprintf( 1, 'Iterationen: %d\n', size( h_hb_iter, 1 ) );

[ H_1, f ] = frequenzgang( h_hb_iter( 1, : ), 1024 );
H_2 = frequenzgang( h_hb_iter( 30, : ), 1024 );
H_3 = frequenzgang( h_hb_iter( end, : ), 1024 );

figure(1);
plot(f,H_1,'b-','Linewidth',1);
hold on;
plot(f,H_2,'r-','Linewidth',1);
plot(f,H_3,'-','Color',[0 0.5 0],'Linewidth',1);
hold off;
grid;
axis([0 0.25 -120 10]);
xlabel('f / f_a');
ylabel('|H| [dB]');
title('Approximation eines Halbbandfilters');
legend('Start','Iter = 30','Iter = 114','Location','SouthEast');

function [ H, f ] = frequenzgang( h_hb, n )
h = kron( h_hb( 2 : end ), [ 1 0 ] );
h = h( 1 : end - 1 );
h = [ fliplr(h) h_hb(1) h ];
[ H, f ] = freqz( h, 1, n, 1 );
i = length(f) / 2;
f = [ f( 1 : i ) ; 0.5 - f( i+1 : end ) ];
H = 20 * log10( abs( H ) );
