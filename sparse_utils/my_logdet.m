function y = my_logdet( A )
% log(det(A)) where A is positive-definite.
% This is faster and more stable than using log(det(A)).
% Written by Tom Minka

[U,p] = chol(A);
if p>0
   y=-inf; 
else
   y=2*sum(log(diag(U)));
end