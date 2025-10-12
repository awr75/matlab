function ddc_halbband_filter_approx
% Approximation eines Halbband-FIR-Filters
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

h = remez( 10, [ 0 0.4 0.6 1 ], [ 1 1 0 0 ] );
f = ( 0 : 500 ) / 1000;
H = h(6) + 2 * ( h(7) * cos( 2 * pi * f ) + h(9) * cos( 6 * pi * f ) ...
                 + h(11) * cos( 10 * pi * f ) );
alpha = H(1) - 1;

figure(1);
plot(f,H,'b-','Linewidth',2);
hold on;
plot([0 0.5],(1+alpha)*[1 1],'k--');
plot([0 0.5],(1-alpha)*[1 1],'k--');
plot([0 0.5],alpha*[1 1],'k--');
plot([0 0.5],-alpha*[1 1],'k--');
hold off;
grid;
axis([0 0.5 -0.1 1.1]);
xlabel('f / f_a');
ylabel('H');
title('Approximation eines Halbband-FIR-Filters')
