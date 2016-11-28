% Make the Y matrix positive definite.
% Return: P, which is the positive definite version.
% 
% If it is already positive definite, do nothing.
% Add "add" to the diagonal, in addition to the smallest eigenvalue.
function [P,me] = make_posdef(Y,add,nomsg)
    me = nan;
    if nargin < 2
        add=1e-3;
    end
    if nargin <3
        nomsg = false; 
    end
    n = size(Y,1);
    myeig = eig(Y);
    myeig_imag = imag(myeig);
    assert(sum(myeig_imag)==0);
    if ~all(myeig>0)
       me = min(myeig);
       if ~nomsg
        fprintf(1,'Matrix not positive def. by %d\n',me);
       end
       P = Y + eye(n)*(abs(me)+add);
    else
       P = Y; 
    end
end