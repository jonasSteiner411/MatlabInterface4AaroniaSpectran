classdef myGlobal
    properties (Constant)
        filename = 'myGlobals.mat';
    end
    
    methods (Static)
    
        function pathName = getName()
            tempResult = {what('spctrnWrp').path};
            pathName = tempResult{end};
        end
    
        function set(variable, name)
            if exist(fullfile(spctrnWrp.myGlobal.getName(), spctrnWrp.myGlobal.filename), 'file')
                dat = load(fullfile(spctrnWrp.myGlobal.getName(), spctrnWrp.myGlobal.filename)).dat;
            end
            if nargin == 1
                name = inputname(1);
            end
            dat.(name) = variable;
            save(fullfile(spctrnWrp.myGlobal.getName(), spctrnWrp.myGlobal.filename), 'dat');
        end
        
        function variable = get(variableName)
            if ~exist(fullfile(spctrnWrp.myGlobal.getName(), spctrnWrp.myGlobal.filename), 'file')
                error(['No such file :', fullfile(spctrnWrp.myGlobal.getName(), spctrnWrp.myGlobal.filename)]);
            end
            dat = load(fullfile(spctrnWrp.myGlobal.getName(), spctrnWrp.myGlobal.filename)).dat;
            if nargin == 0
                disp(dat);
                return;
            end
            
            if ~(isstring(variableName) || ischar(variableName))
                variableName = inputname(1);
            end
            if ~isfield(dat, variableName)
                error([variableName, ' was not stored as myGlobal!']);
            end
            variable = dat.(variableName);
        end
        
        function clear(variableName)
            if ~exist(fullfile(spctrnWrp.myGlobal.getName(), spctrnWrp.myGlobal.filename), 'file')
                error(['No such file :', fullfile(spctrnWrp.myGlobal.getName(), spctrnWrp.myGlobal.filename)]);
            end
            if ~(isstring(variableName) || ischar(variableName))
                variableName = inputname(1);
            end
            dat = load(fullfile(spctrnWrp.myGlobal.getName(), spctrnWrp.myGlobal.filename)).dat;
            if isequal(variableName, '-all')
                warning("removing all globals.")
                dat = [];
            elseif isfield(dat, variableName)
                dat = rmfield(dat, variableName);
            end
            save(fullfile(spctrnWrp.myGlobal.getName(), spctrnWrp.myGlobal.filename), 'dat');
        end
    end
end
