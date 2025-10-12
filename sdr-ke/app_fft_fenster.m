function app_fft_fenster
% Frequenzgang einiger Fensterfunktionen
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

if exist('OCTAVE_VERSION','builtin')
    pkg load signal; 
end

% Blackman-Fenster
w1 = blackman_window(32);
[ W1, f ] = freqz( w1 / sum(w1), 1, 256, 1 );
f = [ f-0.5 ; f ];
W1 = 20 * log10( abs( [ 1e-12 ; flipud(W1(2:end)) ; W1 ] ) );

% Hann-Fenster
w2 = hann(32).';
W2 = freqz( w2 / sum(w2), 1, 256, 1 );
W2 = 20 * log10( abs( [ 1e-12 ; flipud(W2(2:end)) ; W2 ] ) );

% Hamming-Fenster
w3 = hamming(32).';
W3 = freqz( w3 / sum(w3), 1, 256, 1 );
W3 = 20 * log10( abs( [ 1e-12 ; flipud(W3(2:end)) ; W3 ] ) );

% Flat-Top-Fenster
w4 = flattop_window(32);
W4 = freqz( w4 / sum(w4), 1, 256, 1 );
W4 = 20 * log10( abs( [ 1e-12 ; flipud(W4(2:end)) ; W4 ] ) );

% Ueberabgetastete Fenster berechnen
[ w1t, t ] = oversampling( w1, 8 );
w2t = oversampling( w2, 8 );
w3t = oversampling( w3, 8 );
w4t = oversampling( w4, 8 );

figure(1);
for i = 1 : 31
    Wi = circshift( W1, [ 16*i 0 ] );
    plot([f;0.5],[Wi;Wi(1)],'b-');
    hold on;
end
plot([f;0.5],[W1;W1(1)] ,'r-','Linewidth',2);
hold off;
grid on;
axis([-0.5 0.5 -100 10]);
xlabel('f / f_a');
ylabel('|W| [dB]');
title('Frequenzgang eines Blackman-Fensters der Laenge 32');

figure(2);
for i = 1 : 31
    Wi = circshift( W2, [ 16*i 0 ] );
    plot([f;0.5],[Wi;Wi(1)],'b-');
    hold on;
end
plot([f;0.5],[W2;W2(1)] ,'r-','Linewidth',2);
hold off;
grid on;
axis([-0.5 0.5 -100 10]);
xlabel('f / f_a');
ylabel('|W| [dB]');
title('Frequenzgang eines Hann-Fensters der Laenge 32');

figure(3);
for i = 1 : 31
    Wi = circshift( W3, [ 16*i 0 ] );
    plot([f;0.5],[Wi;Wi(1)],'b-');
    hold on;
end
plot([f;0.5],[W3;W3(1)] ,'r-','Linewidth',2);
hold off;
grid on;
axis([-0.5 0.5 -100 10]);
xlabel('f / f_a');
ylabel('|W| [dB]');
title('Frequenzgang eines Hamming-Fensters der Laenge 32');

figure(4);
for i = 1 : 31
    Wi = circshift( W4, [ 16*i 0 ] );
    plot([f;0.5],[Wi;Wi(1)],'b-');
    hold on;
end
plot([f;0.5],[W4;W4(1)] ,'r-','Linewidth',2);
hold off;
grid on;
axis([-0.5 0.5 -100 10]);
xlabel('f / f_a');
ylabel('|W| [dB]');
title('Frequenzgang eines Flat-Top-Fensters der Laenge 32');

figure(5);
plot(t,w1t,'b-');
hold on;
plot(t,w2t,'r-');
plot(t,w3t,'-','Color',[0 0.5 0]);
plot(t,w4t,'k-');
plot(0:31,w1,'bs','Linewidth',3,'Markersize',2);
plot(0:31,w2,'rs','Linewidth',3,'Markersize',2);
plot(0:31,w3,'s','Color',[0 0.5 0],'Linewidth',3,'Markersize',2);
plot(0:31,w4,'ks','Linewidth',3,'Markersize',2);
hold off;
grid on;
set(gca,'XTick',(0:2:31));
axis([0 31 -0.2 1.2]);
xlabel('n');
ylabel('w');
title('Fensterfunktionen der Laenge 32');
legend('Blackman','Hann','Hamming','Flat-Top');

function [w_t,t]=oversampling(w,over)
% Ueberabtastung durch Zero-Stuffing im Frequenzbereich
l_w = length(w);
l_t = over*(l_w-1)+1;
t = (0:(l_t-1))/over;
f = fft(w);
w_t = over*ifft([f(1:l_w/2) zeros(1,(over-1)*l_w) f((l_w/2+1):l_w)]);
w_t = w_t(1:l_t)/max(w_t);
