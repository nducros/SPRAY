function dp = dpsiRegul(x, t, mu)
%% ========================================================================
% Return the first derivative, evaluated at point x, of a potential 
% function specified by t and mu 
% =========================================================================
%
% Input:
%       x	[P x 1]   Image
%		t	string	  Type of regularization potential among
%				 	     - 'TK' : Tikhonov
%				 		 - 'PH' : Pseudo-Huber
%				 		 - 'MS' : Minimum suport	
%		mu	[P x 1]	  Hyperparameter of the potential
%
% Outputs:
%       dp 	[P x 1]   First derivative of potential evaluated at x
%
% Examples:
%       >> dp = dpsiRegul(x, 'TK');
%       >> dp = dpsiRegul(x, 'PH', 0.01);
%
% Other m-files required: none
% MAT-files required: none
%
% See also: gradRegul.m, psiRegul.m, ddpsiRegul.m
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
switch t
	case 'TK'	% Tikhonov
		dp = 2*x;
	case 'PH'	% Pseudo-Huber
		dp = x./sqrt(x.^2+ mu^2);
	case 'MS' 	% Minimum support
		dp = 2*mu*x./(x.^2+ mu).^2;
end 