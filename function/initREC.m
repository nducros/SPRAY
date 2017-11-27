function REC = initREC(REC, FWD)
%% ========================================================================
% Create and initialise the output fields of a reconstruction structure  
% =========================================================================
% Syntax:
%       >> REC = initREC(REC, FWD);
%
% Inputs:
%    REC, Reconstruction structure
%       > Fields required: dim, param.alpha, param.stop.itrMax
%    FWD, Forward structure
%       > Fields required: dim, (A)
%
%    REC, Reconstruction structure
%       > Fields created: iter, final, A
%
%
% -------------------------------------------------------------------------       
% m-files required: none
% MAT-files required: none
%
% See also: defaultREC.m, recon_GN.m
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

%-- Init dimensions from forward structure --------------------------------
REC.dim.I  = FWD.dim.I;
REC.dim.J  = FWD.dim.J;
REC.dim.Px = FWD.dim.Px;
REC.dim.Py = FWD.dim.Py;
REC.dim.P  = FWD.dim.P;
REC.dim.Q  = length(REC.param.alpha);

%-- Init dimensions from reconstruction structure -------------------------
REC.dim.M =  length(REC.mat);

%-- Reorder fields --------------------------------------------------------
REC = orderfields(REC,{'mat','A0','D','N0','T','W','dim','param','plot','save'});

%-- Init Iteration metrics ------------------------------------------------
REC.iter.cost     = zeros(REC.dim.Q, REC.param.stop.itrMax);
REC.iter.costConv = zeros(REC.dim.Q, REC.param.stop.itrMax);
if isfield(FWD, 'A'), REC.iter.error_m = zeros(REC.dim.Q, 1, REC.dim.M);   end
REC.iter.fidelity = zeros(REC.dim.Q, REC.param.stop.itrMax);
REC.iter.prior    = zeros(REC.dim.Q, REC.param.stop.itrMax);
REC.iter.step     = zeros(REC.dim.Q, REC.param.stop.itrMax);

%-- Init final solution metrics -------------------------------------------
REC.final.cost     = zeros(REC.dim.Q,1);
if isfield(FWD, 'A'), REC.final.error = zeros(REC.dim.Q,1);   end
REC.final.flag = cell(REC.dim.Q,1);
REC.final.fidelity = zeros(REC.dim.Q,1);
REC.final.itrNum   = zeros(REC.dim.Q,1);
REC.final.prior    = zeros(REC.dim.Q,1);

% solutions
REC.A = cell(REC.dim.Q,1);

 end