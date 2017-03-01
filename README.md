
# AutoSeg
A Matlab implementation for automatic segmentation with a graphical user interface.

## Installation
AutoSeg can run on all major operating systems. In each, AutoSeg can be installed either through a web installer or the user has to download the MATLAB runtime manually first, install it, and then execute the file in the corresponding folder. Please clone this entire project as the first step.

### Windows 
- option 1: execute the [Windows_installer.exe](Windows_installer.exe) file which will download the appropriate MATLAB runtime on its own and install the software as a program. Then just start the AutoSeg.
- option 2: first download [MATLAB runtime v9.1]( https://de.mathworks.com/supportfiles/downloads/R2016b/deployment_files/R2016b/installers/win64/MCR_R2016b_win64_installer.exe) then execute [AutoSeg.exe](Windows/AutoSeg.exe).

### Linux
- option 1: execute the [Linux_installer.install](Linux_installer.install) file which will download the appropriate MATLAB runtime on its own and install the software as a program. Then just start the AutoSeg.
- option 2: first download [MATLAB runtime v9.1](https://de.mathworks.com/supportfiles/downloads/R2016b/deployment_files/R2016b/installers/glnxa64/MCR_R2016b_glnxa64_installer.zip) and install it. Then execute the following in a command shell: 
```
cd Linux
./run_AutoSeg.sh 'PATH-TO-THE-INSTALL-DIR-OF-MATLAB-RUNTIME'
```
with PATH-TO-THE-INSTALL-DIR-OF-MATLAB-RUNTIME being the folder in which the MATLAB runtime has been installed to including the folder with the version name. For example: 
```
./run_AutoSeg.sh /usr/local/MATLAB/MATLAB_Runtime/v91
```

### Max OSX
- option 1: execute the [Mac_installer.app](Mac_installer.app) file which will download the appropriate MATLAB runtime on its own and install the software as a program. Then just start the AutoSeg.
- option 2: first download [MATLAB runtime v9.1]( https://de.mathworks.com/supportfiles/downloads/R2016b/deployment_files/R2016b/installers/maci64/MCR_R2016b_maci64_installer.dmg.zip) and install it. Then execute [AutoSeg.app](Mac/AutoSeg.app).

