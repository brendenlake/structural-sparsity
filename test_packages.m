%
% Check whether or not the required packages are installed.
% Returns true if they are all installed.
%
function ready = test_packages()

    fprintf(1,'Checking if packages are installed...\n');

    %% Checking for lightspeed toolbox
    has_ls = (exist('mvnormpdfln','file') == 2) && ...
        (exist('inv_posdef','file') == 2);
    if has_ls
       fprintf(1,'  PASSED: Lightspeed toolbox is in path.\n');
    else
       fprintf(1,'  FAILED: Lightspeed toolbox is NOT in path.\n'); 
    end

    %% Checking for PQN Optimizer
    has_pqn =  (exist('minConF_PQN','file') == 2);
    if has_pqn
       fprintf(1,'  PASSED: PQN optimizer is in path.\n');
    else
       fprintf(1,'  FAILED: PQN optimizer is NOT in path.\n'); 
    end
    
    %% Checking all subfolders are added
    has_ss =  (exist('grandscore','file') == 2);
    if has_ss
       fprintf(1,'  PASSED: structural_sparsity (and subfolders)\n    are in path.\n');
    else
       fprintf(1,'  FAILED: structural_sparsity (and subfolders)\n    are NOT in path.\n'); 
    end

    %% Checking for neato from graphviz
    [s,o] = system('which neato');
    has_neato = s==0;
    if has_neato
       fprintf(1,'  PASSED: neato (graphviz) is installed. \n');
    else
       fprintf(1,'  FAILED: neato (graphviz) is NOT installed. \n');
       fprintf(1,'   Program can proceed, but graphs cannot be visualized. \n');
    end

    
    ready = has_ls && has_pqn && has_ss;
    
    if ~ready
         fprintf(1,'See the README for more information\n');
    end
    fprintf(1,'\n');