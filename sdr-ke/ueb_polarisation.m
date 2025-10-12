function ueb_polarisation
% Daempfung durch eine Fehlausrichtung der Polarisation
% zwischen einer Sende- und einer Empfangsantenne
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2014
%------------------------------------------------

close all;

% Daempfungsfunktion
phi = -90 : 90;
d = 1 ./ cos(pi * phi / 180).^2;
d_db = 10 * log10(d);

figure(1);
plot(phi,d_db,'b-','Linewidth',1);
grid on;
axis([min(phi) max(phi) 0 40]);
xlabel('phi [Grad]');
ylabel('D [dB]');
title('Daempfung durch Fehlausrichtung');
