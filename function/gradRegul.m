function g = gradRegul(A, REC)
%% ========================================================================
% Compute the gradient of the regulariser
% =========================================================================
% Syntax:
%       >> g = gradRegul(A, REC);
%
% Inputs:
%    A     [MP x  1]   Projected mass density
%    REC   struct      Reconstruction structure (see dataStruture.m)
%    > Required fields: dim, param
%
% Outputs:
%    g     [MP x 1]    Gradient of the regulariser 
%
%       
% Other m-files required: dpsiRegul.m, laplacian.m, gradientMat2
% MAT-files required: none
%
% See also: dataStructure.m, dpsiRegul.m, laplacian.m, gradientMat2
%
% -------------------------------------------------------------------------
% Author:       N. Ducros 
% Institution:  University of Lyon, Creatis Laboratory
% Email:        nicolas.ducros@creatis.insa-lyon.fr
% Web:          https://www.creatis.insa-lyon.fr/~ducros/WebPage/spectral_ct.html
% Date:         June 2015
% Last update:  27 April 2017
% Version:      Spray 1.0
%% ======================================================================== 

% NB: Use regular expression matching to simplify this part!
% > expression = '\+';
% > splitStr = regexp(str,expression,'split');


%% REC.param.eps needs to be a 1xM cell (use fake eps for 'TK')

g   = zeros(REC.dim.P, REC.dim.M);
g_m = zeros(REC.dim.P, 1);

for mm = 1:REC.dim.M

    % Extract projected mass density of the m-th material
    A_m = A(mm:REC.dim.M:end);   
    % Prior on material #m
    switch REC.param.reg{mm}
        %----------------------------------------------------------------------
        case  {'TK0','PH0','MS0'}
            g_m = dpsiRegul(A_m, REC.param.reg{mm}(1:2), REC.param.eps{mm});
        %----------------------------------------------------------------------
        case  {'TK1','PH1','MS1'}
            [Dx,Dy] = gradientMat2(REC.dim.Px,REC.dim.Py);
            g_x = Dx*A_m; % gradient along x
            g_y = Dy*A_m; % gradient along y
            g_m = (Dx')*dpsiRegul(g_x, REC.param.reg{mm}(1:2), REC.param.eps{mm}) + ...
                 (Dy')*dpsiRegul(g_y, REC.param.reg{mm}(1:2), REC.param.eps{mm});
        %----------------------------------------------------------------------
        case  {'TK2','PH2','MS2'}		
            L = laplacian(REC.dim.Px, REC.dim.Py);
            g_m = L*A_m;
            g_m = dpsiRegul(g_m, REC.param.reg{mm}(1:2), REC.param.eps{mm});
            g_m = L'*g_m;
    end
    % Build the mixed-functional gradient vector
    g(:,mm) = REC.param.beta(mm)*g_m;
end 
g = g';
g = g(:);

end