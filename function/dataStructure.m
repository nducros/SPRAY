function dataStructure
%%======================================================================== 
% A forward Structure is a Matlab structure containing the simulation 
% parameters in agreement with the notations introduced in "N Ducros et al., 
% Regularization of Nonlinear Decomposition of Spectral X-ray Projection 
% Images, Medical Physics, 2017."
%--------------------------------------------------------------------------
% Forward Structure
%--------------------------------------------------------------------------
% dim.I      [1 x 1]        Number of (detector) output energy bins
% dim.J      [1 x 1]        Number of input energy bins
% dim.M      [1 x 1]        Number of basis functions (materials)
% dim.Px     [1 x 1]        Number of pixels along the x-axis
% dim.Py     [1 x 1]        Number of pixels along the y-axis
% dim.P      [1 x 1]        Number of pixels in total
% mat        {1 x M}        Basis functions (materials) labels
% A          [M x P]        Projected mass density
% D          [I x J]        Detector response function
% E          [1 x J]        Input energy
% Mu         [Px x Py x J]  Projected linear attenuation coefficient
% N0         [J x 1]        Source spectrum
% S          [I x P]        Photon counts
% S_mean     [I x P]        Photon counts (mean value)
% T          [J x M]        Mass attenuation of basis functions (materials)
%--------------------------------------------------------------------------
%
% A temporary forward structure is a Matlab structure containing the 
% fields described below
%%--------------------------------------------------------------------------
% Temporary forward structure
%--------------------------------------------------------------------------
% dim.m      [1 x 1]        Number of rows of Jacobian
% dim.n      [1 x 1]        Number of columns of Jacobian
% dim.nzmax  [1 x 1]        number of non-zero entries of Jacobian
% D_m        [I x J]        Jacobian integration kernel of the m-th material
% J          [IP x MP]      Jacobian (sparse) matrix
% N          [J x 1]        Number of photons incident on detector
% R          [I x P]        Photon count residuals
% S          [I x P]        Photon counts
% cost       [1 x 1]        Cost function value 
% fidelity   [1 x 1]        Fidelity term value
% prior      [1 x 1]        Regularisation value
%--------------------------------------------------------------------------
%
% A reconstruction structure is a Matlab structure containing the 
% decomposition parameters and results as described below
%--------------------------------------------------------------------------
% Reconstruction Structure
%--------------------------------------------------------------------------
% mat             {1 x M}   Basis functions (materials) labels
% A0              [M x 1]   Projected mass density initial guess (uniform images)
% D               [I x J]   Detector response function
% N0              [J x 1]   Source spectrum
% T               [J x M]   Mass attenuation of basis functions (materials)
% W               [I x P]   Weighting matrix (data fidelity term)
% dim.I           [1 x 1]   Number of output (detector) energy bins
% dim.J           [1 x 1]   Number of input energy bins
% dim.M           [1 x 1]   Number of basis functions (materials)
% dim.Px          [1 x 1]   Number of pixels along the x-axis
% dim.Py          [1 x 1]   Number of pixels along the y-axis
% dim.P           [1 x 1]   Number of pixels in total
% dim.Q           [1 x 1]   Number of global regularisation parameters
% param.reg       {1 x M}   Labels defining material regularization functionals
% param.eps       {1 x M}   Hyperparameters of material regularization functionals 
% param.beta      [1 x M]   Regularisation parameters
% param.restart   string    Choice of initial guess for multiple regularisation parameters
% param.version   [1 x 1]   Toolbox version
% param.stop.stepMin  [1 x 1]   Minimum step length 
% param.stop.itrMax   [1 x 1]   Maximun iteration number
% param.stop.costTol  [1 x 1]   Minimum cost function decrease (in %)
% param.alpha         [Q x 1]    Global regularisation parameter
% plot.a_k        string    plot projected mass density, iteratively
% plot.a_k_diff   string    plot decomposition error, iteratively
% plot.n_out      string    plot number of photons incident on detector
% plot.fidelity_k string    plot fidelity, iteratively
% plot.prior_k    string    plot regularization priors, iteratively
% save.a_k        string    save all iterations of projected mass densities
% iter.cost      [Q x ?]    Cost function for all regularisation parameters and iterations
% iter.costConv  [Q x ? ]   Cost function decreas for all regularisation parameters and iterations
% iter.error_m   [Q x ? x M]  Decomposition error for all regularisation parameters and iterations
% iter.fidelity  [Q x ?]    Fidelity term for all regularisation parameters and iterations
% iter.prior     [Q x ?]    Regularisation term for all regularisation parameters and iterations
% iter.step      [Q x ?]    Step length for all regularisation parameters and iterations
% final.cost     [Q x 1]    Cost function for all regularisation parameters
% final.error    [Q x 1]    Decomposition error for all regularisation parameters
% final.flag     {Q x 1}    Stopping criterion for all regularisation parameters
% final.fidelity [Q x 1]    Fidelity term for all regularisation parameters
% final.itrNum   [Q x 1]    Number of iterations for all regularisation parameters
% final.prior    [Q x 1]    Regularisation term for all regularisation parameters
% A              {Q x 1}    Decomposed projected mass densities, each of size MP x 1
%--------------------------------------------------------------------------
%       
% Author:       N. Ducros 
% Institution:  University of Lyon, Creatis Laboratory
% Email:        nicolas.ducros@creatis.insa-lyon.fr
% Web:          https://www.creatis.insa-lyon.fr/~ducros/WebPage/spectral_ct.html
% Date:         2015-2017
% Last update:  1st May 2017
% Version:      Spray 1.0
%%======================================================================== 