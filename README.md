# SpectranMatlabInterface

This is a MATLAB interface for the AaroniaRTSAAPI for the Spectran V6, which is included in the installation of the "RTSA-Suit PRO" since Version 1.5.152.8795.

It is made up of a wrapper dll, that is easier to include into matlab using the clibgen functionallity of MATLAB. 
It makes it possible to use the spectran inside a MATLAB workspace in a MATLAB friendly way, by trying to abstract away from using USB-Packets 
and dealing with MATLAB arrays and the *.mat file format for the storage of measurment data.
Inside MATLAB all functions are included in the "spctrnWrp" package where all "user-functions" are methods of one class called api 
(see the help text for this class for more information) which are supported by the other conten of the package e.g. classes containing constants 
with descriptive names for better understanding of the api.
#

If you want to further build upon this api, or fix a bug, you can do this on multiple levels by:

* Changing the Matlab code contained in the "spctrnWrp" package
* Changing the implementation of the "spctrnWrp.dll" functions, which can be found in the "src" folder inside the VS-Project folder of the same name in ".\src\spctrnWrp\spctrnWrp\spctrnWrp.cpp".
* Implementing new functions for the "spctrnWrp.dll". When doing so, the Matlab Interface has to be rebuild (this is not the case if only the implementation changes but the function signature stays the same). More information on how this is done can be found in ".\+spctrnWrp\makeLibrary".
		
#
The dll wrapper can also be used without MATLAB.
