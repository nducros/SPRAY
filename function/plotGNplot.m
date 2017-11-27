function plotGNplot(FWD, REC, TMP, A, alpha, itr)
%%========================================================================
% Plot figures as specified in REC.plot
% -------------------------------------------------------------------------
% Syntax:
%       >> plotGNplot(FWD, REC, TMP, A, alpha)
%
% Input: 
%    FWD   struct   Forward structure
%       > Required fields: A, S
%    REC   struct   Reconstruction structure
%       > Required fields: dim, param, plot
%    TMP   struct   Forward structure
%       > Required fields: cost, fidelity, prior
%    A       [MP x  1]   Projected mass density
%    alpha   [1 x 1]     Regularization parameter
%
% Outputs: none
%          
% Other m-files required: displayVec.m, myTitleCell.m, priorRegul.m
% Subfunctions: displayVec.m
% MAT-files required: none
%
% See also: initGNplot, recon_GN.m
% -------------------------------------------------------------------------
% Author:       N. Ducros 
% Institution:  University of Lyon, Creatis Laboratory
% Email:        nicolas.ducros@creatis.insa-lyon.fr
% Web:          https://www.creatis.insa-lyon.fr/~ducros/WebPage/spectral_ct.html
% Date:         June-2015
% Last update:  27-April-2017
% Version:      1.0
%%========================================================================


%%  Plot mass of material
switch lower(REC.plot.a_k)
    case 'on_top'
        hMeas = findobj('Tag', 'Rec');
        figure(hMeas(1))
        set(hMeas(1),'Name',['Projected Mass Density -- k = ',num2str(itr)]); clf;
        displayVec(REC,reshape(A,REC.dim.M, REC.dim.P));
        drawnow;

    case 'on_alone'
        figure('Name',['Projected Mass Density -- k = ',num2str(itr)]);
        displayVec(REC,reshape(A,REC.dim.M, REC.dim.P));
        title(myTitleCell(REC,TMP,alpha));
end

%% Plot recon diff in mass of material
switch lower(REC.plot.a_k_diff)
    case 'on_top'
        hMeas = findobj('Tag', 'Diff');
        figure(hMeas(1))
        set(hMeas(1),'Name',['(Ground Truth - Decomp) -- k = ',num2str(itr)]); clf;
        displayVec(REC,FWD.A(1:REC.dim.M,:)-reshape(A,REC.dim.M, REC.dim.P));
        drawnow;

    case 'on_alone'
        figure('Name',['(Ground Truth - Decomp) -- k = ',num2str(itr)]);
        displayVec(REC,FWD.A-100*reshape(A,REC.dim.M, REC.dim.P)./FWD.A);
end

%% Plot prior on material mass
switch lower(REC.plot.prior_k)
    case 'on_top'
        hMeas = findobj('Tag', 'Prior');
        figure(hMeas(1))
        set(hMeas(1),'Name',['Prior -- k = ',num2str(itr)]); clf;
        displayVec(REC, reshape(priorRegul(A,REC),REC.dim.M,REC.dim.P));
        drawnow;
        
    case 'on_alone'
        figure('Name',['Prior -- k = ',num2str(itr)]);
        displayVec(REC, reshape(priorRegul(A,REC),REC.dim.M,REC.dim.P));    
end

%% Data fidelity maps
switch lower(REC.plot.fidelity_k)
    case 'on_top'
        hMeas = findobj('Tag', 'Fidelity');
        figure(hMeas(1))
        set(hMeas(1),'Name',['Fidelity -- k = ',num2str(itr)]); clf;
        displayVec(REC, (FWD.S - TMP.S).^2);
        drawnow;
        
    case 'on_alone'
        figure('Name',['Fidelity -- k = ',num2str(itr)]);
        displayVec(REC, (FWD.S - TMP.S).^2);    
end