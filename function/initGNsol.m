function A  = initGNsol(REC)
%% =======================================================================
% Set the initial guess of an iterative decomposition
% -------------------------------------------------------------------------
% 
% Syntax:
%       >> A  = initGNsol(REC);
%
% Input: 
%    REC   |   struct   |   Reconstruction structure (see dataStruture.m)
%    > Required fields: A0, dim
%
% Outputs:
%    A     | [MP x  1]  |   Projected mass density
%       
%
% Example:
%       >> 
%       
% Other m-files required: none
% MAT-files required: none
%
% See also: dataStruture.m
% -------------------------------------------------------------------------
% Author:       N. Ducros 
% Institution:  University of Lyon, Creatis Laboratory
% Email:        nicolas.ducros@creatis.insa-lyon.fr
% Web:          https://www.creatis.insa-lyon.fr/~ducros/WebPage/spectral_ct.html
% Date:         June 2015
% Last update:  27 April 2017
% Version:      1.0
%%======================================================================== 

%%
% Non-uniform
if prod(size(REC.A0)==[REC.dim.M REC.dim.P])
    disp('++ Non-uniform initial guess');
    A  = REC.A0;

% Uniform
elseif prod(size(REC.A0)==[REC.dim.M 1])
    disp('++ Uniform initial guess');
    A  = diag(REC.A0)*ones(REC.dim.M,REC.dim.P);
    A = A(:); 
end
%
%REC.A  = REC.A(:);