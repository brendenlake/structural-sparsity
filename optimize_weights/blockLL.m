% Compute log-likelihood based on blocked missing patterns
%
% Input
%   data: [ntot x m] ntot objects x m features matrix
%     'inf' in the matrix marks a missing entry
%   E: [ntot x ntot] covariance matrix of model
%   miss_info: pattern of missing data (see function missingpat)
%
%   size(data,1) can be < size(E,1). In this case,
%   the covariance for the latent variables of E
%   are assumed to be at the bottom.
%
% Output
%   ll: log-likelihood
function ll=blockLL(data,E,miss_info)

    if ~exist('miss_info','var')
        miss_info = missingpat(data);
        % fprintf(1,'Warning: Block log-likelihood did not cache\n');
    end

    ll = 0;
    [n,m] = size(data);
    assert(size(E,1)==n);    
    mx = max(miss_info.indx);
    for i=1:mx
        thispat = miss_info.indx==i;
        pres = miss_info.pat(:,i);
        np = sum(pres);
        V = E(pres,pres);
        dat = data(pres,thispat);
        if any(isinf(dat(:)))
           error('Missing pattern on input is wrong'); 
        end
        ls = normpdfln(dat,zeros(np,1),[],V);
        ll = ll + sum(ls);
    end
end