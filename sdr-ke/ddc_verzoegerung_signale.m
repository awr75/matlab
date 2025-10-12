function ddc_verzoegerung_signale
% Fraktionale Verzoegerung eines diskreten Signals
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% diskretes Eingangssignal
n = -10 : 20;
x_n = 0.8 * sin( pi * n / 10 ) - 0.5 * cos( pi * n / 3 ) - 0.3;
l_n = length(n);

% Zeitachse fuer kontinuierliches Signal
t_x = -1 : 0.02 : 10.5;
% Anteile des kontinuierlichen Signals
x_t_n = zeros( l_n , length(t_x) );
for i = 1 : l_n
    x_t_n(i,:) = x_n(i) * ( sin( pi * ( t_x - n(i) ) ) + 1e-12 ) ./ ...
                          ( pi * ( t_x - n(i) ) + 1e-12 );
end
% kontinuierliches Signals
x_t = sum( x_t_n , 1 );

% verzoegertes Signal
y_t = x_t;
t_y = t_x + 0.5;

% Abtastung des verzoegerten Signals
n_y = 0 : 10;
y_n = y_t( 26 + 50 * n_y );

figure(1);
plot(t_x,x_t,'b--');
hold on;
plot(n,x_n,'bs','Linewidth',3,'Markersize',2);
hold off;
grid;
axis([-0.5 10.5 -1 1]);
xlabel('n = t / T_a');
title('Diskretes Eingangssignal');

figure(2);
plot(t_x,x_t,'r-','Linewidth',2);
hold on;
plot(n,x_n,'bs','Linewidth',3,'Markersize',2);
for i = 1 : l_n
    plot(t_x,x_t_n(i,:),'b-');
end
hold off;
grid;
axis([-0.5 10.5 -1 1]);
xlabel('n = t / T_a');
title('Rekonstruiertes kontinuierliches Eingangssignal');
legend('rekonstruiertes Signal','Abtastwerte',...
       'sin(x)/x-Interpolationsfunktionen','Location','SouthEast');

figure(3);
plot(t_x,x_t,'b-');
hold on;
plot(t_y,y_t,'r-','Linewidth',1);
hold off;
grid;
axis([-0.5 10.5 -1 1]);
xlabel('n = t / T_a');
title('Eingangssignal und verzoegertes Eingangssignal');
legend('Eingangssignal','verzoegertes Eingangssignal',...
       'Location','SouthEast');

figure(4);
plot(t_y,y_t,'r--','Linewidth',1);
hold on;
plot(n_y,y_n,'rs','Linewidth',3,'Markersize',2);
hold off;
grid;
axis([-0.5 10.5 -1 1]);
xlabel('n = t / T_a');
title('Diskretes Ausgangssignal');
