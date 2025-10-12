function ueb_raumwinkel
% Darstellung des Raumwinkels mit Hilfe eine Einheitskugel
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

x = -1:0.01:0;
z = sqrt( 1 - x.^2 );

figure(1);
plot3([0 0],[0 -1],[0 0],'b-');
hold on;
plot3([0 0],[0 0],[0 1],'b-');
for phi = 10:10:90
    c = x .* exp( j * pi * phi / 180 );
    x1 = real( c );
    y1 = imag( c );
    plot3(x1,y1,z,'b-');
end
for theta = 10:10:90
    r = sin( pi * theta / 180 );
    z = cos( pi * theta / 180 );
    c = r * exp( j * pi * (10:90) / 180 );
    x1 = real( c );
    y1 = imag( c );
    plot3(-x1,-y1,z*ones(1,length(x1)),'b-');
end
hold off;
axis equal;
set(gca,'CameraPosition',[2 -10 5]);
grid on;
