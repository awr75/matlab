function h_i = interpolator_8(delta)
% h_i = interpolator_8(delta)
%
% Koeffizienten eines 8-Punkt-Farrow-Interpolators
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

if (delta < 0) || (delta > 1)
    error('Ungueltige Verschiebung');
end
d_i = delta .^ ( 0 : 4 );
c_i = [ 0 -0.02584  0.01427  0.02964 -0.01807 ;
        0  0.16286 -0.12615 -0.13032  0.09361 ;
        0 -0.70773  0.89228 -0.0051  -0.17945 ;
        1 -0.16034 -1.58857  0.64541  0.1035  ;
        0  0.98724  0.96867 -1.05941  0.1035  ;
        0 -0.34374 -0.19971  0.72289 -0.17945 ;
        0  0.10595  0.04457 -0.24413  0.09361 ;
        0 -0.01933 -0.00524  0.04265 -0.01807 ].';
h_i = d_i * c_i;
