classdef filePicker
    methods (Static)
        function pathToFile = getSource(name)
            if(isstring(name) || ischar(name))
                pathToFile = uigetdir(pwd, ("pick location of " + name));
                if isequal(pathToFile, 0)
                    dlgAns = questdlg('Quit?', 'warning', 'Quit', 'Retry', 'Retry');
                    if(isequal(dlgAns, 'Retry'))
                        pathToFile = spctrnWrp.filePicker.getSource(name);
                    else
                        error("no selection was made!");
                    end
                end
                if ~exist(fullfile(pathToFile, name), 'file')
                    dlgAns = questdlg(['File "' name '" not found'], 'warning', 'Cancel', 'Retry', 'Retry');
                    if(isequal(dlgAns, 'Retry'))
                        pathToFile = spctrnWrp.filePicker.getSource(name);
                    else
                        error("no selection was made!");
                    end
                end
            end
        end
    end
end

