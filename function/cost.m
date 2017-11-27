function TMP = cost(A, FWD, REC, alpha)
%%=========================================================================
% Define the cost function to minimise
% -------------------------------------------------------------------------
% Inputs:
%    FWD     struct      Forward structure (see dataStruture.m)
%       > Required fields: S
%    REC     struct      Reconstruction structure (see dataStruture.m)
%       > Required fields: D, N0, T, (W), dim 
%    A       [MP x  1]   Projected mass density
%    alpha   [1 x 1]     Regularization parameter
%
% Outputs: 
%    TMP     struct      Temporary forward structure (see dataStruture.m)
%       > Created fields: R, fidelity, prior, cost
% -------------------------------------------------------------------------      
% m-files required: valRegul.m
% MAT-files required: none
%
% See also: dataStruture.m, recon_GN.m, valRegul.m, fwd.m
% -------------------------------------------------------------------------
% Author:       N. Ducros 
% Institution:  University of Lyon, Creatis Laboratory
% Email:        nicolas.ducros@creatis.insa-lyon.fr
% Web:          https://www.creatis.insa-lyon.fr/~ducros/WebPage/spectral_ct.html
% Date:         June 2015
% Last update:  1st May 2017
% Version:      1.0
%%======================================================================== 

%% Compute forward model at A
TMP = fwd(A, REC);

%% Compute residuals at A
if isfield(REC,'W')
    TMP.R = (FWD.S - TMP.S).*REC.W ;   % weigthed residuals
else
    TMP.R = FWD.S - TMP.S;             % residuals
end

%% Compute objective function at A
TMP.fidelity = norm(TMP.R(:))^2;
TMP.prior    = valRegul(A(:), REC); 
TMP.cost     = TMP.fidelity + alpha*TMP.prior;

end