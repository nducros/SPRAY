function initGNplot(REC)
%%========================================================================
% Create figures as specified in REC.plot
% ========================================================================
% Syntax:
%    >> initGNplot(REC);
%
% Input: 
%    REC, Reconstruction structure
%       # Required fields: plot
%
% Outputs: none
%       
% Other m-files required: none
% MAT-files required: none
%
% See also: plotGNplot.m, recon_GN.m
%
% Author:       N. Ducros 
% Institution:  University of Lyon, Creatis Laboratory
% Email:        nicolas.ducros@creatis.insa-lyon.fr
% Web:          https://www.creatis.insa-lyon.fr/~ducros/WebPage/spectral_ct.html
% Date:         June-2015
% Last update:  27-April-2017
% Version:      1.0
%%========================================================================


%% -- Mass of material (iterates) -----------------------------------------
if strcmpi(REC.plot.a_k, 'ON_Top')
    figure('Name','Mass of material - k = 0', 'Tag', 'Rec');
end
%% -- Mass of material (diff between ground truth and iterates) -----------
if strcmpi(REC.plot.a_k_diff, 'ON_Top')
    figure('Name','Mass of material (Recon - ground truth) - k = ', 'Tag', 'Diff');
end
%% -- Prior (Iterates) ----------------------------------------------------
if strcmpi(REC.plot.prior_k, 'ON_Top')
    figure('Name','Prior Mass of material - k = 0', 'Tag', 'Prior');
end
%% -- Data fidelity maps --------------------------------------------------
if strcmpi(REC.plot.fidelity_k, 'ON') || strcmpi(REC.plot.fidelity_k, 'ON_Top')
    figure('Name','Data fidelity - k = 0', 'Tag', 'Fidelity');
end