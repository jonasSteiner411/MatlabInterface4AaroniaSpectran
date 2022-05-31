classdef dynamicConfig < dynamicprops
    %DYNAMICCONFIG creating a class instance which includes any
    %configuration element of the given device dynamically.
    %Meaning a change to the configuration elements by Aaronia will not
    %invalidate this class. (Given they will not change the way the configuration tree works)
    %Values representing enumerations indices must explicitly set as
    %integers! int32(value), int64(value) instead of just value.
    %
    %TODO: 1. option to display enum indicies as their respective value ( )
    %      2. method that returns a similar object to the extracted config
    %      tree, but with all options and ranges displayed as strings
    %      instead of values. ( )
    %
    %see also: api, api.getDevice
    methods
        function obj = dynamicConfig(api_handle, idx)
            if ~isequal(class(api_handle), "spctrnWrp.api")
                error('SpectranAPI:invalidarg','API_HANDLE needs to be of type api!')
            end
            if ~isnumeric(idx) || ~isscalar(idx) || ~isequal(idx, floor(idx))
                error('SpectranAPI:invalidarg','IDX must be non-negative integer!')
            end
            
            %use mex interface to populate this class
            spctrnWrp.makeDynConf(obj, api_handle.getDevice(idx));
        end
        
        function setConfigAll(obj, device_handle)
            spctrnWrp.dynamicConfig.setGrp(device_handle, obj, "");
        end
    end
    
    methods (Static)
        function setConf(device_handle, name, value)
            if find(class(value) == ["int32", "int64"], 1)
                % integer
                res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_setConfig_i(device_handle, name, value));
            elseif find(class(value) == ["double", "single"], 1)
                % double
                res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_setConfig_d(device_handle, name, value));
            else
                % string / default
                res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_setConfig_s(device_handle, name, value));
            end
            if res == spctrnWrp.apiResult.valueAdjusted
                out = convertCharsToStrings(char(zeros(1,120)));
                out = clib.spctrnWrp.spctrn_getConfig_s(device_handle, name, out, 120);
                warning('SpectranAPI:valueAdjusted', "Value of " + name + " was adjusted to " + out)
            elseif res == spctrnWrp.apiResult.empt || spctrnWrp.apiResult.valueDisabled
                % Do nothing... the element NAME is disabled
            elseif res
                error("SpectranAPI:" + res.string, "Error setting config " + name + " to " + num2str(value) + " , " + res.string)
            end
        end
        
        function setGrp(device_handle, S, prefix)
            % Set group of configuration elements saved in struct S
            fn = fieldnames(S);
            for k = 1:length(fn)
                X = getfield(S, fn{k}); %#ok<GFLD>
                if isstruct(X) && isequal(class(S), 'spctrnWrp.dynamicConfig')
                    % k'th element is struct
                    spctrnWrp.dynamicConfig.setGrp(device_handle, X, fn{k})
                elseif isstruct(X)
                    spctrnWrp.dynamicConfig.setGrp(device_handle, X,prefix + "/" + fn{k})
                else
                    % k'th element is no struct
                    spctrnWrp.dynamicConfig.setConf(device_handle, prefix + "/" + fn{k}, X)
                end
            end
        end
    end
end
