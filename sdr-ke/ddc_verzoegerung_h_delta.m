function ddc_verzoegerung_h_delta
% Koeffizienten h_delta eines Verzoegerungsfilters
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% sin(x)/x
t_h = -11.5 : 0.025 : 10.5;
h_t = ( sin( pi * t_h ) + 1e-12 ) ./ ( pi * t_h + 1e-12 );

% diskrete Filter
delta = 0 : 0.25 : 1;
n_h = -10 : 10;
h_n = zeros( length(delta), length(n_h) );
for i = 1 : length(delta)
    h_n(i,:) = h_t( 461 + 40 * n_h - 40 * delta(i) ); 
end

figure(1);
plot(t_h+delta(1),h_t,'b--');
hold on;
plot(n_h,h_n(1,:),'bs','Linewidth',3,'Markersize',2);
hold off;
grid;
axis([-10.5 10.5 -0.3 1.1]);
xlabel('n = t / T_a');
title('Koeffizienten fuer delta = 0');

figure(2);
plot(t_h+delta(2),h_t,'b--');
hold on;
plot(n_h,h_n(2,:),'bs','Linewidth',3,'Markersize',2);
hold off;
grid;
axis([-10.5 10.5 -0.3 1.1]);
xlabel('n = t / T_a');
title('Koeffizienten fuer delta = 0.25');

figure(3);
plot(t_h+delta(3),h_t,'b--');
hold on;
plot(n_h,h_n(3,:),'bs','Linewidth',3,'Markersize',2);
hold off;
grid;
axis([-10.5 10.5 -0.3 1.1]);
if nargin > 0
    set(gca,'PlotBoxAspectRatio',[1 0.2 1]);
    set(gca,'Fontname','TimesNewRoman','Fontsize',12);
    print -deps fig3.eps
else
    xlabel('n = t / T_a');
    title('Koeffizienten fuer delta = 0.5');
end

figure(4);
plot(t_h+delta(4),h_t,'b--');
hold on;
plot(n_h,h_n(4,:),'bs','Linewidth',3,'Markersize',2);
hold off;
grid;
axis([-10.5 10.5 -0.3 1.1]);
xlabel('n = t / T_a');
title('Koeffizienten fuer delta = 0.75');

figure(5);
plot(t_h+delta(5),h_t,'b--');
hold on;
plot(n_h,h_n(5,:),'bs','Linewidth',3,'Markersize',2);
hold off;
grid;
axis([-10.5 10.5 -0.3 1.1]);
xlabel('n = t / T_a');
title('Koeffizienten fuer delta = 1');
