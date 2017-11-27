function REC = defaultREC(REC)
%% ========================================================================
%  Set default values for the fields of a reconstruction structure  
% =========================================================================
% Syntax:
%       >> REC = defaultREC(REC);
%
% Inputs:
%    REC, Reconstruction structure
%       > Fields required: none
%
%    REC, Reconstruction structure
%       > Fields created: param, plot, save
%
%
% -------------------------------------------------------------------------       
% m-files required: none
% MAT-files required: none
%
% See also: initREC.m, recon_GN.m
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
   
%==========================================================================
%% Decomposition parameters
%==========================================================================
itrMax = 150;
minStep = 0.01;
costTol = 0.001;

% no REC.stop
if not(isfield(REC.param,'stop')) || isempty(REC.param.stop)
    REC.param.stop.costTol = costTol; 
    REC.param.stop.itrMax  = itrMax;
    REC.param.stop.minStep = minStep;   
else 
% no REC.param.stop.itrMax
if not(isfield(REC.param.stop,'itrMax')) || isempty(REC.param.stop.itrMax)
    REC.param.stop.itrMax  = itrMax; end
% no REC.param.stop.stepMin
if not(isfield(REC.param.stop,'stepMin')) || isempty(REC.param.stop.stepMin)
    REC.param.stop.minStep  = minStep; end
% no REC.param.stop.costTol
if not(isfield(REC.param.stop,'costTol')) || isempty(REC.param.stop.costTol)
    REC.param.stop.costTol = costTol; end
end

%
if not(isfield(REC.param, 'alpha')),       REC.param.alpha = 1;             end
if not(isfield(REC.param, 'mu')),          REC.param.mu = 0.01;             end
if not(isfield(REC.param, 'restart')),     REC.param.restart = 'ON';       end
%==========================================================================
%% Saving Options --------------------------------------------------------
%==========================================================================
if not(isfield(REC, 'save')) || not(isfield(REC.save, 'a_k'))
    REC.save.a_k = 'OFF';
end
%==========================================================================
%% Plotting Options ------------------------------------------------------
%==========================================================================
a_k      = 'ON_Top';      
a_k_diff = 'OFF';         
prior_k  = 'OFF';         
fidelity_k = 'OFF';         
a_true   = 'OFF';         
%n_out    = 'OFF';         
%n_in     = 'OFF';

%-- no REC.plot -----------------------------------------------------------
if not(isfield(REC,'plot')) || isempty(REC.plot)
    REC.plot.a_k      = a_k;      
    REC.plot.a_k_diff = a_k_diff;         
    REC.plot.prior_k  = prior_k;         
    REC.plot.fidelity_k = fidelity_k;         
    REC.plot.a_true   = a_true;         
    %REC.plot.n_out    = n_out;         
    %REC.plot.n_in     = n_in;
else
if not(isfield(REC.plot,'a_k')) || isempty(REC.plot.a_k)
    REC.plot.a_k      = a_k;                                            end
if not(isfield(REC.plot,'a_k_diff')) || isempty(REC.plot.a_k_diff)
    REC.plot.a_k_diff = a_k_diff;                                       end
if not(isfield(REC.plot,'prior_k')) || isempty(REC.plot.prior_k)
    REC.plot.prior_k  = prior_k;                                        end
if not(isfield(REC.plot,'fidelity_k')) || isempty(REC.plot.fidelity_k)         
    REC.plot.fidelity_k = fidelity_k;                                       end
if not(isfield(REC.plot,'a_true')) || isempty(REC.plot.a_true)         
    REC.plot.a_true   = a_true;                                         end
% if not(isfield(REC.plot,'n_out')) || isempty(REC.plot.n_out)         
%     REC.plot.n_out    = n_out;                                          end
% if not(isfield(REC.plot,'n_in')) || isempty(REC.plot.n_in)         
%     REC.plot.n_in     = n_in;                                           end
end
