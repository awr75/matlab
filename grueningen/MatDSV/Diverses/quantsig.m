function sigquant = quantsig(sig,wlength,satmode,quantmode)
% Quantizes a signal sig to a word-length of wlength bits
% and limited to the range [-1,1). 
%
% sig:        Vector containing the signal to be quantized
% wlength:    Word-length	
% satmode:    Mode of saturation
%             'sat'       saturation limiter
%             'overfl'    2's complement overflow
%             'triang'    triangle limiter
%             'none'      no limiter
% quantmode:  'floor'     rounds towards minus infinity.
%             'ceil'      rounds towards plus infinity.
%             'fix'       rounds towards zero
%             'round'     rounds towards nearest value
%
% Example 
% -------
% n=0:50; sig=1.1*sin(2*pi*.02*n); 
% sigquant=quantsig(sig,4,'overfl','round'); 
% stem(n,sigquant),pause,close

% ----------------  Nov. 17. 1999 / Ivo Oesch, Daniel von Grünigen  ---------------------
%
%   References:
%     [1] C.S. Burrus, J.H. McClellan, A.V. Oppenheim,
% 			 T.W. Parks, R.W. Schafer, & H.W. Schussler,
%         "Computer-Based Exercises for Signal Processing Using MATLAB"
%         Prentice-Hall, 1994.
%     [2] D.Ch. von Grünigen, "Digitale Signalverarbeitung",
%         Hanser Verlag, 2001, Kapitel 5.
%
% ---------------------------------------------------------------------------------------
%
% Part of software package for the book [2]
% 
% ---------------------------------------------------------------------------------------

maxval = 2^(wlength-1);
sig = sig * maxval;
switch(quantmode)
case 'floor'
   sigquant = floor(sig);
case 'ceil'
   sigquant = ceil(sig);
case 'fix'
   sigquant = fix(sig);
case 'round'
   sigquant = round(sig);
otherwise
   disp('Illegal mode in quantize !!!!');
end

%saturates the signal as given in the rules
switch(satmode)
case 'sat'
   sigquant = min(maxval - 1, sigquant);
   sigquant = max(-maxval, sigquant);
case 'overfl'
   %find minimum value
   minval = min(min(sigquant),0);
   %set whole array in positive range
   sigquant = sigquant + maxval * ( 1 - 2*floor(minval/2/maxval) );
   sigquant = rem(sigquant,2*maxval) - maxval;
case 'triang'
   %find minimum value
   minval = min(min(sigquant),0);
   %set whole array in positive range
   sigquant = sigquant + maxval * ( 1 - 2*floor(minval/2/maxval) );
   sigquant = rem(sigquant,4*maxval) - maxval;
   f = find(sigquant > maxval);
   sigquant(f) = 2*maxval - sigquant(f);
   f = find(sigquant == maxval);
   sigquant(f) = sigquant(f) - 1;
case 'none'
   %do nothing
otherwise
   disp('Illegal mode in fitval !!!!');
end
sigquant = sigquant / maxval;

