classdef api < handle
    %API Class containing all api functionality to interface with the
    %   spectran V6 via Matlab
    %
    %api methods:
    %   api               - Open api interface.
    %   openDevice        - Open device handle.
    %   closeDevice       - Close device handle.
    %   setConfig         - Set value of configuration element.
    %   setConfigEnum     - Set enum index of configuration element.
    %   getConfigD        - Get double value of configuration element.
    %   getConfigS        - Get string value of configuration element.
    %   getConfigEnum     - Get enum index of configuration element.
    %   getConfigTree     - Get all configuration elements as tree structure.
    %   setConfigTree     - Set all configuration elements as tree structure.
    %   getConfigOptions  - Returns semicolon seperated list of enumeration options.
    %   startDevice       - Start open device.
    %   stopDevice        - Stop device.
    %   getPacket         - Get a packet from the packet queue.
    %   sendPacket        - Send a previously filled packet to the spectran transmitter.
    %   getData           - Save specified amount of samples to mat file.
    %   sendData          - Send a matrix of iq data to the spectran transmitter.
    %   transceiveData    - Send IQ-samples to be played while also recording samples.
    %   getAvailPackets   - Get the amount of available packets.
    %   consumePackets    - Remove a certain amount of packets from queue.
    %   getHandle         - Returns handle pointer as uint64.
    %   getDevice         - Returns pointer as uint64 of specified device.
    %   delete            - Delete api interface handle.
    %
    %api properties:
    %   deviceHandles   - Cell array of all open Device handles.
    %
    %see also: apiResult, apiMemory, deviceChannels, deviceTypes,
    %spctrnCnfg, dynamicConfig, configExplained
    
    properties(SetAccess = private)
        deviceHandles cell;
    end
    
    properties(Access = private, Constant)
        packetSize int64 = 122; % might change later
    end
    
    methods (Access = public)
        function obj = api(memorySize)
            %SPECTRANAPI Construct an instance of this class
            %   initialize the api and set the api handle.
            %   memorySize should be of class apiMemory
            %
            %[obj] = api(memorySize)
            %
            %input arguments:
            %   memorySize - size of usb data queue.
            %
            %output arguments:
            %   obj        - api interface handle.
            %
            % see also: apiMemory
            
            % Argument handling
            narginchk(1,1);
            if ~isnumeric(memorySize) || ~isscalar(memorySize)
                error('SpectranAPI:invalidarg','MEMORYSIZE needs to be numeric, scalar value!')
            end
            if ~isequal(class(memorySize), 'spctrnWrp.apiMemory')
                warning('SpectranAPI:invalidarg', 'MEMORYSIZE should be of class spctrnWrp.apiMemory!')
                memorySize = spctrnWrp.apiMemory(memorySize);
            end
            
            % Keep track of initialisations
            counter = 0;
            try
                counter = spctrnWrp.myGlobal.get(counter);
            catch
            end
            counter = counter + 1;
            spctrnWrp.myGlobal.set(counter);
            
            % Code
            try
                res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_init(uint32(memorySize)));
                if res
                    error("SpectranAPI:" + res.string, "Initialisation went wrong, " + res.string)
                end
            catch ME
                
                % Catch DLL-Load error
                if startsWith(ME.identifier, "SpectranAPI:")
                    if endsWith(ME.identifier, "errorAlreadyInitiallised")
                        warning("Already initiallised!")
                        return;
                    else
                        throw(ME);
                    end
                end
                
                % Try finding libraries at default locations
                [libNames, libLocations] = spctrnWrp.defaultNamesJson('dll');
                for i = 1:numel(libNames)
                    if ~exist(fullfile(libLocations{i}, libNames{i}), 'file')
                        warning("Cannot find " + libNames{i})
                        libLocations{i} = spctrnWrp.filePicker.getSource(libNames{i});
                    end
                    
                    sysPath = getenv('PATH');
                    setenv('PATH', [libLocations{i} pathsep sysPath]);
                    if isequal(libNames{i}, 'spctrnWrpInterface.dll')
                        warning("Adding MATLAB Interface location to MATLAB path.")
                        addpath(libLocations{i});
                    end
                    if startsWith(libLocations{i}, '.\')
                        libLocations{i} = fullfile(pwd, libLocations{i});
                    end
                end
                spctrnWrp.defaultNamesJson('dll', libNames, libLocations);
                
                res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_init(uint32(memorySize)));
                if res
                    error("SpectranAPI:" + res.string, "Initialisation went wrong, " + res.string)
                end
            end
        end
        
        function openDevice(obj, index, type)
            %SPECTRANAPI open a handle to the device with index INDEX.
            %   All devices are scanned and listed.
            %   This might fail when device_changed happened during
            %   operation. since the indices might change!
            %
            %openDevice(index, type)
            %
            %input arguments:
            %   index   - Index of spectran device. (0 if only one is connected)
            %   type    - Type of Device. (deviceTypes)
            %
            % see also: deviceTypes
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            elseif ~isempty(obj.deviceHandles) && any(cell2mat(obj.deviceHandles(:,1)) == index)
                error('SpectranAPI:invalidarg', ['The Device specified with ' num2str(index) ' is already in use!'])
            end
            if ~isequal(class(type), 'string')
                if isequal(class(type), 'char')
                    type = convertCharsToStrings(type);
                else
                    error('SpectranAPI:invalidarg', 'TYPE needs to be of class string')
                end
            end
            
            % Code
            d = clib.spctrnWrp.AARTSAAPI_Device();
            res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_openDevice(index, d, type, false));
            if res
                error("SpectranAPI:" + res.string, "Opening device handle went wrong, " + res.string)
            end
            obj.deviceHandles{end + 1, 1} = index;
            obj.deviceHandles{end, 2} = d;
            obj.deviceHandles{end, 3} = type;
        end
        
        function closeDevice(obj, index)
            %SPECTRANAPI closes previously opened Device
            %   WARNING: when the device handle is closed any Packet
            %   retrieved using the referred device get freed!
            %
            %closeDevice(index)
            %
            %input arguments:
            %   index   - Index of spectran device. (0 if only one is connected)
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            [device, loc] = obj.privateGetDevice(index);
            
            % Code
            if ~isequal(obj.deviceHandles{loc, 3}, spctrnWrp.deviceTypes.iqTransmitter)
                % try to stop each device that is not the iq transmitter
                % ignore error if not connected / not initialized / not
                % running etc.
                clib.spctrnWrp.spctrn_stopDevice(device);
            else
                % Do not stop the iqreceiver because this leads to an
                % error !
            end
            res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_closeDevice(device));
            if res == spctrnWrp.apiResult.errorNotConnected
                warning("SpectranAPI:" + res.string, "Closing device handle went wrong, " + res.string)
            elseif res
                error("SpectranAPI:" + res.string, "Closing device handle went wrong, " + res.string)
            end
            % setting the deviceHandle and its respective index to empty
            % and remove it from the list
            obj.deviceHandles(loc, :) = [];
            obj.deviceHandles = obj.deviceHandles([1:loc-1, loc+1:end], :);
        end
        
        function setConfig(obj, index, name, value)
            %SPECTRANAPI set a value in the config tree of the device.
            %
            %setConfig(index, name, value)
            %
            %input arguments:
            %   index   - Index of spectran device. (0 if only one is connected)
            %   name    - Name of the config element. (spctrnCnfg)
            %   value   - Value (string/double) of config element.
            %
            %see also: spctrnCnfg
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            if isstring(name)
            elseif ischar(name)
            else
                error('SpectranAPI:invalidarg', 'NAME needs to be of class string!')
            end
            d = obj.privateGetDevice(index);
            
            % Code
            if isnumeric(value) && isscalar(value)
                res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_setConfig_d(d, name, value));
            elseif isstring(value) || ischar(value)
                res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_setConfig_s(d, name, value));
            else
                error('SpectranAPI:invalidarg', 'VALUE needs to be of class string or a numeric, scalar value!')
            end
            if res
                error("SpectranAPI:" + res.string, "Setting " + name + " to the value " + num2str(value) + " went wrong!, " + res.string)
            end
        end
        
        function setConfigEnum(obj, index, name, value)
            %SPECTRANAPI set integer value corresponding to a enumeration
            % index starting at 0.
            %
            %setConfigEnum(index, name, value)
            %
            %input arguments:
            %   index   - Index of spectran device. (0 if only one is connected)
            %   name    - Name of the config element. (spctrnCnfg)
            %   value   - The enumeration index of the element which is to
            %             be selected.
            %
            %see also: spctrnCnfg
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            if ~isnumeric(value) || ~isscalar(value)
                error('SpectranAPI:invalidarg', 'VALUE needs to be numeric, scalar value!')
            elseif ~isequal(class(value), 'int64')
                %                 warning('SpectranAPI:invalidarg', 'VALUE should be of class int64 to avoid conversion!')
                value = int64(value);
            end
            if isstring(name)
            elseif ischar(name)
            else
                error('SpectranAPI:invalidarg', 'NAME needs to be of class string!')
            end
            d = obj.privateGetDevice(index);
            
            % Code
            res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_setConfig_i(d, name, value));
            if res
                error("SpectranAPI:" + res.string, "Setting " + name + " to the value " + num2str(value) + " went wrong!, " + res.string)
            end
        end
        
        function out = getConfigD(obj, index, name)
            %SPECTRANAPI get the double value of a configuration element of
            % a previously opened device.
            %
            %out = getConfigD(index, name)
            %
            %input arguments:
            %   index   - Index of spectran device. (0 if only one is connected)
            %   name    - Name of the configuration element. (spctrnCnfg)
            %
            %output arguments:
            %   out     - Double value of the specified configuration element.
            %
            %see also: spctrnCnfg
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            if isstring(name)
            elseif ischar(name)
            else
                error('SpectranAPI:invalidarg', 'NAME needs to be of class string!')
            end
            d = obj.privateGetDevice(index);
            
            % Code
            out = clib.spctrnWrp.spctrn_getConfig_d(d, name);
            if isnan(out)
                warning('SpectranAPI:badconfig', "The double value of the config element '"...
                    + name + "' might be corrupted, or '" + name + "' does not name a config element!")
            end
        end
        
        function out = getConfigS(obj, index, name)
            %SPECTRANAPI get the string value of a configuration element of
            % a previously opened device.
            %
            %out = getConfigS(index, name)
            %
            %input arguments:
            %   index   - Index of spectran device. (0 if only one is connected)
            %   name    - Name of the configuration element. (spctrnCnfg)
            %
            %output arguments:
            %   out     - String value of the specified configuration element.
            %
            %see also: spctrnCnfg
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            if isstring(name)
            elseif ischar(name)
            else
                error('SpectranAPI:invalidarg', 'NAME needs to be of class string!')
            end
            d = obj.privateGetDevice(index);
            
            % Code
            out = convertCharsToStrings(char(zeros(1,120)));
            out = clib.spctrnWrp.spctrn_getConfig_s(d, name, out, 120);
            if isequal(out,  char(35*ones(1,120)))
                error('SpectranAPI:badconfig', "The String Value of '" + name + ...
                    "' might be corrupted, or '" + name + "' does not name a config element!")
            end
        end
        
        function out = getConfigOptions(obj, index, name)
            %SPECTRANAPI get the options of enumeration literals for
            %specified config element.
            %
            %out = getConfigOptions(index, name)
            %
            %input arguments:
            %   index   - Index of spectran device. (0 if only one is connected)
            %   name    - Name of the configuration element. (spctrnCnfg)
            %
            %output arguments:
            %   out     - Semicolon seperated list of enumeration literals.
            %
            %see also: spctrnCnfg, configExplained
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            if isstring(name)
            elseif ischar(name)
            else
                error('SpectranAPI:invalidarg', 'NAME needs to be of class string!')
            end
            d = obj.privateGetDevice(index);
            
            % Code
            out = convertCharsToStrings(char(zeros(1,1000)));
            out = clib.spctrnWrp.spctrn_getConfigOptions(d, name, out, 2000);
            if isequal(out,  char(35*ones(1,1000)))
                error('SpectranAPI:badconfig', "The Options of '" + name + ...
                    "' might be corrupted, or '" + name + "' does not name a config element!")
            end
        end
        
        function out = getConfigEnum(obj, index, name)
            %SPECTRANAPI get the enumeration index of a configuration
            % element of type enum. (See Aaronia RTSA API Documentation)
            %
            %out = getConfigEnum(index, name)
            %
            %input arguments:
            %   index   - Index of spectran device. (0 if only one is connected)
            %   name    - Name of the configuration element. (spctrnCnfg)
            %
            %output arguments:
            %   out     - Enumeration index of the specified configuration element.
            %
            %see also: spctrnCnfg
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            if isstring(name)
            elseif ischar(name)
            else
                error('SpectranAPI:invalidarg', 'NAME needs to be of class string!')
            end
            d = obj.privateGetDevice(index);
            
            % Code
            out = clib.spctrnWrp.spctrn_getConfig_i(d, name);
            if out < 0
                warning('SpectranAPI:badconfig', "The double value of the config element '"...
                    + name + "' might be corrupted, or '" + name + "' does not name a config element!")
            end
        end
        
        function out = getConfigTree(obj, index)
            %SPECTRANAPI get entire config for spectran device with index
            %INDEX
            %
            %out = getConfigTree(index)
            %
            %input arguments:
            %   index   - Index of spectran device. (0 if only one is connected)
            %
            %output arguments:
            %   out     - All configuration elements as tree structure.
            %
            %see also: spctrnCnfg
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            
            % Code
            %out = spctrnCnfg(d);
            out = spctrnWrp.dynamicConfig(obj, index);
        end
        
        function setConfigTree(obj, index, confTree)
            %SPECTRANAPI set entire config tree.
            %
            %setConfigTree(index, confTree)
            %
            %input arguments:
            %   index      - Index of spectran device. (0 if only one is connected)
            %   confTree   - All configuration elements as tree structure.
            %
            %see also: spctrnCnfg
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            d = obj.privateGetDevice(index);
            if ~isequal(class(confTree), 'spctrnWrp.dynamicConfig')
                error('SpectranAPI:invalidarg', 'CONFTREE needs to be of class spctrnWrp.dynamicConfig!')
            end
            
            % Code
            confTree.setConfigAll(d);
        end
        
        function startDevice(obj, index)
            %SPECTRANAPI start previously opened device
            % INDEX needs to be the index of an open device!
            %
            %startDevice(index)
            %
            %input arguments:
            %   index   - Index of spectran device. (0 if only one is connected)
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            d = obj.privateGetDevice(index);
            
            % Code
            res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_startDevice(d));
            if res == spctrnWrp.apiResult.ok
            elseif res == spctrnWrp.apiResult.connected
                error("SpectranAPI:badPower", "Error starting device. Check power supply!")
            else
                error("SpectranAPI:" + res.string, "Error starting device , " + res.string)
            end
        end
        
        function stopDevice(obj, index)
            %SPECTRANAPI stop previously opened device
            % INDEX needs to be a index of an open device!
            %
            %stopDevice(index)
            %
            %input arguments:
            %   index   - Index of spectran device. (0 if only one is connected)
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            d = obj.privateGetDevice(index);
            
            % Code
            res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_stopDevice(d));
            if res
                error("SpectranAPI:" + res.string, "Error stopping device , " + res.string)
            end
        end
        
        function p = getPacket(obj, index, channel)
            %SPECTRANAPI get data packet from queue.
            %The Packet is read and consumed!
            %
            %p = getPacket(index, channel)
            %
            %input arguments:
            %   index     - Index of spectran device. (0 if only one is connected)
            %   channel   - Data exchange channel used. (deviceChannels)
            %
            %see also: deviceChannels, sendPacket
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            d = obj.privateGetDevice(index);
            if ~isequal(class(channel), 'deviceChannels')
                if isnumeric(channel) && isscalar(channel)
                else
                    error('SpectranAPI:invalidarg', 'CHANNEL needs to be of class deviceChannels!')
                end
            end
            
            % Code
            p = clib.spctrnWrp.AARTSAAPI_Packet();
            p.cbsize = obj.packetSize;
            res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_getPacket(d, index, int32(channel), p, true));
            if res
                error("SpectranAPI:" + res.string, "Error getting data packet , " + res.string)
            end
        end
        
        function sendPacket(obj, index, P, channel)
            %SPECTRANAPI send filled out iq data packet to transmitter of
            %   spectran. (currently not working)
            %
            %WARNING:
            %   It is advised to only send a Packet with a certain
            %   center/span frequency if the device has been set up with
            %   matching values!
            %
            %Data to be set in the packet:
            %   startFrequency   - Used to set Centerfrequency of iq signal.
            %   spanFrequency    -  centerFrequency = startF + spanF / 2
            %   stepFrequency    - Sample rate of the data.
            %   startTime        - Start time of the data, where 0 means now.
            %   fp32             - Row vector of IQ pairs. size = (num, 2)
            %   size             - size of each sample (2).
            %   stride           - offset of the samples in data (2).
            %   num              - amount of samples.
            %
            %sendPacket(index, P)
            %
            %input arguments:
            %   index     - Index of spectran device. (0 if only one is connected)
            %   P         - IQ Data packet.
            %
            %see also: getPacket, sendData
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            d = obj.privateGetDevice(index);
            if ~isequal(class(P), 'clib.spctrnWrp.AARTSAAPI_Packet')
                error('SpectranAPI:invalidarg', "P needs to be of class 'clib.spctrnWrp.AARTSAAPI_Packet'");
            end
            
            % Code
            res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_sendPacket(d, channel, P));
            if res
                error("SpectranAPI:" + res.string, "Error sending iq data packet , " + res.string)
            end
        end
        
        function getData(obj, index, channel, timeOffset, dataRate, numSamples, filename)
            %SPECTRANAPI record either iq or spectra data and write to mat
            %file.
            %
            %getData(index, channel, timeOffset, dataRate, numSamples)
            %   record iq Samples. CHANNEL needs to be an iq channel.
            %
            %getData(index, channel, timeOffset, dataRate, numSamples)
            %   record spectra samples. CHANNEL needs to be spectra
            %   channel.
            %
            %getData(_, filename)
            %   save data as .mat file of specified name.
            %
            %input arguments:
            %   index        - Index of spectran device. (0 if only one is connected)
            %   channel      - Channel used. (deviceChannels)
            %   timeOffset   - Time in seconds when the transmission is supposed to start.
            %   Data         - row vector of 'single' IQ samples. size(Data) = [#Samples, 2]
            %   dataRate     - Frequency of the samples. Samples / s.
            %   numSamples   - number of samples to be recorded.
            %   filename     - Name of the .mat file storing the recorded data.
            %
            %see also: sendData, deviceChannels, configExplained
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            d = obj.privateGetDevice(index);
            if ~isnumeric(channel) || ~isscalar(channel) || channel ~= floor(channel) ||channel > 3 || channel < 0
                error('SpectranAPI:invalidarg', 'CHANNEL needs to be positive integer less than or equal to 3.')
            end
            if ~isnumeric(timeOffset) || ~isscalar(timeOffset) ||any(timeOffset < 0)
                error('SpectranAPI:invalidarg', 'TIMEOFFSET needs to be a non-negative numeric, scalar!')
            end
            if ~isnumeric(dataRate) || ~isscalar(dataRate) ||any(dataRate < 0)
                error('SpectranAPI:invalidarg', 'DATARATE needs to be a non-negative numeric, scalar!')
            end
            if ~isnumeric(numSamples) || ~isscalar(numSamples) || floor(numSamples) ~= numSamples || numSamples < 0
                error('SpectranAPI:invalidarg', 'NUMSAMPLES needs to be non-negative integer scalar!')
            end
            
            if nargin > 6
                if isstring(filename) || ischar(filename)
                    if ~endsWith(filename, ".mat")
                        filename = [convertStringsToChars(filename), '.mat'];
                    end
                else
                    error('SpectranAPI:invalidarg', 'FILENAME needs to be string type!')
                end
            else
                filename = 'spectranData.mat';
            end
            
            if channel == spctrnWrp.deviceChannels.iqRX1 || channel == spctrnWrp.deviceChannels.iqRX2
                %GET IQ DATA
                %     spctrn_getIqData(AARTSAAPI_Device* device_ptr, const int32_t& DeviceIndex, const int32_t& channel, const int64_t& numberOfSamples,
                %       double samplingRate, const char* filename, const double& start);
                res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_getIqData(d, index, channel, numSamples, dataRate, filename, timeOffset));

            else
                %GET SPECTRA DATA
                %     spctrn_getSpectraData(AARTSAAPI_Device* device_ptr, const int32_t& DeviceIndex, const int32_t& channel,
                %       size_t numberOfSamples, double samplingRate, const char* filename, const double& start);
                res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_getSpectraData(d, index, channel, numSamples, dataRate, filename, timeOffset));
            end
            
            if res
                error("SpectranAPI:" + res.string, "Error getting Data , " + res.string)
            end
        end
        
        function endTime = sendData(obj, index, channel, centerF, spanF, timeOffset, Data, dataRate, absTime, loop)
            %SPECTRANAPI send filled out iq data packet to transmitter of
            %   spectran.
            %
            %
            %endTime = sendData(index, channel, centerF, spanF, timeOffset, Data, dataRate, absTime)
            %   send IQ-Samples to spectranv6 transmitter.
            %
            %endTime = sendData(index, channel, centerF, spanF, timeOffset, Data, dataRate, absTime, loop)
            %   Loops IQ-samples for specified amount of times. loop = 1
            %   means the samples are played once, not played once and
            %   looped once.
            %
            %input arguments:
            %   index        - Index of spectran device. (0 if only one is connected)
            %   channel      - Channel used. (deviceChannels)
            %   centerF      - Center frequency of the signal.
            %   spanF        - Span frequency of the device in use.
            %   timeOffset   - Time in seconds when the transmission is supposed to start.
            %   Data         - row vector of 'single' IQ samples. size(Data) = [#Samples, 2]
            %   dataRate     - Frequency of the samples. Samples / s.
            %   loop         - Number of times the given IQ-Data set should be looped.
            %   absTime      - Logical specifing if absolute time is going to be used insted of relative offset from master stream time.
            %
            %output arguments:
            %   endTime      - End time of the packet which got sent.
            %
            %see also: getPacket, sendPacket, deviceChannels
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            d = obj.privateGetDevice(index);
            if ~isnumeric(centerF) || ~isscalar(centerF)
                error('SpectranAPI:invalidarg', 'CENTERF needs to be numeric, scalar value!')
            end
            if ~isnumeric(spanF) || ~isscalar(spanF) ||any(spanF < 0)
                error('SpectranAPI:invalidarg', 'SPANF needs to be a non-negative numeric, scalar!')
            end
            if ~isnumeric(timeOffset) || ~isscalar(timeOffset) ||any(timeOffset < 0)
                error('SpectranAPI:invalidarg', 'TIMEOFFSET needs to be a non-negative numeric, scalar!')
            end
            if ~isnumeric(Data) || ~ismatrix(Data) || size(Data, 2) ~= 2
                error('SpectranAPI:invalidarg', 'Data needs to be numeric matrix of size [#samples, 2]!')
            elseif ~isequal(class(Data), 'single')
                Data = single(Data);
            end
            if ~isnumeric(dataRate) || ~isscalar(dataRate) ||any(dataRate < 0)
                error('SpectranAPI:invalidarg', 'DATARATE needs to be a non-negative numeric, scalar!')
            end
            if ~islogical(absTime)
                error('SpectranAPI:invalidarg', 'ABSTIME needs to be logical!')
            end
            if ~isnumeric(channel) || ~isscalar(channel) || channel ~= floor(channel) ||channel > 3 || channel < 0
                error('SpectranAPI:invalidarg', 'CHANNEL needs to be positive integer less than or equal to 3.')
            end
            if nargin > 9
                if ~isnumeric(loop) || ~isscalar(loop) || loop ~= floor(loop)
                    if loop < 1
                        loop = 1;
                        warning('SpectranAPI:invalidarg', 'LOOP needs to be larger than or equal to 1.')
                    end
                end
            else
                loop = 1;
            end
            
            % Code
            % SPCTRNWRP_API double spctrn_sendData(AARTSAAPI_Device* device_ptr, const int32_t& channel, const double& centerF, const double& rate,
            %   const double& span, const double& start, const int64_t& num, float* data, const int32_t& loop, const bool& absoluteTime);
            endTime = clib.spctrnWrp.spctrn_sendData(d, channel, centerF, dataRate, spanF, timeOffset, size(Data, 1), Data, loop, absTime);
            if isnan(endTime)
                error('SpectranAPI:senddata', 'Error occured when sending data to transmitter!')
            end
        end
        
        function transceiveData(obj, index, channels, centerFs, samplingRates, spanFs, numSamples, data, startTimes, loop, filename)
            %SPECTRANAPI send Data to transmitter and receiver data
            %simoultaneously.
            %
            %transceiveData(index, channels, centerFs, samplingRates, spanFs, numSamples, data, startTimes)
            %
            %transceiveData(_,loop)
            %   loop transmitt data for specified number of times. loop = 1
            %   means the data is played once, not played and repeated
            %   once.
            %
            %transceiveData(_,filename)
            %   save received data as mat file of name FILENAME.
            %
            %input arguments:
            %   index         - Index of spectran device. (0 if only one is connected)
            %   channels      - Channel indices of for transmitter and receiver respectively. [channelTx, channelRx]
            %   centerFs      - Center frequencies of transmitter and receiver respectively.
            %   samplingRates - Sampling rates of transmitter and receiver respectively.
            %   spanFs        - Span frequencies of transmitter and receiver respectively.
            %   numSamples    - Number of samples to receive.
            %   data          - IQ samples to be sent to the transmitter. (see sendData)
            %   startTimes    - Time offset of transmitter and receiver respectively in seconds.
            %   loop          - Number of times the IQ samples should be looped.
            %   filename      - Name of the .mat file storing the recorded data.
            
            if ~isnumeric(index) || ~isscalar(index) || floor(index) ~= index
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            d = obj.privateGetDevice(index);
            if ~isnumeric(channels) || numel(channels) ~= 2 || any(~(floor(channels) == channels))...
                    || any(channels < 0) || any(channels > 3)
                error('SpectranAPI:invalidarg', 'CHANNELS needs to be a integer matrix with two elements between 0 and 3.')
            end
            if ~isnumeric(centerFs) || numel(centerFs) ~= 2
                error('SpectranAPI:invalidarg', 'CENTERFS needs to be a numeric matrix with two elements!')
            end
            if ~isnumeric(samplingRates) || numel(samplingRates) ~= 2
                error('SpectranAPI:invalidarg', 'SAMPLINGRATES needs to be a numeric matrix with two elements!')
            end
            if ~isnumeric(spanFs) || numel(spanFs) ~= 2
                error('SpectranAPI:invalidarg', 'SPANFS needs to be a numeric matrix with two elements!')
            end
            if ~isnumeric(numSamples) || ~isscalar(numSamples) || floor(numSamples) ~= numSamples
                error('SpectranAPI:invalidarg', 'NUMSAMPLES needs to be numeric, scalar value!')
            end
            if ~isnumeric(data) || ~ismatrix(data) || size(data, 2) ~= 2
                error('SpectranAPI:invalidarg', 'Data needs to be numeric matrix of size [#samples, 2]!')
            elseif ~isequal(class(data), 'single')
                data = single(data);
            end
            if ~isnumeric(startTimes) || numel(startTimes) ~= 2 || any(startTimes < 0)
                error('SpectranAPI:invalidarg', 'STARTTIMES needs to be a numeric matrix with two non-negative elements!')
            end
            if nargin > 9
                if ~isnumeric(loop) || ~isscalar(loop) || loop ~= floor(loop)
                    if loop < 1
                        loop = 1;
                        warning('SpectranAPI:invalidarg', 'LOOP needs to be larger than or equal to 1.')
                    end
                end
            else
                loop = 1;
            end
            if nargin > 10
                if isstring(filename) || ischar(filename)
                    if ~endsWith(filename, ".mat")
                        filename = [convertStringsToChars(filename), '.mat'];
                    end
                else
                    error('SpectranAPI:invalidarg', 'FILENAME needs to be string type!')
                end
            else
                filename = 'spectranData.mat';
            end
            
            % spctrn_transceiveData(AARTSAAPI_Device* device_ptr, const int32_t& index, const int32_t& channelTrans, 
            %   const int32_t& channelRec, const double& centerFTrans, const double& centerFRec, const double& samplingRateTrans, 
            %   const double& samplingRateRec, const double& spanTrans, const double& spanRec, const int64_t& numTrans, 
            %   const int32_t& numRec, float* data, const double& startTrans, const double& startRec,
            % 	const int32_t& loop, const char* filename);
            res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_transceiveData(d, index, channels(1), channels(2), centerFs(1), centerFs(2), ...
                samplingRates(1), samplingRates(2), size(data, 1), numSamples, data, startTimes(1), startTimes(2), ...
                loop, filename));
            
            if res
                error("SpectranAPI:" + res.string, "Error transceiving, " + res.string)
            end
        end
        
        function n = getAvailPackets(obj, index, channel)
            %SPECTRANAPI get the number of available packets in the usb
            %   data queue of the specified channel.
            %
            %n = getAvailPackets(index, channel)
            %
            %input arguments:
            %   index     - Index of spectran device. (0 if only one is connected)
            %   channel   - Data exchange channel used. (deviceChannels)
            %
            %output arguments:
            %   n         - Amount of available packets in specified queue.
            %
            %see also: deviceChannels
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            d = obj.privateGetDevice(index);
            if ~isequal(class(channel), 'spctrnWrp.deviceChannels')
                if isnumeric(channel) && isscalar(channel)
                else
                    error('SpectranAPI:invalidarg', 'CHANNEL needs to be of class deviceChannels!')
                end
            end
            
            % Code
            n = clib.spctrnWrp.spctrn_availPackets(d, int32(channel));
            if n == -1
                error("SpectranAPI:badPackets", "Error getting the number of packets in queue!")
            end
        end
        
        function consumePackets(obj, index, channel, x)
            %SPECTRANAPI consumes a number of packets specified by the
            %   value of x.
            %
            %consumePackets(int INDEX, int CHANNEL, uint X)
            %   consume/remove X packets from the packet queue
            %
            %consumePackets(int INDEX, int CHANNEL, 'all')
            %   consume/remove all packets from the packet queue
            %
            %input arguments:
            %   index     - Index of spectran device. (0 if only one is connected)
            %   channel   - Data exchange channel used. (deviceChannels)
            %   x         - Number of packets packets that are to be
            %               consumed.
            %
            %see also: deviceChannels
            
            % Argument handling
            if ~isnumeric(index) || ~isscalar(index)
                error('SpectranAPI:invalidarg', 'INDEX needs to be numeric, scalar value!')
            end
            d = obj.privateGetDevice(index);
            if ~isequal(class(channel), 'spctrnWrp.deviceChannels')
                if isnumeric(channel) && isscalar(channel)
                else
                    error('SpectranAPI:invalidarg', 'CHANNEL needs to be of class deviceChannels!')
                end
            end
            
            % Code
            if isequal(x, 'all')
                n = clib.spctrnWrp.spctrn_availPackets(d, int32(channel));
                if n == -1
                    error("SpectranAPI:badPackets", "Error getting the number of packets in queue!")
                end
                res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_consumePackets(d, int32(channel), n));
            elseif isnumeric(x) && (x > 0)
                res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_consumePackets(d, int32(channel), x));
            else
                error('SpectranAPI:invalidarg', 'X must be a non negative number or "all"!')
            end
            
            % error handling
            if res
                error("SpectranAPI:" + res.string, "Error consuming packets , " + res.string)
            end
        end
        
        function d = getHandle(obj) %#ok<MANU>
            %SPECTRANAPI return d Parameter of api handle
            %
            %output arguments:
            %   d Parameter as uint64
            d = clib.spctrnWrp.spctrn_getApiHandle();
        end
        
        function d = getDevice(obj ,idx)
            %SPECTRANAPI return d Parameter of device handle
            %
            %input arguments:
            %   idx index of device! not index of device in the
            %   deviceHandles propertie.
            %
            %output arguments:
            %   d Parameter as uint64
            %
            %see also: api
            device = obj.privateGetDevice(idx);
            d = clib.spctrnWrp.spctrn_getDeviceHandle(device);
        end
        
        function s = getDeviceState(obj, idx)
            %SPECTRANAPI returns state of device as apiResult
            d = obj.privateGetDevice(idx);
            s = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_deviceState(d));
        end
        
        function delete(obj)
            %SPECTRANAPI Deconstruct an instance of this class
            %   close all device handles.
            %   close the api handle.
            %   release the data exchange memory.
            for iDevices = 1:size(obj.deviceHandles, 1)
                if ~isequal(obj.deviceHandles{iDevices, 3}, spctrnWrp.deviceTypes.iqTransmitter)
                    % try to stop each device that is not the iq transmitter
                    % ignore error if not connected / not initialized / not
                    % running etc.
                    clib.spctrnWrp.spctrn_stopDevice(obj.deviceHandles{iDevices, 2});
                else
                    % Do not stop the iqreceiver because this leads to an
                    % error !
                end
                res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_closeDevice(obj.deviceHandles{iDevices, 2}));
                if res
                    warning("SpectranAPI:" + res.string, "Closing Device handle with index " + ...
                        num2str(obj.deviceHandles{iDevices, 1}) +" went wrong, " + res.string)
                end
            end
            obj.deviceHandles = [];
            
            % Keep track of initialisations
            counter = 0;
            try
                counter = spctrnWrp.myGlobal.get(counter);
            catch
            end            
            counter = counter - 1;
            spctrnWrp.myGlobal.set(counter);
            if counter == 0
                res = spctrnWrp.apiResult(clib.spctrnWrp.spctrn_shutdown());
                if res
                    error("SpectranAPI:" + res.string, "Deallocating memory went wrong, " + res.string)
                end
            end
        end
    end
    
    methods (Access = private)
        function [deviceHandle, location] = privateGetDevice(obj, index)
            %SPECTRANAPI returns the handle to the device in the device
            %   list with index specified by INDEX.
            %   INDEX refers to the index of the usb device, not the index
            %   in the list.
            %
            %[deviceHandle, location] = privateGetDevice(index)
            %
            %input arguments:
            %   INDEX = the index of the device to be used (0 if only one is connected)
            %
            %output arguments:
            %   DEVICEHANDLE = handle of device object. (used by the api internally)
            %   LOCATION = location of the device handle in the
            %   deviceHandles list of the api.
            if isempty(obj.deviceHandles)
                error('SpectranAPI:invalidarg', ['No device with index ' num2str(index)]);
            end
            location = find(cell2mat(obj.deviceHandles(:,1)) == index, 1);
            if isempty(location)
                error('SpectranAPI:invalidarg', ['No device with index ' num2str(index)]);
            else
                deviceHandle = obj.deviceHandles{location, 2};
            end
        end
    end
end

