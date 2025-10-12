function sdr_rauschen_nf
% Darstellung der typischen Rauschleistungsdichte von Halbleitern

close all;

f = 0.2:0.05:10;
n = 1./f;
f = [-fliplr(f) f];
n = [fliplr(n) n];

figure(1);
plot(f,n,'b-','Linewidth',1);
hold on;
plot(f,ones(1,length(f)),'-','Color',[0 0.5 0],'Linewidth',1);
plot(f,n+ones(1,length(f)),'r-','Linewidth',1);
hold off;
grid;
axis([min(f) max(f) 0 4]);
xlabel('f / f_g');
ylabel('Sn(f) / Sn(inf) [linear]');
title('Normalisierte Rauschleistungsdichte von Halbleitern');
legend('1/f-Rauschen','weisses Rauschen','gesamtes Rauschen');
