function [Gx,Gy] = gradientMat2(Px,Py)
%% ========================================================================
% Compute the discrete gradients along the first and second directions
% -------------------------------------------------------------------------
%
% Input:
%       Px      - number of pixels along the x-axis;
%       Py      - number of pixels along the y-axis;
%
% Outputs:
%       Gx      - discrete gradient along the x-axis (sparse matrix)
%       Gy      - discrete gradient along the y-axis (sparse matrix)
%
% Example:
%       >> [Gx, Gy] = gradientMat2(10,12);
%       
% Other m-files required: none
% MAT-files required: none
%
% See also: gradientMat.m, laplacian.m, priorRegul, gradRegul.m, hessRegul.m
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

%-- 1D discrete gradient in the x-direction ;
ex = ones(Px,1);
Gx_1D = spdiags([-ex ex], [0 1], Px, Px);
Gx_1D(Px, Px) = 0;    % apply mirror boundary conditions

%-- 1D discrete gradient in the y-direction ;
ey = ones(Py,1);
Gy_1D = spdiags([-ey ey], [0 1], Py, Py);
Gy_1D(Py, Py) = 0;    % apply mirror boundary conditions

%-- 2D discrete gradient on a regular grid ;
Gx = kron(speye(Py), Gx_1D); % along x
Gy = kron(Gy_1D, speye(Px)); % along y

end