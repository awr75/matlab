function demod_gfsk_isi
% Uebertragungsimpuls und Augendiagramm bei GFSK
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

% Gauss-Filter
g = gauss_filter( BT, M, 21 );

% Mittelungsfilter
h_i = ones( 1, M );

% Uebertragungsimpuls:
% Impuls mit M = 8
h_1 = conv( h_i, g );
% verzoegerte Impulse
h_2 = filter_delay( h_1, 0.75 );
h_3 = filter_delay( h_1, 0.5 );
h_4 = filter_delay( h_1, 0.25 );
% Impuls mit M = 32
h = reshape( [ 0 h_1 ; h_2 ; h_3 ; h_4 ], 1, [] );

% Zeitachse
l_h = length(h);
n = ( -l_h / 2 : l_h / 2 - 1 ) / ( 4 * M );

% Augendiagramm
spread = [ 1 zeros( 1 , 4 * M - 1 ) ];
s = [ conv( kron( [ -1 -1 -1 ], spread ), h ) ;
      conv( kron( [ -1 -1  1 ], spread ), h ) ;
      conv( kron( [ -1  1 -1 ], spread ), h ) ;
      conv( kron( [ -1  1  1 ], spread ), h ) ;
      conv( kron( [  1 -1 -1 ], spread ), h ) ;
      conv( kron( [  1 -1  1 ], spread ), h ) ;
      conv( kron( [  1  1 -1 ], spread ), h ) ;
      conv( kron( [  1  1  1 ], spread ), h ) ];
i_m = ( size( s, 2 ) - 4 * M + 1 ) / 2;
n_m = - 2 * M : 2 * M ;
t_m = n_m / ( 4 * M );
s   = s( :, 1 + i_m + n_m );

figure(1);
plot(n,h,'b-','Linewidth',1);
grid;
axis([-1.5 1.5 -0.1 1.001]);
xlabel('t / T_s');
title('Uebertragungsimpuls');

figure(2);
for i = 1 : 8
    plot(t_m,s(i,:),'b-','Linewidth',1);
    hold on;
end
plot(-[1 1]/16,[-1.1 1.1],'r-');
plot([1 1]/16,[-1.1 1.1],'r-');
hold off;
grid;
axis([-0.5 0.5 -1.1 1.1]);
xlabel('t / T_s');
title('Augendiagramm');
