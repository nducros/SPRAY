function p = priorRegul(x,REC)
%% ========================================================================
% Return the regulariser at point x
% =========================================================================
% Syntax:
%       >> p = priorRegul(x,REC);
%
% Inputs:
%    x       [MP x  1]     Projected mass density
%    REC, Reconstruction structure
%       > Required fields: dim, param
%
% Outputs:
%       p    [MP x 1]      Regulariser at point x
%
% -------------------------------------------------------------------------       
% m-files required: psiRegul.m, laplacian.m, gradientMat2
% MAT-files required: none
%
% See also: gradientMat2.m, dataStructure.m, dpsiRegul.m, laplacian.m, 
% gradientMat2
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

%% REC.param.eps needs to be a 1xM cell (use fake eps for 'TK')
p   = zeros(REC.dim.P, REC.dim.M);
p_m = zeros(REC.dim.P, 1);

for mm = 1:REC.dim.M

    % Extract masses #m
    x_m = x(mm:REC.dim.M:end);   
    % Prior on material #m
    % Prior on material #1
    switch REC.param.reg{mm}
        %----------------------------------------------------------------------
        case  {'TK0','PH0','MS0'}
            p_m = psiRegul(x_m, REC.param.reg{mm}(1:2), REC.param.eps{mm});
        %----------------------------------------------------------------------
        case  {'TK1','PH1','MS1'}
            [Dx,Dy] = gradientMat2(REC.dim.Px,REC.dim.Py);
            p_x = Dx*x_m;
            p_y = Dy*x_m;
            p_m = psiRegul(p_x, REC.param.reg{mm}(1:2), REC.param.eps{mm}) + ...
                 psiRegul(p_y, REC.param.reg{mm}(1:2), REC.param.eps{mm});
        %----------------------------------------------------------------------
        case  {'TK2','PH2','MS2'}		
            L = laplacian(REC.dim.Px,REC.dim.Py);
            p_m = L*x_m;
            p_m = psiRegul(p_m, REC.param.reg{mm}(1:2), REC.param.eps{mm});
    end
    
    % Build the mixed-functional priors
    p(:,mm) = REC.param.beta(mm)*p_m;
end

% Build the mixed-functional priors
p = p';
p = p(:);

end 