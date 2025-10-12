function sig_rauschbandbreite
% Rauschbandbreite eines Blackman-Fensters der Laenge 256
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

N = 256;
w = blackman_window(N);
nbw = N * w * w.' / sum(w)^2;
fprintf(1,'Blackman(256): NBW / RBW = %g\n',nbw);
