function demod_pam_korrelator_verteilung(force)
% Simulation der Verteilungsdichten des Korrelatormaximums
% und der Detektorkennlinien bei PAM-Praeambeldetektion
%
% HINWEIS: Wir liefern Simulationsergebnisse mit.
%          Sollte ein Fehler auftreten, rufen Sie
%          die Funktion bitte mit
%
%             demod_pam_korrelator_verteilung(1)
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

% Ergebnisse der Simulation mit Rauschen bereitstellen
datei = 'demod_pam_korrelator_rauschen.mat';
if ~exist( datei, 'file' ) || (force > 0)
    demod_pam_korrelator_rauschen_sim;
end
p_r = load( datei );
p_r.dx_m = ( max( p_r.x_m ) - min( p_r.x_m ) ) / ...
           ( length(p_r.x_m) - 1 );
p_r.p_fa = p_r.dx_m * fliplr( cumsum( fliplr( p_r.y_m ) ) );

% Symbol-Rausch-Abstaende
Es_N0_dB = [ 6 8 10 14 20 ];

sim = [];
for i = 1 : length(Es_N0_dB)
    datei = demod_pam_korrelator_verteilung_sim( Es_N0_dB(i) );
    p = load( datei );
    sim(i).Es_N0_dB = p.Es_N0_dB;
    sim(i).x_m  = p.x_m;
    sim(i).y_m  = p.y_m;
    sim(i).dx_m = ( max( p.x_m ) - min( p.x_m ) ) / ...
                  ( length(p.x_m) - 1 );
    sim(i).p_md = sim(i).dx_m * cumsum( sim(i).y_m );
    sim(i).mean = sim(i).dx_m * sim(i).y_m * sim(i).x_m.';
    sim(i).var  = sim(i).y_m .* sim(i).x_m * sim(i).x_m.' * ...
                  sim(i).dx_m - sim(i).mean^2;
end

figure(1);
for i = 1 : length(sim)
    semilogy(sim(i).x_m,sim(i).y_m+1e-12,'b-','Linewidth',1);
    hold on;
end
hold off;
grid;
axis([20 40 1e-3 1]);
xlabel('E_m_n');
ylabel('PDF(E_m_n)');
title('Verteilungsdichte der normierten Detektionsenergie');

figure(2);
semilogy(p_r.x_m,p_r.p_fa+1e-12,'r-','Linewidth',1);
hold on;
for i = 1 : length(sim)
    semilogy(sim(i).x_m,sim(i).p_md+1e-9,'b-','Linewidth',1);
end
hold off;
grid;
axis([10 40 1e-6 1.5]);
xlabel('E_m_n');
ylabel('P_F_A , P_M_D');
title('Kennlinien des Detektors');
legend('P_F_A','P_M_D','Location','NorthWest');
