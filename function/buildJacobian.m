function TMP = buildJacobian(TMP, REC)
%% ========================================================================
% Create Jacobian matrix
% NB: Make sure TMP.N has been updated, typically using cost.m or fwd.m
% -------------------------------------------------------------------------
%
% Syntax:
%    >> TMP = cost(myImage, FWD, REC, 0.1);  
%    >> TMP = buildJacobian(TMP, REC);
%
% Inputs: 
%    TMP     struct        Temporary forward structure (see dataStruture.m)
%    > Required fields: N, (ii), (jj), (S)
%    REC     struct         Reconstruction structure (see dataStruture.m)
%    > Required fields: dim, D, T, (W)
%
% Outputs: 
%    TMP     struct        Temporary forward structure (see dataStruture.m)
%    > Created fields: D_m, J, dim
%    > Modified fields: none
%       
% m-files required: knon.m
% MAT-files required: none
%
% See also: cost.m, dataStruture.m, fwd.m
% -------------------------------------------------------------------------
% Author:       N. Ducros 
% Institution:  University of Lyon, Creatis Laboratory
% Email:        nicolas.ducros@creatis.insa-lyon.fr
% Web:          https://www.creatis.insa-lyon.fr/~ducros/WebPage/spectral_ct.html
% Date:         June 2015
% Last update:  27 April 2017
% Version:      1.0
%%=========================================================================

%==========================================================================
%% INIT
%==========================================================================
if not(isfield(TMP, 'J'))   
    % Jacobian dimensions
    TMP.dim.m = REC.dim.I*REC.dim.P;                % number of rows
    TMP.dim.n = REC.dim.M*REC.dim.P;                % number of columns
    TMP.dim.nzmax = REC.dim.I*REC.dim.M*REC.dim.P;  % number of non-zero entries
    
    % Non-zero entry indices (tricky: probably some more elegant implementation!)
    TMP.J = kron(speye(REC.dim.P),ones(REC.dim.I,REC.dim.M));
    [TMP.ii, TMP.jj] = find(TMP.J);
    %
    %figure; spy(TMP.J) ;
end
%==========================================================================
%% MAIN
%==========================================================================
%-- Init full submatrix ---------------------------------------------------
J_ipm = zeros(REC.dim.I,REC.dim.P,REC.dim.M);

%-- Build full submatrix --------------------------------------------------
for mm = 1:REC.dim.M
    % Multiplication of each row of D by the mth column of T
    TMP.D_m = REC.D.*repmat(REC.T(:,mm)',REC.dim.I,1);

    % Full submatrix
    J_ipm(:,:,mm) = TMP.D_m*TMP.N;
    
    % Weighting
    if isfield(REC,'W')
        J_ipm(:,:,mm) = J_ipm(:,:,mm).*REC.W;
    end
end

%-- Maps full submatrix to sparse jacobian matrix -------------------------
J_ipm = permute(J_ipm,[1 3 2]);
TMP.J = - sparse(TMP.ii,TMP.jj,J_ipm(:),TMP.dim.m,TMP.dim.n,TMP.dim.nzmax);

%% END