Spectral X-ray Image Reconstruction Toolbox (SPRAY), Version 1.0, 1st June 2017.

-------------------
General Description 
-------------------
The SPRAY toolbox consists of a set of funtions written in Matlab for nonlinear image reconstruction in spectral X-ray imaging. 

In particular, SPRAY 1.0 performs material decomposition of projection images acquired by a photon counting detector. It implements the regularised weighted least square Gauss Newton algorithm described in [1]. Different types of functional can be chosen to regularise the material images.

-------------------
Installation
------------------- 
Unzip 'SPRAY_1.0.zip'. That's it! You can now run the script 'main.m'.

-------------------
Toolbox requirement 
-------------------
No external toolbox is required.

Note that Spray 1.0 includes a modified version of toastLineSearch.m, a function of the toast++ suite (http://web4.cs.ucl.ac.uk/research/vis/toast/).
 
-------------------
Content of SPRAY 1.0
-------------------  
The package comprises:
* main.m: a main script that reproduces the results presented in [1]. It loads the projections of a realistic thorax phantom and performs material decomposition.
* ./function/: A folder that contains the functions called in the main script. Running the main script automatically adds the function folder to the Matlab search path. The dependencies of the functions are described in ./function/dependencies.txt
* ./data/: A folder that contains five different datasets (matfile) that can be processed by main_RWLSGN_dev.m. See './data/Readme.txt' for more information concerning the datasets.
* ./reference/: A folder that contains the full text of [1].

-------------------
Data Struture
------------------- 
Spray 1.0 relies on a specific data struture. Simply type 'help dataStructure' in the command window to get relevant information.

-------------------
Contact 
-------------------
nicolas.ducros@insa-lyon.fr, University of Lyon, Creatis Laboratory, France.

-------------------
Licence 
-------------------
SPRAY 1.0 is distributed under the Creative Commons Attribution-ShareAlike 4.0 International license (CC-BY-SA 4.0) http://creativecommons.org/licenses/by-sa/4.0/

-------------------
Reference
-------------------
If you use the SPRAY toolbox in your work, please reference it with the following citation:

[1] N Ducros et al., Regularization of Nonlinear Decomposition of Spectral X-ray Projection Images, Medical Physics, 2017.
http://dx.doi.org/10.1002/mp.12283