function h_i = interpolator_4(delta)
% h_i = interpolator_4(delta)
%
% Koeffizienten eines 4-Punkt-Farrow-Interpolators
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

if (delta < 0) || (delta > 1)
    error('Ungueltige Verschiebung');
end
d_i = delta .^ ( 0 : 3 );
c_i = [ 0 -0.48124  0.70609 -0.22485 ;
        1 -0.33412 -1.31155  0.64567 ;
        0  1.0202   0.62547 -0.64567 ;
        0 -0.25639  0.03154  0.22485 ].';
h_i = d_i * c_i;
