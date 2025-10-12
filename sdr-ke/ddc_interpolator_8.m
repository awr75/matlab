function ddc_interpolator_8
% Impulsantwort eines 8-Punkt-Interpolators
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

h = zeros( 20, 8 );
H = zeros( 20, 256 );
for i = 1 : 20
    h(i,:) = interpolator_8( ( i - 1 ) / 20 );
    H(i,:) = 20 * log10( abs( freqz( h(i,:), 1, 256, 1 ) ) );
end
hi = reshape( flipud(h), 1, [] );

t = ( 1 : length(hi) ) / 20;
f = ( 0 : 255 ) / 512;

figure(1);
plot(f,H(1,:),'b-','Linewidth',1);
hold on;
for i = 2 : 11
    plot(f,H(i,:),'b-','Linewidth',1);
end
hold off;
grid;
axis([0 0.5 -20 2]);
xlabel('f / f_a');
ylabel('|H_i| [dB]');
title('Frequenzgang des Interpolators');

figure(2);
plot(t,hi,'b-','Linewidth',1);
grid;
axis([0 8 -0.2 1.1]);
xlabel('n = t / T_a');
title('Interpolationsfunktion h_i(t)');
