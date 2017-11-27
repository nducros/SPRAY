function TMP = fwd(A, REC)
%%=========================================================================
% Create a temporary forward structure, with number of photons incident on 
% detecto and photon counts
% -------------------------------------------------------------------------
% Inputs:
%    REC     struct      Reconstruction structure (see dataStruture.m)
%       > Required fields: D, N0, T, (W), dim 
%    A       [MP x  1]   Projected mass density
%
% Outputs: 
%    TMP     struct      Temporary forward structure (see dataStruture.m)
%       > Created fields: N, S
% -------------------------------------------------------------------------      
% m-files required: valRegul.m
% MAT-files required: none
%
% See also: dataStruture.m, recon_GN.m, valRegul.m
% -------------------------------------------------------------------------
% Author:       N. Ducros 
% Institution:  University of Lyon, Creatis Laboratory
% Email:        nicolas.ducros@creatis.insa-lyon.fr
% Web:          https://www.creatis.insa-lyon.fr/~ducros/WebPage/spectral_ct.html
% Date:         June 2015
% Last update:  27 April 2017
% Version:      1.0
%%======================================================================== 

%% -- MAIN ---------------------------------------------------------------- 
% Incident number of photons
A = reshape(A, REC.dim.M, REC.dim.P); % matricization

% Number of photons incident on detector
N = repmat(REC.N0, 1, REC.dim.P);     
TMP.N = N.*exp(-REC.T*A);             % The time-consuming step...

% Detected number of photons
TMP.S = REC.D*TMP.N;

end