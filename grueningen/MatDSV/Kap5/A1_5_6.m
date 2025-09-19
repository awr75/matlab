% M-File  A1_5_6.M      
% Lösung zu Band 1, Kap.5, Aufgabe 6 
%
% Drei verschiedene weisse Rauschsignale

clear, close, clf

% Rauschsignal normalverteilt
n=-20:1:20;
x1=randn(1,41);
subplot(4,1,1),h=stem(n,x1,'fill');axis([-20 20 -3 3]),grid
set(h,'linewidth',1,'MarkerSize',3)

% Rauschsignal gleichverteilt
x2=2*sqrt(3)*(rand(1,41)-0.5);
subplot(4,1,2),h=stem(n,x2,'fill');axis([-20 20 -3 3]),grid
set(h,'linewidth',1,'MarkerSize',3)


% Binärsignal
x3=rand(1,41)-0.5>0; x3=2*(x3-.5);
subplot(4,1,3),h=stem(n,x3,'fill');axis([-20 20 -3 3]),grid
set(h,'linewidth',1,'MarkerSize',3)


pause,close