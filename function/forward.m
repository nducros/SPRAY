function FWD = forward(FWD)
%%========================================================================
% Compute photon counts
% ------------------------------------------------------------------------
% Syntax:
%    >> FWD = forward(FWD);  
%
% Input: 
%    FWD     struct      Forward structure (see dataStruture.m)
%       > Required fields: FWD.dim.I, FWD.dim.J, FWD.D, FWD.Mu, FWD.N0
%
% Outputs: 
%    FWD     struct      Forward structure (see dataStruture.m)
%       > Modified fields: none 
%       > Created fields: FWD.S
%
% -------------------------------------------------------------------------      
% Other m-files required: none
% MAT-files required: none
% 
% See also: dataStruture.m
% -------------------------------------------------------------------------
% Author:       N. Ducros 
% Institution:  University of Lyon, Creatis Laboratory
% Email:        nicolas.ducros@creatis.insa-lyon.fr
% Web:          https://www.creatis.insa-lyon.fr/~ducros/WebPage/spectral_ct.html
% Date:         June 2015
% Last update:  27 April 2017
% Version:      Spray 1.0
%%======================================================================== 

%% MAIN
% Sensitivity matrix
D0 = (repmat(FWD.N0', FWD.dim.I, 1).*FWD.D);
% Predicted numbers of counts
FWD.S = D0*exp(-reshape(FWD.Mu,[],FWD.dim.J)');

end