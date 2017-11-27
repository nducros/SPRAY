function v = valRegul(A,REC)
%% ========================================================================
% Return the value of the regulariser at point A
%========================================================================
% Inputs:
%    A       [MP x  1]     Projected mass density
%    REC      struct       Reconstruction structure
%       > Required fields: dim, param 
%   
% Outputs: 
%     v      [1 x 1]       Value of the regulariser at point A
% -------------------------------------------------------------------------        
% m-files required: priorRegul.m
% MAT-files required: none
%
% See also: fwd.m, priorRegul.m
%
% -------------------------------------------------------------------------
% Author:       N. Ducros 
% Institution:  University of Lyon, Creatis Laboratory
% Email:        nicolas.ducros@creatis.insa-lyon.fr
% Web:          https://www.creatis.insa-lyon.fr/~ducros/WebPage/spectral_ct.html
% Date:         June 2015
% Last update:  27 April 2017
% Version:      Spray 1.0
%%======================================================================== 

p = priorRegul(A, REC);
v = sum(p,1);

end