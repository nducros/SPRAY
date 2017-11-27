%%========================================================================
% Main script of Spray 1.0, which reproduces the results published in [1].
%
% Type 'help dataStructure' in the command window to get relevant 
% information on the data structure.
%
% [1] N. Ducros et al., Regularization of Nonlinear Decomposition of 
% Spectral X-ray Projection Images, Medical Physics, 2017.
% -------------------------------------------------------------------------
% Author:       N. Ducros 
% Institution:  University of Lyon, Creatis Laboratory
% Email:        nicolas.ducros@creatis.insa-lyon.fr
% Web:          https://www.creatis.insa-lyon.fr/~ducros/WebPage/spectral_ct.html
% Date:         2017
% Last update:  01-June-2017
% Version:      1.0
%%========================================================================
clear all

%%========================================================================
%% USER-DEFINED
%%========================================================================
%--  Some folders -------------------------------------------      
mainDir = pwd;  % Set you own Spray path :)
resDir  = 'result_tmp';    % Results will be saved in this subfolder
%
saveFig = 'ON';         % 'ON' to save figures
%
% Phantom name (see ./data/ReadMe.txt)
%phantomName =   'thorax_hig_3_cor';
%phantomName =   'thorax_med_3_cor';
%phantomName =   'thorax_low_3_cor';
phantomName =   'thorax_hig_5_cor';
%phantomName =   'thorax_hig_3_sag';
%phantomName =   'thorax_hig_5_sag';

%%========================================================================
%% ADD TOOLBOX TO PATH
%%========================================================================
funDir = 'function'; % Name of function folder

%-- Add function folder to path -------------------------------------------
p = genpath(fullfile(mainDir,funDir,filesep));
addpath(p);
clear('p');

%%========================================================================%
%% LOAD FORWARD MODEL
%%========================================================================%
disp('===================================================================')
disp('Forward model')
disp('===================================================================')
dataDir = 'data';   % Name of function folder

%-- Load simulation parameters --------------------------------------------
load([mainDir, filesep, dataDir, filesep, phantomName]);

%%========================================================================%
%% PLOT FORWARD
%%========================================================================%
%-- Phantom --------------------------------------------------------------%
figure('Name','Phantom');
displayVec(FWD,reshape(FWD.A, FWD.dim.M, FWD.dim.P));

%-- Energy reponses -------------------------------------------------------
figure('Name','Source, Detector, and Mass Attenuations'); 
subplot(311)
plot(FWD.E, FWD.N0)
xlabel('Energy (keV)')
ylabel('Source (ph/s)')
%
subplot(312)
plot(FWD.E, FWD.D)    
ylabel('Detector Response (a.u./s)')
xlabel('Energy (keV)')
%
subplot(313)
semilogy(FWD.E, FWD.T)    
ylabel('Mass Attenuation (a.u./s)')
xlabel('Energy (keV)')
legend('Soft Tissue', 'Bone', 'Gd')

%-- Noisy att from M  ----------------------------------------------------%
figure('Name','Data');
myTitle = {'bin 4','bin 3','bin 2','bin 1'};
displayVec(FWD, log10(FWD.S), myTitle);

input('Press the Return key to continue with material decomposition ');

%%========================================================================%
%% GN reconstruction
%%========================================================================%
%-- Init 3-material reconstruction structure ------------------------------
REC.mat = FWD.mat(:,1:3);
REC.T   = FWD.T(:,1:3);             % in cm-2/g
REC.N0  = FWD.N0;
REC.D   = FWD.D;
REC.A0  = [10 1 0]';                % in g.cm-2
REC.W     = 1./sqrt(FWD.S+1);       % data normalisation

%-- Choice of the regularizers --------------------------------------------
REC.param.reg = {'TK2','TK1','PH1'};    % regularizer for each material
% Each of the cells of REC.param.reg is chosen concatenating two letters 
% ('TK' or 'PH') and a number ('0', '1', or '2'). Letters set the potential
% function (see Eq. 18 of [1]) and numbers set the linear transform L (see 
% Eq. 17 of [1]).
% * 'TK' stands for Tikhonov, i.e., a quadratic potential function
% * 'PH' stands for pseudo-Huber
% * 0 means zero-th order, i.e., L is identity 
% * 1 means first order, i.e., L is a gradient
% * 2 means second order, i.e., L is a Laplacian
%
% Examples:
% 'TK0': Tikhonov, the square of the L2-norm
% 'PH0': pseudo Huber, a smooth approximation of the L1-norm
% 'PH1': first order pseudo Huber, an approximation of total variation

REC.param.eps  = {0, 0, 0.01};  % potential function hyperparameter 
% Only relevant for pseudo-Huber, see psiRegul.m for details

%-- regularization parameters ---------------------------------------------
REC.param.beta = [1 1 1];
REC.param.alpha = 10.^[-1.5 -0.5]';   % Global regularisation parameter

%-- Algorithm parameters --------------------------------------------------
REC.param.meth  = 'GN';           % {'GN', 'N'}
REC.param.step  = 'line search';  % {'line search', 'constant'};
REC.param.stop.stepMin = 0.005;   % Stopping criteria

%-- Saving options --------------------------------------------------------
REC.save.a_k = 'OFF';              % {['OFF'], 'ON'}

%-- Plotting options ------------------------------------------------------
REC.plot.a_k      = 'ON_Top';       % {'ON_Top', 'ON_Alone', 'OFF'}
REC.plot.a_k_diff = 'OFF';          % {'ON_Top', 'ON_Alone', 'OFF'}
REC.plot.prior_k  = 'OFF';          % {'ON_Top', 'ON_Alone', 'OFF'}
REC.plot.fidelity_k = 'ON_top';        % {'ON_Top', 'ON_Alone', 'OFF'}

%-- Gauss-Newton Decomposition --------------------------------------------
disp('===================================================================')
disp('Material decomposition')
disp('===================================================================')
REC = defaultREC(REC);
REC = initREC(REC,FWD);
REC = recon_GN(REC, FWD);

%%========================================================================%
%% PLOT DECOMPOSITION RESULTS
%%========================================================================%
%-- Decomposition error --------------------------------------------------%
figure('Name','Error');                   
plotMatError(REC);

%-- Cost function decrease -----------------------------------------------%
figure('Name','Cost Function = f(itr)');
plotCost_k(REC);

%%========================================================================%
%% SAVE FIGURES 
%%========================================================================%
if strcmp(saveFig, 'ON')
%
folder = fullfile(mainDir, resDir, phantomName, filesep); %
mkdir(folder);

% phantom    
hf = findobj('Name','Phantom');
saveas(hf(1), [folder, 'phantom.fig']);

% source and detector
hf = findobj('Name','Source, Detector, and Mass Attenuations');
saveas(hf(1), [folder, 'source_detector.fig']);

% data
hf = findobj('Name','Data');
saveas(hf(1), [folder,'data.fig']);

% reconstruction mass error
hf = findobj('Name','Error');
saveas(hf(1), [folder,'reconError.fig']);

% cost function
hf = findobj('Name','Cost Function = f(itr)');
saveas(hf(1), [folder,'costItr.fig']);

% decomposed images
hf = findobj('Tag','Rec');
for ii=length(REC.param.alpha):-1:1
    saveas(hf(ii), [folder,'decomposition_', num2str(ii),'.fig']);
end
end

%%========================================================================%
%% SAVE DATA AND CODE
%%========================================================================%
currentFile = [mfilename('fullpath'),'.m'];
copyfile(currentFile, folder);

%-- Saving the REC structure ----------------------------------------------
REC = rmfield(REC,'W');
save([folder, 'recon'], 'REC');

%-- Saving the FWD structure ----------------------------------------------
save([folder, 'forward'], 'FWD');