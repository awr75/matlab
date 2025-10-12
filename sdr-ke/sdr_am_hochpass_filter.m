function sdr_am_hochpass_filter
% Hochpass-Filter fuer AM-Demodulation
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

f_a = 48000;
f_g = 100;
omega = 2 * pi * f_g / f_a;
c = (1 - sin(omega)) / cos(omega);
b = 0.5 * (1 + c) * [1 -1];
a = [1 -c];
f = 10.^(0:0.02:3);
h = freqz(b,a,f,f_a);
h_db  = 20 * log10(abs(h) + 1e-12);

figure(1);
semilogx(f,h_db,'b-','Linewidth',1);
grid;
axis([1 1000 -40 5]);
set(gca,'XTick',[1 10 100 1000]);
set(gca,'XTickLabel',['  1 ';' 10 ';' 100';'1000']);
xlabel('f [Hz]');
ylabel('|H| [dB]');
title('Betragsfrequenzgang des Hochpassfilters');
