function H = hessRegul(A, REC)
%% ========================================================================
% Compute the Hessian matrix of the regulariser 
% =========================================================================
% Syntax:
%       >> H = hessRegul(A, REC);
%
% Inputs:
%    A       [MP x  1]     Projected mass density
%    REC     struct        Reconstruction structure (see dataStruture.m)
%    > Required fields: dim, param
%
% Outputs:
%       H    [MP x MP]     Hessian (sparse) matrix of the regulariser
%
% -------------------------------------------------------------------------       
% m-files required: ddpsiRegul.m, interlock.m, laplacian.m, gradientMat2
% MAT-files required: none
%
% See also: gradRegul.m, dataStructure.m, ddpsiRegul.m, laplacian.m, 
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


%% REC.eps needs to be a 1xM cell (use fake eps for 'TK')

% init
A_m = A(1:REC.dim.M:end);    % material #1
% Prior on material #1
switch REC.param.reg{1}
    %----------------------------------------------------------------------
	case  {'TK0','PH0','MS0'}
        H = spdiags(ddpsiRegul(A_m, REC.param.reg{1}(1:2), REC.param.eps{1}), ...
                     0, REC.dim.P, REC.dim.P);
	%----------------------------------------------------------------------
	case  {'TK1','PH1','MS1'}
		[Dx,Dy] = gradientMat2(REC.dim.Px,REC.dim.Py);
		g_x = Dx*A_m; % gradient along x
		g_y = Dy*A_m; % gradient along y
        %
        Hx = spdiags(ddpsiRegul(g_x, REC.param.reg{1}(1:2), REC.param.eps{1}), ...
                     0, REC.dim.P, REC.dim.P);
        Hy = spdiags(ddpsiRegul(g_y, REC.param.reg{1}(1:2), REC.param.eps{1}), ...
                     0, REC.dim.P, REC.dim.P);     
		H = (Dx')*Hx*Dx + (Dy')*Hy*Dy;
	%----------------------------------------------------------------------
	case  {'TK2','PH2','MS2'}		
        L = laplacian(REC.dim.Px,REC.dim.Py);
        b = L*A_m;
		D = spdiags(ddpsiRegul(b, REC.param.reg{1}(1:2), REC.param.eps{1}),...
                     0, REC.dim.P, REC.dim.P);
        H = (L')*D*L;
end
H = REC.param.beta(1)*H;

for mm = 2:REC.dim.M
    % Extract masses #m
    A_m = A(mm:REC.dim.M:end);   
    % Prior on material #m
    switch REC.param.reg{mm}
    %------------------------------------------------------------------
        case  {'TK0','PH0','MS0'}
        H_m = spdiags(ddpsiRegul(A_m, REC.param.reg{mm}(1:2), REC.param.eps{mm}), ...
                     0, REC.dim.P, REC.dim.P);
    %------------------------------------------------------------------
        case  {'TK1','PH1','MS1'}
        [Dx,Dy] = gradientMat2(REC.dim.Px,REC.dim.Py);
        g_x = Dx*A_m; % gradient along x
        g_y = Dy*A_m; % gradient along y
        %
        Hx = spdiags(ddpsiRegul(g_x, REC.param.reg{mm}(1:2), REC.param.eps{mm}), ...
                     0, REC.dim.P, REC.dim.P);
        Hy = spdiags(ddpsiRegul(g_y, REC.param.reg{mm}(1:2), REC.param.eps{mm}), ...
                     0, REC.dim.P, REC.dim.P);     
        H_m = (Dx')*Hx*Dx + (Dy')*Hy*Dy;
    %------------------------------------------------------------------
    case  {'TK2','PH2','MS2'}		
        L = laplacian(REC.dim.Px,REC.dim.Py);
        b = L*A_m;
        D = spdiags(ddpsiRegul(b, REC.param.reg{mm}(1:2), REC.param.eps{mm}),...
                     0, REC.dim.P, REC.dim.P);
        H_m = (L')*D*L;
    end

% Build the mixed-norm Hessian
H = interlock(H, REC.param.beta(mm)*H_m);
end

end