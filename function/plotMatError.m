function plotMatError(REC)
%% =======================================================================
%
%
% Syntax:
%       >> 
%
% Input:
%       REC    - reconstruction structure
%
% Outputs:
%       
%
% Example:
%       >> 
%       
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 
%
% Author:       T. Hohweiller, N Ducros
% Institution:  INSA de Lyon/Creatis
% Date:         March-2016
% Last update:  22-June-2016
%% ========================================================================
sizeAlpha = size(REC.param.alpha,1);
maxIter = size(REC.iter.error_m,2);

%-- Plot the reconstruction error for each material -----------------------
for mm = 1:REC.dim.M
    % setup of the data
    % nd : use find(REC.materialMassError(?, ?, ?)>0, 1, 'last')
    tmp = reshape(REC.iter.error_m(:,:,mm),sizeAlpha, maxIter);
    for aa = 1:sizeAlpha
        index = find(tmp(aa,:));
        if(~isempty(index))
            lastNonZero = index(end);
            tmp2(aa) = tmp(aa,lastNonZero);
        else
            tmp2(aa) = tmp(aa,:);
        end
    end
    
    % plot
    loglog(REC.param.alpha,tmp2, 'Marker','.', 'MarkerSize',16);
    hold on;
end

%-- Plot the global reconstruction error ----------------------------------
loglog(REC.param.alpha, REC.final.error, ...
       'Marker','.', 'LineStyle','-.', 'MarkerSize',16);
%
xlabel('$\alpha$', 'Interpreter', 'Latex','FontSize',16);
ylabel('$||a_m - a_m^{true}||_2/||a_m^{true}||_2$', ...
        'Interpreter', 'Latex','FontSize',16);
legend([REC.mat, 'total']);

end


