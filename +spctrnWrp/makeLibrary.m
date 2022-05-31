% Integration of the C++ DLL AaroniaRTSAAPI.dll
% This script creates an interface for MATLAB to use the aaronia interface

% Might not work while this folder is a MATLAB package 

%% Step 1: Identify C++ Lib Files
libpath = 'C:\Users\steiner\source\repos\spctrnWrp\x64\Release';
headerPath = 'C:\Users\steiner\source\repos\spctrnWrp\spctrnWrp';
includePath = {'C:\Program Files\Aaronia AG\Aaronia RTSA-Suite PRO' 'C:\Program Files\Aaronia AG\Aaronia RTSA-Suite PRO\sdk' libpath};
headerName = 'spctrnWrp.h';
libName = 'spctrnWrp.lib';
interfaceName = 'spctrnWrp';
s = pathsep;

% Generate Lib Definition
clibgen.generateLibraryDefinition(fullfile(headerPath, headerName),...
    'Libraries', fullfile(libpath, libName),...
    'PackageName', interfaceName,...
    'IncludePath', includePath,...
    'ReturnCArrays', true,...
    'Verbose', true);

%% Step 2: Edit definespctrnWrp.mlx and build
% This Part has to be done manually!
% The <SIZE> parameter of every handle needs to be 1.
% The <MLTYPE> parameter of const wchar_t* arguments needs to be 'string'.
% The <SIZE> parameter of each 'string' needs to be 'nullTerminated'.
% The Direction parameter should be 'input'.
% use 'summary(definespctrnWrp)' to test definition
% use 'build(definespctrnWrp)' to generate lib interface
%
% In Order to keep building upon the existing Code it is adwised to add
% further functions at the end of the defining header/lib files of spctrnWrp
% and to copy the working functions from the older definespctrnWrp.mlx
% file to the new one!
% It is important to make a backup of the working Files in case something
% goes wrong.
% To enable the reuse of clibgen.generateLibraryDefinition the definition
% files as well as the interface-DLL need to be deleted (renamed).
% That is: 
%(1) ./definespctrnWrp.mlx 
%(2) ./definespctrnWrp.m
%(3) ./spctrnWrp/spctrnWrpInterface.dll
%

%% Step 3: Add dll location to runtime path
% This needs to be done to resolve the "Unable to load interface library error"



