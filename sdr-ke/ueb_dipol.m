function ueb_dipol
% Richtcharakteristik eines Dipols
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

r = 2.4;

theta = pi * ( 0 : 0.04 : 2 );
phi   = 2 * pi * ( 0 : 0.04 : 1 )';
x = r * ( 1 + cos(phi) ) * cos(theta);
y = r * ( 1 + cos(phi) ) * sin(theta);
z = r * sin(phi) * ones( size(theta) );

figure(1);
colormap([0 0 1;0 0 1]);
mesh(x,y,z);
axis equal;
axis(r*[-2 2 -2 2 -1 1]);
xlabel('x');
ylabel('y');
zlabel('z');
title('Richtcharakteristik eines Dipols');

figure(2);
colormap([0 0 1;0 0 1]);
mesh(x(14:26,:),y(14:26,:),z(14:26,:));
hold on;
plot3(x(26,:),y(26,:),z(26,:),'b-','Linewidth',2);
plot3(2*r*[-1 -1 1 1 -1],2*r*[-1 1 1 -1 -1],[0 0 0 0 0],'b-');
hold off;
axis equal;
axis(r*[-2 2 -2 2 -1 1]);
xlabel('x');
ylabel('y');
zlabel('z');
title('Richtcharakteristik eines Dipols (Schnitt z = 0)');

figure(3);
colormap([0 0 1;0 0 1]);
mesh(x(:,1:26),y(:,1:26),z(:,1:26));
hold on;
plot3(x(:,1),y(:,1),z(:,1),'b-','Linewidth',2);
plot3(x(:,26),y(:,26),z(:,26),'b-','Linewidth',2);
plot3(2*r*[-1 1 1 -1 -1],[0 0 0 0 0],r*[-1 -1 1 1 -1],'b-');
hold off;
axis equal;
axis(r*[-2 2 -2 2 -1 1]);
xlabel('x');
ylabel('y');
zlabel('z');
title('Richtcharakteristik eines Dipols (Schnitt y = 0)');
