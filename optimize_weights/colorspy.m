% Modified function from d'Aspremont, El Ghaoui
% http://www.cmap.polytechnique.fr/~aspremon/CovSelCode.html
%
% Visualize a precision matrix.
%
% Renormalize with mxval if this is given.
%
% Input
%  M: the precision matrix
%  mxval: (optional) renormalize the scaling
%   of the colors pretending this was the maximum. 
%   Useful for plotting two matrices on the same scale.
function mxval=colorspy(M,mxval)

M=-M; % now we are working with partial correlations
M=sign(M).*abs(M).^.7;

if nargin < 2
    mxval = max(max(abs(M)));
end
M(abs(M)>mxval)=sign(M(abs(M)>mxval)).*mxval;
M=M/mxval;

[m,n]=size(M);
CmapM=zeros(m,n,3);

for i=1:m
    for j=1:n
        % If partial correlation is positive (M(i,j) is large),
            % then we crank down the blue and turn up the red to max
            
        % If partial correlation is negative (M(i,j) is small),
            % then we set the blue to max and crank down the red
        CmapM(i,j,:)=[1-max(0,-M(i,j)),1-abs(M(i,j)),1-max(0,M(i,j))];
    end
end
image(CmapM);