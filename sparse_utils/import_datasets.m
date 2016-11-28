% Process datasets by getting the appropriate filename.
% Also, ensure that all the datasets exist so we don't
% hit an error later on.
%
% Input
%   featdata: name of txt file that has list of features datasets to run
%
% Output
%   fns_featdata: cell array of filenames (Feature data)
function fns_featdata = import_datasets(featdata)

% Check that all the feature datasets are valid
fns_featdata = []; 
if exist(featdata,'file')
    fns_featdata = importdata(featdata);
    for i=1:length(fns_featdata)
       fprintf(1,[' ',fns_featdata{i},'\n']);
       fnf = ['data/',fns_featdata{i},'.mat'];
       if ~exist(fnf,'file')
          error(['Feature dataset ',fnf,' not found.']); 
       end
    end
end