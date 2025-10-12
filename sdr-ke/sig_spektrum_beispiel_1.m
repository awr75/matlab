function sig_spektrum_beispiel_1
% Anzeige eines Spektrums eines Mehrfrequenzssignals
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
plot(0.001 * f,s_x(3,:),'b-','Linewidth',2);
grid on;
axis([-4 4 -50 -10]);
xlabel('f [kHz]');
ylabel('S [dB]');
title('Einzelspektrum aus dem ersten Tonpaar');
