% Delete duplicate rows or columns in a matrix.
% Entries labeled nan do not disqualify comparisons.
%
% Input
%   A: candidate matrix
%   dim: dimension to search (must be 1 (delete duplicate rows) or 2 (delete columns))
%   
% Output
%   A: output matrix
function A = delete_duplicate(A,dim)

    if dim>2
       error('Dim must be 1 or 2'); 
    end
    
    deleted = true;
    while deleted
        [A,deleted] = helper_delete_duplicate(A,dim);
    end
end

% Deletes the first repeated vector it finds and quits
function [A,deleted] = helper_delete_duplicate(A,dim)
    
    deleted = false;
    n = size(A,dim);
    for i=1:n
        for j=i+1:n
            
            % Rows
            if dim==1
                m1 = A(i,:);
                m2 = A(j,:);
                bnan1 = isnan(m1);
                bnan2 = isnan(m2);
                                
                if isequal(m1(~bnan1),m2(~bnan2)) && isequal(bnan1,bnan2)
                   A(j,:)=[];
                   deleted = true;
                   return
                end
                
            % Columns
            else
                m1 = A(:,i);
                m2 = A(:,j);
                bnan1 = isnan(m1);
                bnan2 = isnan(m2);
                
                if isequal(m1(~bnan1),m2(~bnan2)) && isequal(bnan1,bnan2)
                   A(:,j)=[];
                   deleted = true;
                   return
                end
            end
                   
        end
    end
end