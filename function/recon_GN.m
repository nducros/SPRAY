function [REC, FWD, TMP] = recon_GN(REC, FWD)
%%=========================================================================
% Compute projected mass densities using a regularized weighted least 
% squares Gauss-Newton algorithm.
%
% For details, see "N Ducros et al., Regularization of Nonlinear 
% Decomposition of Spectral X-ray Projection Images, Medical Physics, 2017".
% ------------------------------------------------------------------------- 
% Syntax:
%    >> [REC, FWD, TMP] = recon_GN(REC, FWD);
%
% Input: 
%    FWD   struct   Forward structure (see dataStruture.m)
%       > Required fields: dim, D, N0, S
%    REC   struct   Reconstruction structure (see dataStruture.m)
%       > Required fields: A0, T, (W), dim, param, plot, save
%
% Outputs: 
%    REC   struct   Reconstruction structure (see dataStruture.m)
%       > Modified fields: none 
%       > Created fields: iter, final, A
%
%       
% Other m-files required: buildJacobian.m, fwd.m, gradRegul.m, hessRegul.m,
% initGNplot.m, plotGNplot.m
% MAT-files required: none
%
% -------------------------------------------------------------------------
% Author:       N. Ducros 
% Institution:  University of Lyon, Creatis Laboratory
% Email:        nicolas.ducros@creatis.insa-lyon.fr
% Web:          https://www.creatis.insa-lyon.fr/~ducros/WebPage/spectral_ct.html
% Date:         June-2015
% Last update:  01-June-2017
% Version:      1.0
%%=========================================================================

%==========================================================================
%%                            MAIN LOOP         
%==========================================================================
%== Loop throught the set of regularization parameters ====================
for aa = 1:length(REC.param.alpha)
    
    %== Init ============================================================== 
    % initial guess
    if strcmpi(REC.param.restart,'ON')|| aa == 1, A = initGNsol(REC); end
  
    % stopping criteria
    step     = 1;       % step length in the search direction
    costConv = 1;       % decrease of cost function in percentage
    itr      = 0;       % number of iteration

    % current regularization parameter
    alpha = REC.param.alpha(aa);

    % Create figures to plot during iterations, as specified in REC.plot
    initGNplot(REC);
    
    %== Gauss Newton loop =================================================
    while itr  <= REC.param.stop.itrMax && ...
          step > REC.param.stop.stepMin &&  ...
          costConv > REC.param.stop.costTol
      
        %-- Save iterates -------------------------------------------------
        if strcmpi(REC.save.a_k, 'ON'), REC.A_k{itr+1} = A;         end
     
        %-- Forward at current iterate -----------------------------------   
        TMP = cost(A, FWD, REC, alpha);
        %
        fprintf('%d: cost function =  %10.5g; fidelity = %10.5g; prior = %10.5g\n',...
                 itr, TMP.cost, TMP.fidelity, TMP.prior);    
        % Plots
        plotGNplot(FWD, REC, TMP, A, alpha, itr);

        %-- Update Jacobian matrix ----------------------------------------
        disp('   +++ Updating Jacobian matrix'); tic;
        TMP = buildJacobian(TMP, REC);
        fprintf('   '); toc;
             
        %-- Gradient of the fidelity term ---------------------------------
        r = TMP.J'*TMP.R(:);

        %-- Gradient of regularizer ---------------------------------------
        g_reg  = gradRegul(A, REC);

        %-- Hessian of regularizer ---------------------------------------- 
        H_reg = hessRegul(A, REC);

        %-- (opposite of the) gradient of the objective function ----------
        g = r - alpha*g_reg;   
        
        %-- Direction of increment ----------------------------------------          
        disp('   +++ Traditional Gauss-Newton inversion'); tic;
        dA = (TMP.J'*TMP.J + alpha*H_reg)\g;
        fprintf('   '); toc;

        %-- Step ----------------------------------------------------------
        disp('   +++ STEP: line search'); tic;
        [step, costn] = toastLineSearch(A, dA, 1, TMP.cost, ...
                        @(x)cost(x, FWD, REC, alpha)); 
        fprintf('   '); toc;                                
        fprintf('   step = %d\n', step);
        
        %-- Gauss Newton update -------------------------------------------
        A = A + dA*step; 

        %-- Convergence criteria ------------------------------------------
        fprintf('   costConv = %f\n', costConv);
        costConv = 1-costn/TMP.cost;   % decrease in percentage
               
        %-- Store metrics of the current iterate --------------------------
        itr = itr+1;    % Number of iteration for next loop
        %
        REC.iter.fidelity(aa,itr)  = TMP.fidelity;
        REC.iter.prior(aa,itr)     = TMP.prior;
        REC.iter.cost(aa,itr)      = TMP.cost;
        REC.iter.costConv(aa, itr) = costConv;
        tmpA = reshape(A,REC.dim.M,REC.dim.P);
        for mm = 1:REC.dim.M
            REC.iter.error_m(aa,itr,mm) = norm(FWD.A(mm,:) - tmpA(mm,:)) / norm(FWD.A(mm,:));
        end
        REC.iter.step(aa,itr)      = step;
        
        % Save iterate
        if strcmpi(REC.save.a_k, 'ON'), REC.A_k{itr+1} = A; end
    end
    
    %== Store solution and metrics ========================================
    REC.A{aa} = A;    
    % Store metrics of solution
    REC.final.fidelity(aa) = TMP.fidelity;
    REC.final.prior(aa)    = TMP.prior;
    REC.final.cost(aa)     = TMP.cost;
    REC.final.itrNum(aa)    = itr;
    if isfield(FWD, 'A')
        REC.final.error(aa) = sum(squeeze(REC.iter.error_m(aa,itr,:)));
    end

    %== Store stopping criteria flags =====================================
    if(step < 0)
        REC.final.flag{aa} = 'stepNeg';
    elseif(isnan(step))
        REC.final.flag{aa} = 'stepNaN';
    elseif(isnan(costn))
        REC.final.flag{aa} = 'costNaN';
    elseif(step < REC.param.stop.stepMin)
        REC.final.flag{aa} = 'stepMinReached';
    elseif(costConv < REC.param.stop.costTol)
        REC.final.flag{aa} = 'costTolReached';
    elseif( itr >= REC.param.stop.itrMax )
        REC.final.flag{aa} = 'itrMaxReached';
    end
    
    fprintf('---\n%d: cost function =  %10.5g; fidelity = %10.5g; prior = %10.5g\n---\n\n',...
            itr, TMP.cost, TMP.fidelity, TMP.prior);
    
    %== Plots =============================================================
    plotGNplot(FWD, REC, TMP, A, alpha, itr);

end

%-- Removing trailing zeros -----------------------------------------------
REC.iter.cost     = REC.iter.cost(:,1:max(REC.final.itrNum(:)));
REC.iter.costConv = REC.iter.costConv(:,1:max(REC.final.itrNum(:)));
REC.iter.fidelity = REC.iter.fidelity(:,1:max(REC.final.itrNum(:)));
REC.iter.prior    = REC.iter.prior(:,1:max(REC.final.itrNum(:)));
REC.iter.step     = REC.iter.step(:,1:max(REC.final.itrNum(:)));
if isfield(FWD, 'A')
    REC.iter.error_m = REC.iter.error_m(:, 1:max(REC.final.itrNum(:)), :);  
end


