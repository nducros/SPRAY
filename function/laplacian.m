function L = laplacian(Px,Py)
%% ========================================================================
%
%
%
% Input:
%       Px      - number of grid points in the x-direction;
%       Py      - number of grid points in the y-direction;
%
% Outputs:
%       L       - Laplacian (sparse matrix)
%
% Example:
%       >> L = laplacian(10,12);
%       
% Other m-files required:
% Subfunctions: none
% MAT-files required: gradientMat.m
%
% See also: gradientMat.m, priorRegul, gradRegul.m, hessRegul.m
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

% forward gradient matrix
G = gradientMat(Px,Py);

% Laplacian as backward gradient of forward gradient
L = G'*G;

end