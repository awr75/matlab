function sdr_praeambel_foff_1
% Aperiodische Autokorrelation einer Chu-Praeambel mit Frequenzoffset
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Chu Sequence (Polyphasen-Symbole)
N = 31;
n = 0 : N - 1;
s_p = exp( 1i * pi * n .* ( n + 1 ) / N );
% aperiodische Autokorrelation ohne Frequenzoffset
R_sp_sp = conv( s_p , conj( fliplr(s_p) ) );
% aperiodische Autokorrelation mit f_off / f_s = 0.01
R_spr_sp_1 = conv( s_p .* exp( 2i * pi * 0.01 * n) , ...
                   conj( fliplr(s_p) ) );
% aperiodische Autokorrelation mit f_off / f_s = 0.02
R_spr_sp_2 = conv( s_p .* exp( 2i * pi * 0.02 * n) , ...
                   conj( fliplr(s_p) ) );

d = - N + 1 : N - 1;

figure(1);
plot(d,abs(R_sp_sp),'bs','Linewidth',3,'Markersize',2);
grid;
axis([min(d) max(d) 0 32]);
xlabel('Verschiebung d');
ylabel('Betrag der AKF');
title('Autokorrelationsfunktion der Chu Sequence');

figure(2);
plot(d,abs(R_spr_sp_1),'bs','Linewidth',3,'Markersize',2);
grid;
axis([min(d) max(d) 0 32]);
xlabel('Verschiebung d');
ylabel('Betrag der KKF');
title('Kreuzkorrelationsfunktion der Chu Sequence (Offset = 0.01)');

figure(3);
plot(d,abs(R_spr_sp_2),'bs','Linewidth',3,'Markersize',2);
grid;
axis([min(d) max(d) 0 32]);
xlabel('Verschiebung d');
ylabel('Betrag der KKF');
title('Kreuzkorrelationsfunktion der Chu Sequence (Offset = 0.02)');
