function [y,zn] = mexpoly(x,p,q,b,z)
% [y,zn] = mexpoly(x,p,q,b,z)
% 
%   Polyphase FIR filter mit upsampling ratio p and downsampling ratio q.
%   Note: output sample rate = input sample rate * p / q.
% 
%   x  - row vector with input signal (real oder complex)
%   p  - upsampling ratio
%   q  - downsampling ratio
%   b  - row vector with filter coefficients
%   z  - row vector with filter state for stream processing (optional);
%        start with z = [], otherwise length(z) = ceil(length(b) / p)
%   y  - row vector with output signal
%   zn - row vector with updated with filter state for stream processing
%        (optional); length(zn) = ceil(length(b) / p)
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

persistent sys_id;

if isempty(sys_id)
    sys_id = check_system;
end

if nargin == 0
    switch sys_id,
        case 1,
            mexpoly_matlab_32;
        case 2,
            mexpoly_matlab_64;
        case 3,
            mexpoly_octave_32;
        case 4,
            mexpoly_octave_64;
        case 5,
            mexpoly_octave_linux;
        otherwise,
            error('Nicht unterstuetzt');
    end
    return;
end

if nargin < 5
    z = [];
end

switch sys_id,
    case 1,
        [y,zn] = mexpoly_matlab_32(x,p,q,b,z);
    case 2,
        [y,zn] = mexpoly_matlab_64(x,p,q,b,z);
    case 3,
        [y,zn] = mexpoly_octave_32(x,p,q,b,z);
    case 4,
        [y,zn] = mexpoly_octave_64(x,p,q,b,z);
    case 5,
        [y,zn] = mexpoly_octave_linux(x,p,q,b,z);
    otherwise,
        error('Nicht unterstuetzt');
end
