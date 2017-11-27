function ddp = ddpsiRegul(x, t, mu)
%% ========================================================================
% Return the second derivative, evaluated at point x, of a potential 
% function specified by t and mu 
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
%       ddp [P x 1]   Second derivative of potential evaluated at x
%
% Examples:
%       >> ddp = ddpsiRegul(x, 'TK');
%       >> ddp = ddpsiRegul(x, 'PH', 0.01);
%       
% Other m-files required: none
% MAT-files required: none
%
% See also: hessReg.m, psiRegul.m, dpsiRegul.m
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
		ddp = 2*ones(size(x));
	case 'PH'	% Pseudo-Huber
		ddp = mu^2*(x.^2+ mu^2).^-1.5;
	case 'MS' 	% Minimum support (non convex)
		ddp = 2*mu*(mu - 3*x.*x)./(x.^2+ mu).^3;
end 