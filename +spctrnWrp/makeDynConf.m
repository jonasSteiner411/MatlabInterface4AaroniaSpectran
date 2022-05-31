function makeDynConf(obj, device_d)
%MAKEDYNCONF

% if isequal(obj, 'clean')
%     delete('dynamicConfigConstructor.mexw64');
%     return
% end
% 
% if isequal(obj, 'make')
%     defaultSrcLoc = 'src/makeDynConf';
%     if ~exist(fullfile(defaultSrcLoc, 'main.cpp'), 'file')
%         defaultSrcLoc = filePicker.getSource(dllName1);
%     end
%     aaroniaSDKLoc = 'C:\Program Files\Aaronia AG\Aaronia RTSA-Suite PRO\sdk';
%     outputName = 'dynamicConfigConstructor';
%     includes = {['-I' aaroniaSDKLoc], ['-I' defaultSrcLoc]};
%     mex('-DMATLAB', '-output', outputName , includes{:}, fullfile(defaultSrcLoc, 'main.cpp'));
%     return
% end
if ~isequal(class(obj), 'spctrnWrp.dynamicConfig')
    error("SpectranAPI:invalidarg", "OBJ needs to be of class spctrnWrp.dynamicConfig");
end

if ~isequal(class(device_d), 'uint64')
    error("SpectranAPI:invalidarg", "DEVICE_D, use spctrnWrp.api.getDevice");
end

% compile the mex function in the case it does not exist
if(~exist(fullfile(what('spctrnWrp').path, 'dynamicConfigConstructor.mexw64'), 'file'))
    warning("Need to compile function makeDynConf")
    [names, locs] = spctrnWrp.defaultNamesJson('src');
    locMain = -1;
    locHeader = -1;
    for i = 1:numel(names)
        if isequal(names{i}, 'dynamicConfig')
            locMain = i;
        elseif isequal(names{i}, 'aaroniartsaapi.h')
            locHeader = i;
        end
    end
    if locMain < 0 || locHeader < 0
        error("SpectranAPI:corrupteddef", "Default paths file may be corrupted!");
    end
    
    defaultSrcLoc = locs{locMain};
    if ~exist(fullfile(defaultSrcLoc, 'main.cpp'), 'file')
        defaultSrcLoc = spctrnWrp.filePicker.getSource('main.cpp');
    end
    aaroniaSDKLoc = locs{locHeader};
    if ~exist(fullfile(locHeader, names{locHeader}), 'file')
        aaroniaSDKLoc = spctrnWrp.filePicker.getSource(names{locHeader});
    end
    spctrnWrp.defaultNamesJson('src', names, locs);
    
    outputName = 'dynamicConfigConstructor';
    includes = {['-I' aaroniaSDKLoc], ['-I' defaultSrcLoc]};
    mex('-DMATLAB', '-output', outputName , includes{:}, fullfile(defaultSrcLoc, 'main.cpp'))
end

% populate the dynamic config via the mex function
spctrnWrp.dynamicConfigConstructor(device_d, obj);
end

