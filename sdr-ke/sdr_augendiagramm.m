function sdr_augendiagramm
% Augendiagramme fuer Raised Cosine Filter
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

r   = [ 0.25 0.33 0.5 1 ];
l_r = length(r);

for i = 1 : l_r
    g = root_raised_cosine_filter( 201, 20 ,r(i) );
    h = conv( g, g );
    h = h / max( h );
    t = ( -10 : 10 ) / 20;
    l_m = length( find( abs( h( 11 : 20 : end ) ) > 0.01 ) ) + 1;
    sym = zeros( 1, l_m );
    figure(i);
    for k = 0 : 2^l_m - 1
        n = k;
        for m = 1 : l_m
            sym(m) = 2 * mod( n , 2 ) - 1;
            n = floor( n / 2 );
        end
        s = [ kron( sym( 1 : end - 1 ), [ 1 zeros(1,19) ] ) sym(end) ];
        x = conv( s, h );
        i_m = ( length(x) + 1 ) / 2;
        plot( t, x( i_m - 10 : i_m + 10 ), 'b-','Linewidth',1);
        hold on;
    end
    hold off;
    axis([ min(t) max(t) -2.05 2.05 ]);
    grid;
    title(sprintf('Augendiagramm fuer Rolloff-Faktor r = %4.2f',r(i)));
end
