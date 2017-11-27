function p = psiRegul(x, t, mu)
%% ========================================================================
% Return the potential function specified by t and mu evaluated at point x
% =========================================================================
% Input:
%       x	[P x 1]   Image
%		t	string	  Type of regularization potential among
%				 	     - 'TK' : Tikhonov
%				 		 - 'PH' : Pseudo-Huber
%				 		 - 'MS' : Minimum suport	
%		mu	[P x 1]	  Hyperparameter of the potential
%
% Outputs:
%       p   [P x 1]   Regularization potential evaluated at x
%
% Examples:
%       >> p = psiRegul(x, 'TK');
%       >> p = psiRegul(x, 'PH', 0.01);
%       
% m-files required: none
% MAT-files required: none
%
% See also: priorRegul.m, dpsiRegul.m, ddpsiRegul.m
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
		p = x.^2;
	case 'PH'	% Pseudo-Huber
		p = sqrt(x.^2+ mu^2)- mu;
	case 'MS' 	% Minimum support
		p = x.^2./(x.^2+ mu);
end 