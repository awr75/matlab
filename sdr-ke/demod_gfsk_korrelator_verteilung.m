function demod_gfsk_korrelator_verteilung(force)
% Simulation der Verteilungsdichten des Korrelatormaximums
% und der Detektorkennlinien bei GFSK-Praeambeldetektion
%
% HINWEIS: Wir liefern Simulationsergebnisse mit.
%          Sollte ein Fehler auftreten, rufen Sie
%          die Funktion bitte mit
%
%             demod_gfsk_korrelator_verteilung(1)
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
datei = 'demod_gfsk_korrelator_rauschen.mat';
if ~exist( datei, 'file' ) || (force > 0)
    demod_gfsk_korrelator_rauschen_sim;
end
p_r = load( datei );
p_r.dx_m = ( max( p_r.x_m ) - min( p_r.x_m ) ) / ...
           ( length(p_r.x_m) - 1 );
p_r.p_fa = p_r.dx_m * fliplr( cumsum( fliplr( p_r.y_m ) ) );
p_r.dx_m_e = ( max( p_r.x_m_e ) - min( p_r.x_m_e ) ) / ...
             ( length(p_r.x_m_e) - 1 );
p_r.p_fa_e = p_r.dx_m_e * fliplr( cumsum( fliplr( p_r.y_m_e ) ) );

% Symbol-Rausch-Abstaende
Es_N0_dB = [ 9:15 20 ];

sim = [];
for i = 1 : length(Es_N0_dB)
    datei = demod_gfsk_korrelator_verteilung_sim( Es_N0_dB(i) );
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
    sim(i).x_m_e  = p.x_m_e;
    sim(i).y_m_e  = p.y_m_e;
    sim(i).dx_m_e = ( max( p.x_m_e ) - min( p.x_m_e ) ) / ...
                    ( length(p.x_m_e) - 1 );
    sim(i).p_md_e = sim(i).dx_m_e * cumsum( sim(i).y_m_e );
    sim(i).sigma_m   = p.sigma_m;
    sim(i).sigma_m_e = p.sigma_m_e;
end

figure(1);
for i = 1 : length(sim)
    semilogy(sim(i).x_m,sim(i).y_m+1e-12,'b-','Linewidth',1);
    hold on;
end
hold off;
grid;
axis([20 32 1e-3 2]);
xlabel('E_m');
ylabel('PDF(E_m)');
title('Verteilungsdichte der Detektionsenergie des Korrelators');

figure(2);
semilogy(p_r.x_m,p_r.p_fa+1e-12,'r-','Linewidth',1);
hold on;
for i = 1 : length(sim)
    semilogy(sim(i).x_m,sim(i).p_md+1e-9,'b-','Linewidth',1);
end
hold off;
grid;
axis([15 30 1e-6 1.5]);
xlabel('E_m');
ylabel('P_F_A , P_M_D');
title('Kennlinien des Detektors mit Korrelation');
legend('P_F_A','P_M_D','Location','NorthWest');

figure(3);
for i = 1 : length(sim)
    semilogy(sim(i).x_m_e,sim(i).y_m_e+1e-12,'b-','Linewidth',1);
    hold on;
end
hold off;
grid;
axis([17 32 1e-3 4]);
xlabel('E_m_,_e');
ylabel('PDF(E_m_,_e)');
title('Verteilungsdichte der euklidischen Metrik');

figure(4);
semilogy(p_r.x_m_e,p_r.p_fa_e+1e-12,'r-','Linewidth',1);
hold on;
for i = 1 : length(sim)
    semilogy(sim(i).x_m_e,sim(i).p_md_e+1e-9,'b-','Linewidth',1);
end
hold off;
grid;
axis([6 32 1e-6 1.5]);
xlabel('E_m_,_e');
ylabel('P_F_A , P_M_D');
title('Kennlinien des Detektors mit euklidischer Metrik');
legend('P_F_A','P_M_D','Location','NorthWest');

figure(5);
semilogy(Es_N0_dB,[sim.var],'b-','Linewidth',1);
grid;
axis([min(Es_N0_dB) max(Es_N0_dB) 0.05 3]);
xlabel('E_s/N_0 [dB]');
ylabel('var(E_m)');
title('Varianz der Detektionsenergie');

figure(6);
plot(Es_N0_dB,[sim.sigma_m_e],'b-','Linewidth',1);
grid;
axis([min(Es_N0_dB) max(Es_N0_dB) 0.062 0.064]);
set(gca,'YTick',0.062:0.0005:0.064);
xlabel('E_s/N_0 [dB]');
ylabel('sigma(tau_t)');
title('Standardabweichung des Detektionszeitpunkts');
