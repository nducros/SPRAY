function plotCost_k(REC)
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
% Author:       T. Hohweiller
% Institution:  INSA de Lyon/Creatis
% Date:         March-2016
% Last update:  22-March-2016
%% ========================================================================

semilogy(1:size(REC.iter.cost,2),REC.iter.cost ,'Marker','.', 'MarkerSize',16); 
xlabel('$k$',  'Interpreter', 'Latex','FontSize',16);
ylabel('Cost Function')

%-- Legend ---------------------------------------------------------------- 
leg = {};
for ii = 1:size(REC.param.alpha,1)
    leg{ii} = ['alpha =', num2str(REC.param.alpha(ii))];
end

%
legend(leg);

end

