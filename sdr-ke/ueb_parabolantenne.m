function ueb_parabolantenne
% Strahlengang in einer Parabolantenne
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Parabolkontour
a = 0.3;
x = -1.02 : 0.02 : 1.02;
y = a * x.^2;

figure(1);
plot(x,y,'k-','Linewidth',4);
axis equal;
axis([-1.1 1.1 -0.1 1]);
hold on;
x = [ -1 : 0.2 : -0.2 0.2 : 0.2 : 1 ];
for i = 1 : length(x)
    y = a * x(i)^2;
    m  = tan( pi / 2 - 2 * atan( 2 * a * x(i) ) );
    plot(x(i)*[1 1],[y 1],'r-');
    plot([ x(i) 0 ],[ y y + m * x(i) ],'r-');
end
hold off;
