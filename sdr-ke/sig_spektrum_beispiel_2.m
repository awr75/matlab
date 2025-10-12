function sig_spektrum_beispiel_2
% 3D-Anzeige der Spektren eines Mehrfrequenzsignals
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

len = length(f);
mid = len / 2;
off = mid / 2 - 1;
f   = f(mid - off : mid + off);
s_x = s_x(: , mid - off : mid + off);

figure(1);
for i = 1 : 12
    plot3(t(i) * ones(1,length(f)),0.001 * f,s_x(i,:),'b-','Linewidth',2);
    hold on;
end
hold off;
grid on;
axis([0 0.6 -2 2 -50 0]);
set(gca,'PlotBoxAspectRatio',[1 0.4 0.2]);
set(gca,'CameraPosition',[-2 -80 2000]);
xlabel('t [s]');
ylabel('f [kHz]');
zlabel('S [dB]');
title('3-D-Darstellung der Spektren');
