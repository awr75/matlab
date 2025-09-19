function varargout = hellempf(lambda)

% Funktion hellempfindlichkeitsgrad.m
% Datenwerte für den spektralen Hellempfindlichkeitsgrad V(lambda)
% (aus Ebert. Phys. Taschenbuch, Vieweg. Seite 257)
% lambda_int ist der Eingabewert (Wellenlänge in Nanometern)
% Aufruf der Tagfunktion mit a = hellempf(lambda)
% Aufruf der Tag- und Nachtfunktion mit [a, b] = hellempf(lambda)s

lambda = lambda(:)';
lambda_break1 = 380; lambda_break2 = 780;
m1 = find(lambda < lambda_break1); m2 = find(lambda > lambda_break2);

if lambda(m1) < 380
   error('Wellenlänge muss im Bereich 380 <= lambda <= 780 liegen')
elseif  lambda(m2) > 780
   error('Wellenlänge muss im Bereich 380 <= lambda <= 780 liegen')
end

lambda_1=[380
390
400
410
420
430
440
450
460
470
480
490
500
510
520
530
540
550
560
570
580
590
600
610
620
630
640
650
660
670
680
690
700
710
720
730
740
750
760
770
780
]';

V_lambda=[0.0000
0.0001
0.0004
0.0012
0.0040
0.0116
0.023
0.038
0.060
0.091
0.139
0.208
0.323
0.503
0.710
0.862
0.954
0.995
0.995
0.952
0.870
0.757
0.631
0.503
0.381
0.265
0.175
0.107
0.061
0.032
0.017
0.0082
0.0041
0.0021
0.00105
0.00052
0.00025
0.00012
0.00006
0.00003
0.000015
]';

V_lambda_nacht=[0.000589
0.002209
0.00929
0.03484
0.0966
0.1998
0.3281
0.455
0.567
0.676
0.793
0.904
0.982
0.997
0.935
0.811
0.650
0.481
0.3288
0.2076
0.1212
0.0655
0.03315
0.01593
0.00737
0.00335
0.00197
0.000677
0.0003129
0.0001480
0.0000715
0.00003533
0.00001780
0.00000914
0.00000478
0.000002546
0.000001379
0.000000760
0.000000425
0.000000241
0.000000139
]';

% Spline-Interpolation zur Glättung
V_lambda_int = spline(lambda_1, V_lambda, lambda);
V_lambda_nacht_int = spline(lambda_1, V_lambda_nacht, lambda);

varargout{1} = V_lambda_int;
varargout{2} = V_lambda_nacht_int;


