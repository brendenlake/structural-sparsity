# Structural sparsity

### SUMMARY
The input data is a matrix of objects and features. The structural sparsity model learns a sparse graph to organize the set of objects. The algorithm searches for a graph that explains the features while favoring sparse graph structures. Each graph defines a Gaussian Markov Random Fields with latent variables.

Please cite the following paper:  
Lake, B. M., Lawrence, N. D., and Tenenbaum, J. B. (2016). The emergence of organizing structure in conceptual representation. Preprint available on arXiv.org.

### REQUIREMENTS

Before running the code, you must install the following:

The [Lightspeed toolbox](http://research.microsoft.com/en-us/um/people/minka/software/lightspeed/) from Tom Minka.

[PQN](http://www.cs.ubc.ca/%7Eschmidtm/Software/PQN.html) optimization algorithm from Mark Schmidt, introduced in this paper:  
M. Schmidt, E. van den Berg, M. Friedlander, and K. Murphy (2009). "Optimizing Costly Functions with Simple Constraints: A Limited-Memory Projected Quasi-Newton Algorithm." AISTATS.

[Graphviz](http://www.graphviz.org/) if you you want to visualize the learned graphs.

Also, we recommend using a machine with 4 or more cores. As implemented, the search algorithm evaluates moves in parallel. 

### RUNNING THE CODE

**Setting your path**
The main folders for PQN, lightspeed, and structural sparsity should all be added (along with their subfolders) to your path. For instance, to add the folder "structural_sparsity" please type:

```matlab
cd structural_sparsity
addpath(genpath(pwd));
```

### RUNNING DATA SETS
To run a small set of test experiments, enter this directory and then type:

```matlab
run_small_set
```

To run some of the datasets used in the paper:

```matlab
run_larger_set
```

If GraphViz is installed, these scripts will visualize the progress of the algorithm, as well as the best graph found at the end. Note that at some points, the algorithm may appear to be changing the graph for the worse. This is because it can make up to 5 "bad" moves before terminating, which helps to avoid local optima. At the end, the best structure scored is the one returned.

Please note that these scripts will not necessarily find the exact same graphs as reported in the paper. The algorithm is stochastic, and the default is to run each dataset once. It was run 10 times for the experiments in the paper, and the highest scoring run was chosen.

**Further examining the results**

The results of each run are saved in directories such as: OUT_BETAX, where X is replaced by whatever the beta (sparsity) parameter was. After loading a results file, the best structure found is saved as the variable M.

To convert M to an adjacency graph, type:

```matlab
R  = make_adj(M);
```

The structure R now contains the adjacency matrix. The variable is a structure with the fields...
  * R.W: [n x n scalar] weight matrix for all nodes in the graph (denoted as S in the paper)
  * R.W_allowed [n x n logical] binary matrix for active connections (non-zero elements of W)
  * R.isclust = [n x 1 logical] which nodes are latent clusters?
  * R.sigma = [scalar] variance parameter

The graph can be visualized by typing:

```matlab
displayS(R,names)
```

See the file "viz_graphs/displayS.m" for the different visualization styles.

### TROUBLESHOOTING

Mac OS X: If GraphViz (specifically, the neato program) is installed, but it cannot be found by Matlab, try opening Matlab through the terminal rather than through a shortcut.

If you receive an error message about the wrong number of input or output variables for a function, make sure the structural_sparsity folder is at the top of your path. This is likely a naming conflict with something else in your path.

###  ACKNOWLEDGMENTS

This program incorporates some code written by others.  
I would like to acknowledge:
* function "colorspy" from Alexandre d'Aspremont
* function "checkgrad" from Charles Kemp
* graphviz interface files by Leon Peshkin