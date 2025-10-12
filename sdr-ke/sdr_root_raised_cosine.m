function sdr_root_raised_cosine
% Berechnung von Root Raised Cosine Impulsen
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

[g1,t1,G1,f1] = rrcf(0.25);
[g2,t2,G2,f2] = rrcf(0.33);
[g3,t3,G3,f3] = rrcf(0.5);

figure(1);
plot(f1,G1,'b-','Linewidth',1);
hold on;
plot(f2,G2,'r-','Linewidth',1);
plot(f3,G3,'-','Color',[0 0.5 0],'Linewidth',1);
hold off;
grid;
axis([-0.75 0.75 0 1.2]);
set(gca,'XTick',-0.75:0.25:0.75);
xlabel('f / f_s');
title('Root Raised Cosine: Frequenzgaenge');
legend('r = 0.25','r = 0.33','r = 0.5');

figure(2);
plot(t1,g1,'b-','Linewidth',1);
hold on;
plot(t2,g2,'r-','Linewidth',1);
plot(t3,g3,'-','Color',[0 0.5 0],'Linewidth',1);
hold off;
grid;
axis([-4 4 -0.4 1.201]);
xlabel('t / T_s');
title('Root Raised Cosine: Impulse');
legend('r = 0.25','r = 0.33','r = 0.5');

function [g,t,G,f] = rrcf(r)
f = ( 1 : 256 * ( 1 + r ) ) / 512;
G = zeros( 1, length(f) );
for i = 1 : length(f)
    if f(i) < 0.5 * ( 1 - r )
        G(i) = 1;
    else
        G(i) = sqrt( 0.5 + 0.5 * cos( pi / (2 * r) * ( 2 * f(i) - 1 + r ) ) );
    end
end
f = [ -fliplr(f) 0 f ];
G = [  fliplr(G) 1 G ];
G_m = G(1:16:end);
l_m = length(G_m);
G_m = circshift( [ G_m zeros( 1, 2048 - l_m ) ], [ 0 (1 - l_m)/2 ] );
g = fftshift(real(ifft(G_m)));
g = 64 * g(2:end);
t = ( -1023 : 1023 ) / 64;
