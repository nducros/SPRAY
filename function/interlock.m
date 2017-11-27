function L = interlock(L1, L2)
%% ========================================================================
% Interlock two matrices having consistent dimensions
% =========================================================================
% Syntax:
%       >> L = interlock(L1, L2)
%
% Input:
%       L1      [L x L]   Some matrix 
%       L2      [P x P]   Some matrix with P < L and L = kP, k being a 
%                         natural interger
%
% Outputs:
%       L       [L+P x L+P] L1 and L2 interlocked 
%
% -------------------------------------------------------------------------       
% m-files required: none
% MAT-files required: none
%
% See also: hessRegul.m
%
% -------------------------------------------------------------------------
% Author:       N. Ducros 
% Institution:  University of Lyon, Creatis Laboratory
% Email:        nicolas.ducros@creatis.insa-lyon.fr
% Web:          https://www.creatis.insa-lyon.fr/~ducros/WebPage/spectral_ct.html
% Date:         June 2015
% Last update:  27 April 2017
% Version:      1.0
%% ========================================================================

P11 = size(L1,1);
P12 = size(L1,2);
P21 = size(L2,1);
P22 = size(L2,2);

% Check dimensions are consistent
if not(P11==P12) || not(P21==P22)
    warning('Input matrices must be square');
    return; 
end

if P21 > P11
    warning('First matrix must be larger than the second');
    return; 
end

if rem(max(P11,P21), min(P11,P21))> 0
    warning('Matrix dimentions must be multiple');
    return; 
end
%% ======================================================================== 
% matrix 1
[i1,j1,s1] = find(L1);
% matrix 2
[i2,j2,s2] = find(L2);
% size
k = max(P11/P21, P21/P11);
% Maps indices
i1 = i1 + floor((i1-1)/k);
j1 = j1 + floor((j1-1)/k);
i2 = i2 * (k+1);
j2 = j2 * (k+1);
%
L = sparse(i1,j1,s1,P11+P21,P12+P22) + sparse(i2,j2,s2,P11+P21,P12+P22);
return
