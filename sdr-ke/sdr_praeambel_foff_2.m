function sdr_praeambel_foff_2
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

% relativer Frequenzoffset
f_rel = -0.02:0.0005:0.02;
len   = length(f_rel);

r0 = zeros( 1, len );
r1 = zeros( 1, len );

for i = 1 : len
    % aperiodische Autokorrelation mit Frequenzoffset
    R = conv( s_p .* exp( 2i * pi * f_rel(i) * n) , ...
              conj( fliplr(s_p) ) );
    r0(i) = abs( R(N) );
    R(N)  = 0;
    r1(i) = max( abs( R ) );
end

% Kennlinie einer Korrelator-Bank
f_step = 0.01;
idx = find( abs( f_rel ) <= 0.75 * f_step + 1e-6 );
f_rel_0 = f_rel(idx);
r0_0 = r0(idx);
r1_0 = r1(idx);
idx = find( abs( f_rel ) <= 0.5 * f_step + 1e-6 );
f_rel_1 = f_rel(idx);
r0_1 = r0(idx);
r1_1 = r1(idx);

figure(1);
plot(f_rel,r0,'b-','Linewidth',1);
hold on;
plot(f_rel,r1,'r-','Linewidth',1);
hold off;
grid;
axis([min(f_rel) max(f_rel) 0 32]);
xlabel('relativer Frequenzoffset');
ylabel('Betrag der KKF');
title('Kreuzkorrelationsfunktion der Chu Sequence');
legend('Hauptmaximum','Nebenmaximum','Location','SouthEast');

figure(2);
plot(0,0);
hold on;
for i = - 3 : 3
    plot(f_rel_0 + i * f_step,r0_0,'b--','Linewidth',1);
    plot(f_rel_1 + i * f_step,r0_1,'b-','Linewidth',1);
    plot(f_rel_0 + i * f_step,r1_0,'r--','Linewidth',1);
    plot(f_rel_1 + i * f_step,r1_1,'r-','Linewidth',1);
end
hold off;
grid;
axis([min(f_rel) max(f_rel) 0 32]);
xlabel('relativer Frequenzoffset');
ylabel('Betrag der KKF');
title('Kreuzkorrelationsfunktion der Chu Sequence');
