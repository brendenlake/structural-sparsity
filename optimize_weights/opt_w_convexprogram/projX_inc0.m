% Project onto non-negativity constraint.
% Don't allow sigma to get below (.01) instead of strictly positive
function X=projX_inc0(X)
    neg = X<=0+eps;
    X(neg)=0;
    if X(1) < .01
        X(1) = .01;
    end
end