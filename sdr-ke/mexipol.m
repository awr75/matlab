function [y,zn] = mexipol(x,u,z)
% [y,zn] = mexipol(x,u,z)
% 
%   Subsampling by interpolation for real-valued subsampling ratios 0 < u < 4;
%   u < 1 performs oversampling:
% 
%   x  - row vector with input signal (real-valued or complex-valued)
%   u  - subsampling factor (0 < u < 4, u < 1 performs oversampling)
%   z  - row vector with the internal state of the interpolator
%   y  - row vector with output signal
%   zn - row vector with the updated internal state of the interpolator
% 
%   WARNING: The subsampling is performed with the help of an 8-point Farrow
%            interpolator which has a relative bandwidth of 0.6 with respect to
%            the input sample rate. The input signal must be filtered to its
%            final bandwidth prior to being resampled with mexipol.
% 
%   There are two typical use cases:
%   a) subsampling of prefiltered signals with 1.5 < u < 4
%   b) resampling with 0.9 < u < 1.1 to slightly modify the sample rate of
%      signals with a relative bandwidth not exceeding 0.6
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
            mexipol_matlab_32;
        case 2,
            mexipol_matlab_64;
        case 3,
            mexipol_octave_32;
        case 4,
            mexipol_octave_64;
        case 5,
            mexipol_octave_linux;
        otherwise,
            error('Nicht unterstuetzt');
    end
    return;
end

if nargin < 3
    z = [];
end

switch sys_id,
    case 1,
        [y,zn] = mexipol_matlab_32(x,u,z);
    case 2,
        [y,zn] = mexipol_matlab_64(x,u,z);
    case 3,
        [y,zn] = mexipol_octave_32(x,u,z);
    case 4,
        [y,zn] = mexipol_octave_64(x,u,z);
    case 5,
        [y,zn] = mexipol_octave_linux(x,u,z);
    otherwise,
        error('Nicht unterstuetzt');
end
