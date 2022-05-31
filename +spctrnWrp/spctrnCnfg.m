classdef spctrnCnfg
    %(old) SPCTRANCONFIG All Configuration elements of the spectran
    % The Idea is to have all config data stored in a single variable of
    % this class and to change the entire configuration with one method of
    % the main-api class.
    % Enum types can be set as strings or the index in the enumeration (starting with 0)
    % Value MUST be set as integer "int32(index) or int64(index)" for the
    % function to recognize the input as an enum index.
    %
    %spctrnCnfg properties:
    %   main:
    %       centerfreq
    %       refevel
    %       transgain
    %       spanfreq
    %       decimation
    %   device:
    %       tempfancontrol
    %       serial
    %       usbcompression
    %       gaincontrol
    %       loharmonic
    %       outputformat
    %...
     
    properties (GetAccess = public, SetAccess = public)
        main
        device
        calibration
    end
    
    methods
        function obj = spctrnCnfg(device_handle)
            %SPCTRANCONFIG Construct an instance of this class
            %   copy all values from device_handle.
            
            %% MAIN
            % double
            obj.main.centerfreq = spctrnCnfg.getConf(device_handle, "main/centerfreq", "double");
            obj.main.reflevel = spctrnCnfg.getConf(device_handle, "main/reflevel", "double");
            obj.main.transgain = spctrnCnfg.getConf(device_handle, "main/transgain", "double");
            obj.main.spanfreq = spctrnCnfg.getConf(device_handle, "main/spanfreq", "double");
            % enum
            obj.main.decimation = spctrnCnfg.getConf(device_handle, "main/decimation", "string");
            
            
            %% DEVICE
            % string
            obj.device.tempfancontrol = spctrnCnfg.getConf(device_handle, "device/tempfancontrol", "string");
            obj.device.serial = spctrnCnfg.getConf(device_handle, "device/serial", "string");
            % enum
            obj.device.usbcompression = spctrnCnfg.getConf(device_handle, "device/usbcompression", "string");
            obj.device.gaincontrol = spctrnCnfg.getConf(device_handle, "device/gaincontrol", "string");
            obj.device.loharmonic = spctrnCnfg.getConf(device_handle, "device/loharmonic", "string");
            obj.device.outputformat = spctrnCnfg.getConf(device_handle, "device/outputformat", "string");
            obj.device.receiverclock = spctrnCnfg.getConf(device_handle, "device/receiverclock", "string");
            obj.device.receiverchannel = spctrnCnfg.getConf(device_handle, "device/receiverchannel", "string");
            obj.device.receiverchannelsel = spctrnCnfg.getConf(device_handle, "device/receiverchannelsel", "string");
            obj.device.transmittermode = spctrnCnfg.getConf(device_handle, "device/transmittermode", "string");
            obj.device.gpsmode = spctrnCnfg.getConf(device_handle, "device/gpsmode", "string");
            
            % DEVICE/FFT0
            % double
            obj.device.fft0.fftaggregate = spctrnCnfg.getConf(device_handle, "device/fft0/fftaggregate", "double");
            obj.device.fft0.fftsize = spctrnCnfg.getConf(device_handle, "device/fft0/fftsize", "double");
            obj.device.fft0.fftbinsize = spctrnCnfg.getConf(device_handle, "device/fft0/fftbinsize", "double");
            obj.device.fft0.fftstepfreq = spctrnCnfg.getConf(device_handle, "device/fft0/fftstepfreq", "double");
            obj.device.fft0.fftrbwfreq = spctrnCnfg.getConf(device_handle, "device/fft0/fftrbwfreq", "double");
            % enum
            obj.device.fft0.fftmergemode = spctrnCnfg.getConf(device_handle, "device/fft0/fftmergemode", "string");
            obj.device.fft0.fftsizemode = spctrnCnfg.getConf(device_handle, "device/fft0/fftsizemode", "string");
            obj.device.fft0.fftwindow = spctrnCnfg.getConf(device_handle, "device/fft0/fftwindow", "string");
            
            % DEVICE/FFT1
             % double
            obj.device.fft1.fftaggregate = spctrnCnfg.getConf(device_handle, "device/fft1/fftaggregate", "double");
            obj.device.fft1.fftsize = spctrnCnfg.getConf(device_handle, "device/fft1/fftsize", "double");
            obj.device.fft1.fftbinsize = spctrnCnfg.getConf(device_handle, "device/fft1/fftbinsize", "double");
            obj.device.fft1.fftstepfreq = spctrnCnfg.getConf(device_handle, "device/fft1/fftstepfreq", "double");
            obj.device.fft1.fftrbwfreq = spctrnCnfg.getConf(device_handle, "device/fft1/fftrbwfreq", "double");
            % enum
            obj.device.fft1.fftmergemode = spctrnCnfg.getConf(device_handle, "device/fft1/fftmergemode", "string");
            obj.device.fft1.fftsizemode = spctrnCnfg.getConf(device_handle, "device/fft1/fftsizemode", "string");
            obj.device.fft1.fftwindow = spctrnCnfg.getConf(device_handle, "device/fft1/fftwindow", "string");
            
            % DEVICE/GENERATOR
            % double
            obj.device.generator.startfreq = spctrnCnfg.getConf(device_handle, "device/generator/startfreq", "double");
            obj.device.generator.stopfreq = spctrnCnfg.getConf(device_handle, "device/generator/stopfreq", "double");
            obj.device.generator.stepfreq = spctrnCnfg.getConf(device_handle, "device/generator/stepfreq", "double");
            obj.device.generator.offsetfreq = spctrnCnfg.getConf(device_handle, "device/generator/offsetfreq", "double");
            obj.device.generator.duration = spctrnCnfg.getConf(device_handle, "device/generator/duration", "double");
            obj.device.generator.powerramp = spctrnCnfg.getConf(device_handle, "device/generator/powerramp", "double");
            % enum
            obj.device.generator.type = spctrnCnfg.getConf(device_handle, "device/generator/type", "string");
            
            
            %% CALIBRATION
            % double
            obj.calibration.txioffset = spctrnCnfg.getConf(device_handle, "calibration/txioffset", "double");
            obj.calibration.txqoffset = spctrnCnfg.getConf(device_handle, "calibration/txqoffset", "double");
            obj.calibration.txexcent = spctrnCnfg.getConf(device_handle, "calibration/txexcent", "double");
            obj.calibration.txphaseskew = spctrnCnfg.getConf(device_handle, "calibration/txphaseskew", "double");
            % string
            obj.calibration.calibrationreload = spctrnCnfg.getConf(device_handle, "calibration/calibrationreload", "string");
            % enum
            obj.calibration.rffilter = spctrnCnfg.getConf(device_handle, "calibration/rffilter", "string");
            obj.calibration.preamp = spctrnCnfg.getConf(device_handle, "calibration/preamp", "string");
            obj.calibration.rftxfilter = spctrnCnfg.getConf(device_handle, "calibration/rftxfilter", "string");
            obj.calibration.calibrationmode = spctrnCnfg.getConf(device_handle, "calibration/calibrationmode", "string");
        end
        
        function setConfigAll(obj, device_handle)
            spctrnCnfg.setGrp(device_handle, obj, "");
        end
    end
    methods (Access = private, Static)
        function result = getConf(device_handle, name, type)
            % Get Config Value of Element NAME from device_handle
            try
                if find(type == ["enum", "Enum", "int", "int32", "int64"], 1)
                    % Integer type
                    result = clib.spctrnWrp.spctrn_getConfig_i(device_handle,name);
                    if result == -1
                        result = [];
                    end
                elseif find(type == ["double", "float", "single"])
                    % Double type
                    result = clib.spctrnWrp.spctrn_getConfig_d(device_handle, name);
                else
                    % String type is default
                    result = convertCharsToStrings(char(zeros(1,120)));
                    result = clib.spctrnWrp.spctrn_getConfig_s(device_handle, name, result, 120);
                end
            catch
                result = [];
            end
        end
        
        function setConf(device_handle, name, value)
            if find(class(value) == ["int32", "int64"], 1)
                % integer
                res = apiResult(clib.spctrnWrp.spctrn_setConfig_i(device_handle, name, value));
            elseif find(class(value) == ["double", "single"], 1)
                % double
                res = apiResult(clib.spctrnWrp.spctrn_setConfig_d(device_handle, name, value));
            else
                % string / default
                res = apiResult(clib.spctrnWrp.spctrn_setConfig_s(device_handle, name, value));
            end
            if res == apiResult.valueAdjusted
                out = convertCharsToStrings(char(zeros(1,120)));
                out = clib.spctrnWrp.spctrn_getConfig_s(device_handle, name, out, 120);
                warning('SpectranAPI:valueAdjusted', "Value of " + name + " was adjusted to " + out)  
            elseif res == apiResult.empt || apiResult.valueDisabled
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
                if isstruct(X) && isequal(class(S), 'spctrnCnfg')
                    % k'th element is struct
                    spctrnCnfg.setGrp(device_handle, X, fn{k})
                elseif isstruct(X)
                    spctrnCnfg.setGrp(device_handle, X,prefix + "/" + fn{k})
                else
                    % k'th element is no struct
                    spctrnCnfg.setConf(device_handle, prefix + "/" + fn{k}, X)
                end
            end
        end
    end
end

