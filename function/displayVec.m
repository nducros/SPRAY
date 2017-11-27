function displayVec(FWD, A, myTitle)
%% ========================================================================
% Plot vector containing multi-material images
% =========================================================================
% Syntax:
%       >> displayVec(FWD, A)
%
% Input:
%    FWD, Forward or Reconstruction structure
%       > Required fields: dim
%    A          [KP x 1]    Multiple images (e.g. projected mass densities)
%    myTitle    {K x 1}     Image title (e.g. materials)  
%
% Outputs: none
%
% Other m-files required: none
% MAT-files required: none
%
% See also: initGNplot.m
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

%%
% default
if nargin ==2
    L = FWD.dim.M;
    titleCell = FWD.mat;
% from input argument
elseif nargin ==3
    L = length(myTitle);
    titleCell = myTitle;
end

for mm=1:L
    %
    subplot(1,L,mm)
    imagesc(reshape(A(mm,:),FWD.dim.Px, FWD.dim.Py));
    colorbar;
    colormap gray;
    axis image;
    title(titleCell{mm});
end

return