%
% Test code.
%  From a synthetic dataset, extract
%  the right partition structure. Then just test
%  the connection search algorithm to recover
%  the structure.
%

% Parameters
data_fn = 'synth_tree'; % dataset from data/ folder
bool_hugedata = false;

% Load the data
load(data_fn);
X.W_allowed = logical(X.W_allowed);
[n,m] = size(data);
data = rescale_data_missing(data);

% Set up the regularization
beta = 6;

% Extract attachment matrix from X
nclust = size(X.W,1)-n;
isclust = [false(n,1); true(nclust,1)];
W_allowed_oc = X.W_allowed(~isclust,isclust);
Cinput = zeros(n,1);
for o=1:n
   [t,Cinput(o)] = find(W_allowed_oc(o,:));
end

% Build a search format model of ground truth
XM = search_init_model(data,names,beta);
XM.ci = Cinput;
XM = search_clear_edges(XM);
nclust = size(X.W,1)-n;
XM = search_inv_makeW(XM,X.W,X.W_allowed,X.sigma);

% Initialize the recovery model
M = search_init_model(data,names,beta);
sparam = search_init_search(bool_hugedata);
M.ci = XM.ci;

% Do we initialize attachment weights at optimum?
% M.wi = XM.wi;
M.wi = zeros(size(M.ci));

% Do structure learning
M = search_clear_edges(M);
M = search_learn_structure(M,sparam,'clean_restarts',true);
R = make_adj(M);

% Display result comparison
displayS(X,names);
displayS(R,names);

if isequal(X.W_allowed,R.W_allowed)
   fprintf(1,'Sparsity pattern recovered\n\n'); 
else
   fprintf(1,'Sparsity pattern NOT recovered\n\n');  
end

fprintf(1,'Original\n');
XM = search_learn_parameters(XM);
XM = search_try_perturb_parameters(XM);
X = make_adj(XM);
scoreX = grandscore(X,data,beta,'verbose',true,'miss_info',M.miss_info);

fprintf(1,'\nRecovered\n');
scoreR = grandscore(R,data,beta,'verbose',true,'miss_info',M.miss_info);

fprintf(1,'\n');
fprintf(1,'Score for original : %s\n',num2str(scoreX,5));
fprintf(1,'Score for recovered: %s\n',num2str(scoreR,5));