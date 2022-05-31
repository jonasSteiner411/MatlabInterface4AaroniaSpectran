function [names, locs] = defaultNamesJson(field, namesIn, locsIn)
%DEFAULTNAEMSJSON either gets or sets pairs for names of
%librarys (name) and their respective location (value)
%
%[names, locations] = defaultNamesJson(field)
%   takes name of field in the default names json file and puts out the
%   values of the respective names and locations of files.
%
%defaultNamesJson(field, names, locations)
%   Sets names and locations of given field in json file.

if nargin == 3
    if ~isequal(class(locsIn), 'cell') || ~isequal(class(namesIn), 'cell') || numel(namesIn) ~= numel(locsIn)
        error("Input arguments need to be cell types with same number of elements.")
    end
    fileId = fopen(fullfile(what('spctrnWrp').path, "defaultPaths.json"));
    defaultPaths = jsondecode(char(fread(fileId, inf)'));
    fclose(fileId);
    
    defaultPaths.(field) = cell2struct([namesIn;locsIn], {'libName', 'location'}, 1);
    
    fileId = fopen(fullfile(what('spctrnWrp').path, "defaultPaths.json"), "w");
    str = replace(jsonencode(defaultPaths), "\", "\\");
    str = replace(str, ',', ',\n');
    str = replace(str, '[', '[\n');
    str = replace(str, '{', '{\n');
    str = replace(str, '}', '\n}');
    str = replace(str, ']', '\n]');
    fprintf(fileId, str);
    fclose(fileId);
elseif nargout == 2 && nargin == 1
    fileId = fopen(fullfile(what('spctrnWrp').path, "defaultPaths.json"));
    defaultPaths = jsondecode(char(fread(fileId, inf)'));
    fclose(fileId);

    names = {defaultPaths.(field).libName};
    locs = {defaultPaths.(field).location};
else
    error("Need to specify exactly three input arguments or exactly two output arguments and one input!");
end
end