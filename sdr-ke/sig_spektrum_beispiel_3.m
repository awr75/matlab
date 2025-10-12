function sig_spektrum_beispiel_3
% Anzeige des Spektrogramms eines Mehrfrequenzsignals
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

if exist('sig_spektrum_beispiel.mat','file') == 0
    fprintf(1,'Bitte zunaechst sig_spektrum_beispiel.m ausfuehren !\n');
    return;
end
load sig_spektrum_beispiel.mat;

figure(1);
imagesc(t,0.001 * f,s_x.');
set(gca,'YDir','normal');
grid on;
axis([0 3.9 -2 2]);
xlabel('t [s]');
ylabel('f [kHz]');
title('Spektrogramm');
