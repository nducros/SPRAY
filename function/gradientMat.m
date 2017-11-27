function G = gradientMat(Px,Py)
%% ========================================================================
%
%
%
% Input:
%       Px      - number of grid points in the x-direction;
%       Py      - number of grid points in the y-direction;
%
% Outputs:
%       G       - discrete forward gradient (sparse matrix)
%
% Example:
%       >> G = gradientMat(10,12);
%       
% Other m-files required:
% Subfunctions: none
% MAT-files required: none
%
% See also: recon_GN.m, laplacian.m
%
% Author:       N. Ducros 
% Institution:  INSA de Lyon/Creatis
% Date:         Apr-2014
% Last update:  17-Apr-2014
%% ========================================================================

%-- 1D discrete gradient in the x-direction ;
ex = ones(Px,1);
Gxx = spdiags([-ex ex], [0 1], Px, Px); 
Gxx(Px, Px) = 0;    % apply mirror boundary condition

%-- 1D discrete gradient in the y-direction ;
ey = ones(Py,1);
Gyy = spdiags([-ey ey], [0 1], Py, Py);
Gyy(Py, Py) = 0;    % apply mirror boundary condition

%-- 2D discrete gradient on a regular grid ;
G = [kron(speye(Py),Gxx); kron(Gyy,speye(Px))] ;


end