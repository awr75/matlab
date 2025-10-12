function demod_gfsk_korrelator_p_fa(force)
% Wahrscheinlichkeit fuer einen falschen Alarm bei
% GFSK-Praeambeldetektion mit LDI-Demodulator
%
% HINWEIS: Wir liefern Simulationsergebnisse mit.
%          Sollte ein Fehler auftreten, rufen Sie
%          die Funktion bitte mit
%
%             demod_gfsk_korrelator_p_fa(1)
%
%          auf, um eine Neuberechnung zu erzwingen.
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

if nargin == 0
    force = 0;
end

datei = 'demod_gfsk_korrelator_rauschen.mat';
if ~exist( datei, 'file' ) || (force > 0)
    demod_gfsk_korrelator_rauschen_sim;
end
load(datei);

% Wahrscheinlichkeit fuer einen Falschalarm
dx_m = ( max( x_m ) - min( x_m ) ) / ...
       ( length(x_m) - 1 );
p_fa = dx_m * fliplr( cumsum( fliplr( y_m ) ) );

% Q-Funktion
sigma  = 5.55;
p_fa_n = 0.5 * erfc( x_m / ( sqrt(2) * sigma ) );

figure(1);
semilogy(x_m,p_fa+1e-12,'b-','Linewidth',2);
hold on;
semilogy(x_m,p_fa_n,'r--','Linewidth',2);
hold off;
grid;
axis([0 26 1e-6 1]);
xlabel('c_m_,_d_e_t');
ylabel('P_F_A');
title('Wahrscheinlichkeit fuer einen falschen Alarm');
legend('Simulation','Naeherung');

figure(2);
plot(x_akf,R_akf,'bs','Linewidth',3,'Markersize',2);
grid;
axis([min(x_akf) max(x_akf) -10 40]);
xlabel('Verschiebung d');
ylabel('AKF(c_m)');
title('Autokorrelationsfunktion des Korrelatorsignals');
