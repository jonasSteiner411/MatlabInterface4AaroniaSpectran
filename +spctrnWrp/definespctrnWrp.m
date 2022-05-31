%% About definespctrnWrp.mlx
% This file defines the MATLAB interface to the library |spctrnWrp|.
%
% Commented sections represent C++ functionality that MATLAB cannot automatically define. To include
% functionality, uncomment a section and provide values for &lt;SHAPE&gt;, &lt;DIRECTION&gt;, etc. For more
% information, see <matlab:helpview(fullfile(docroot,'matlab','helptargets.map'),'cpp_define_interface') Define MATLAB Interface for C++ Library>.



%% Setup. Do not edit this section.
function libDef = definespctrnWrp()
libDef = clibgen.LibraryDefinition("spctrnWrpData.xml");
%% OutputFolder and Libraries 
libDef.OutputFolder = "C:\Users\steiner\Documents\MATLAB\spctrnWrp";
libDef.Libraries = "C:\Users\steiner\source\repos\spctrnWrp\x64\Release\spctrnWrp.lib";

%% C++ class |AARTSAAPI_Device| with MATLAB name |clib.spctrnWrp.AARTSAAPI_Device| 
AARTSAAPI_DeviceDefinition = addClass(libDef, "AARTSAAPI_Device", "MATLABName", "clib.spctrnWrp.AARTSAAPI_Device", ...
    "Description", "clib.spctrnWrp.AARTSAAPI_Device    Representation of C++ class AARTSAAPI_Device."); % Modify help description values as needed.

%% C++ class constructor for C++ class |AARTSAAPI_Device| 
% C++ Signature: AARTSAAPI_Device::AARTSAAPI_Device()
AARTSAAPI_DeviceConstructor1Definition = addConstructor(AARTSAAPI_DeviceDefinition, ...
    "AARTSAAPI_Device::AARTSAAPI_Device()", ...
    "Description", "clib.spctrnWrp.AARTSAAPI_Device    Constructor of C++ class AARTSAAPI_Device."); % Modify help description values as needed.
validate(AARTSAAPI_DeviceConstructor1Definition);

%% C++ class constructor for C++ class |AARTSAAPI_Device| 
% C++ Signature: AARTSAAPI_Device::AARTSAAPI_Device(AARTSAAPI_Device const & input1)
AARTSAAPI_DeviceConstructor2Definition = addConstructor(AARTSAAPI_DeviceDefinition, ...
    "AARTSAAPI_Device::AARTSAAPI_Device(AARTSAAPI_Device const & input1)", ...
    "Description", "clib.spctrnWrp.AARTSAAPI_Device    Constructor of C++ class AARTSAAPI_Device."); % Modify help description values as needed.
defineArgument(AARTSAAPI_DeviceConstructor2Definition, "input1", "clib.spctrnWrp.AARTSAAPI_Device", "input");
validate(AARTSAAPI_DeviceConstructor2Definition);

%% C++ class |AARTSAAPI_Packet| with MATLAB name |clib.spctrnWrp.AARTSAAPI_Packet| 
AARTSAAPI_PacketDefinition = addClass(libDef, "AARTSAAPI_Packet", "MATLABName", "clib.spctrnWrp.AARTSAAPI_Packet", ...
    "Description", "clib.spctrnWrp.AARTSAAPI_Packet    Representation of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ class constructor for C++ class |AARTSAAPI_Packet| 
% C++ Signature: AARTSAAPI_Packet::AARTSAAPI_Packet()
AARTSAAPI_PacketConstructor1Definition = addConstructor(AARTSAAPI_PacketDefinition, ...
    "AARTSAAPI_Packet::AARTSAAPI_Packet()", ...
    "Description", "clib.spctrnWrp.AARTSAAPI_Packet    Constructor of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.
validate(AARTSAAPI_PacketConstructor1Definition);

%% C++ class constructor for C++ class |AARTSAAPI_Packet| 
% C++ Signature: AARTSAAPI_Packet::AARTSAAPI_Packet(AARTSAAPI_Packet const & input1)
AARTSAAPI_PacketConstructor2Definition = addConstructor(AARTSAAPI_PacketDefinition, ...
    "AARTSAAPI_Packet::AARTSAAPI_Packet(AARTSAAPI_Packet const & input1)", ...
    "Description", "clib.spctrnWrp.AARTSAAPI_Packet    Constructor of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.
defineArgument(AARTSAAPI_PacketConstructor2Definition, "input1", "clib.spctrnWrp.AARTSAAPI_Packet", "input");
validate(AARTSAAPI_PacketConstructor2Definition);

%% C++ class public data member |cbsize| for C++ class |AARTSAAPI_Packet| 
% C++ Signature: int64_t AARTSAAPI_Packet::cbsize
addProperty(AARTSAAPI_PacketDefinition, "cbsize", "int64", ...
    "Description", "int64    Data member of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ class public data member |streamID| for C++ class |AARTSAAPI_Packet| 
% C++ Signature: uint64_t AARTSAAPI_Packet::streamID
addProperty(AARTSAAPI_PacketDefinition, "streamID", "uint64", ...
    "Description", "uint64    Data member of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ class public data member |flags| for C++ class |AARTSAAPI_Packet| 
% C++ Signature: uint64_t AARTSAAPI_Packet::flags
addProperty(AARTSAAPI_PacketDefinition, "flags", "uint64", ...
    "Description", "uint64    Data member of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ class public data member |startTime| for C++ class |AARTSAAPI_Packet| 
% C++ Signature: double AARTSAAPI_Packet::startTime
addProperty(AARTSAAPI_PacketDefinition, "startTime", "double", ...
    "Description", "double    Data member of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ class public data member |endTime| for C++ class |AARTSAAPI_Packet| 
% C++ Signature: double AARTSAAPI_Packet::endTime
addProperty(AARTSAAPI_PacketDefinition, "endTime", "double", ...
    "Description", "double    Data member of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ class public data member |startFrequency| for C++ class |AARTSAAPI_Packet| 
% C++ Signature: double AARTSAAPI_Packet::startFrequency
addProperty(AARTSAAPI_PacketDefinition, "startFrequency", "double", ...
    "Description", "double    Data member of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ class public data member |stepFrequency| for C++ class |AARTSAAPI_Packet| 
% C++ Signature: double AARTSAAPI_Packet::stepFrequency
addProperty(AARTSAAPI_PacketDefinition, "stepFrequency", "double", ...
    "Description", "double    Data member of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ class public data member |spanFrequency| for C++ class |AARTSAAPI_Packet| 
% C++ Signature: double AARTSAAPI_Packet::spanFrequency
addProperty(AARTSAAPI_PacketDefinition, "spanFrequency", "double", ...
    "Description", "double    Data member of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ class public data member |rbwFrequency| for C++ class |AARTSAAPI_Packet| 
% C++ Signature: double AARTSAAPI_Packet::rbwFrequency
addProperty(AARTSAAPI_PacketDefinition, "rbwFrequency", "double", ...
    "Description", "double    Data member of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ class public data member |num| for C++ class |AARTSAAPI_Packet| 
% C++ Signature: int64_t AARTSAAPI_Packet::num
addProperty(AARTSAAPI_PacketDefinition, "num", "int64", ...
    "Description", "int64    Data member of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ class public data member |total| for C++ class |AARTSAAPI_Packet| 
% C++ Signature: int64_t AARTSAAPI_Packet::total
addProperty(AARTSAAPI_PacketDefinition, "total", "int64", ...
    "Description", "int64    Data member of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ class public data member |size| for C++ class |AARTSAAPI_Packet| 
% C++ Signature: int64_t AARTSAAPI_Packet::size
addProperty(AARTSAAPI_PacketDefinition, "size", "int64", ...
    "Description", "int64    Data member of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ class public data member |stride| for C++ class |AARTSAAPI_Packet| 
% C++ Signature: int64_t AARTSAAPI_Packet::stride
addProperty(AARTSAAPI_PacketDefinition, "stride", "int64", ...
    "Description", "int64    Data member of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ class public data member |fp32| for C++ class |AARTSAAPI_Packet| 
% C++ Signature: float * AARTSAAPI_Packet::fp32
%addProperty(AARTSAAPI_PacketDefinition, "fp32", "clib.array.spctrnWrp.Float", <SHAPE>, ... % '<MLTYPE>' can be clib.array.spctrnWrp.Float, or single
%    "Description", "clib.array.spctrnWrp.Float    Data member of C++ class AARTSAAPI_Packet."); % Modify help description values as needed.

%% C++ function |spctrn_openDevice| with MATLAB name |clib.spctrnWrp.spctrn_openDevice|
% C++ Signature: uint32_t spctrn_openDevice(int32_t const & index,AARTSAAPI_Device * device_ptr,wchar_t const * type,bool start)
%spctrn_openDeviceDefinition = addFunction(libDef, ...
%    "uint32_t spctrn_openDevice(int32_t const & index,AARTSAAPI_Device * device_ptr,wchar_t const * type,bool start)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_openDevice", ...
%    "Description", "clib.spctrnWrp.spctrn_openDevice    Representation of C++ function spctrn_openDevice."); % Modify help description values as needed.
%defineArgument(spctrn_openDeviceDefinition, "index", "int32", "input");
%defineArgument(spctrn_openDeviceDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_openDeviceDefinition, "type", "char", "input", <SHAPE>); % '<MLTYPE>' can be char, or string
%defineArgument(spctrn_openDeviceDefinition, "start", "logical");
%defineOutput(spctrn_openDeviceDefinition, "RetVal", "uint32");
%validate(spctrn_openDeviceDefinition);

%% C++ function |spctrn_startDevice| with MATLAB name |clib.spctrnWrp.spctrn_startDevice|
% C++ Signature: uint32_t spctrn_startDevice(AARTSAAPI_Device * device_ptr)
%spctrn_startDeviceDefinition = addFunction(libDef, ...
%    "uint32_t spctrn_startDevice(AARTSAAPI_Device * device_ptr)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_startDevice", ...
%    "Description", "clib.spctrnWrp.spctrn_startDevice    Representation of C++ function spctrn_startDevice."); % Modify help description values as needed.
%defineArgument(spctrn_startDeviceDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineOutput(spctrn_startDeviceDefinition, "RetVal", "uint32");
%validate(spctrn_startDeviceDefinition);

%% C++ function |spctrn_stopDevice| with MATLAB name |clib.spctrnWrp.spctrn_stopDevice|
% C++ Signature: uint32_t spctrn_stopDevice(AARTSAAPI_Device * device_ptr)
%spctrn_stopDeviceDefinition = addFunction(libDef, ...
%    "uint32_t spctrn_stopDevice(AARTSAAPI_Device * device_ptr)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_stopDevice", ...
%    "Description", "clib.spctrnWrp.spctrn_stopDevice    Representation of C++ function spctrn_stopDevice."); % Modify help description values as needed.
%defineArgument(spctrn_stopDeviceDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineOutput(spctrn_stopDeviceDefinition, "RetVal", "uint32");
%validate(spctrn_stopDeviceDefinition);

%% C++ function |spctrn_getPacket| with MATLAB name |clib.spctrnWrp.spctrn_getPacket|
% C++ Signature: uint32_t spctrn_getPacket(AARTSAAPI_Device * device_ptr,int32_t const & index,int32_t const & channel,AARTSAAPI_Packet * packet_ptr,bool consume)
%spctrn_getPacketDefinition = addFunction(libDef, ...
%    "uint32_t spctrn_getPacket(AARTSAAPI_Device * device_ptr,int32_t const & index,int32_t const & channel,AARTSAAPI_Packet * packet_ptr,bool consume)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_getPacket", ...
%    "Description", "clib.spctrnWrp.spctrn_getPacket    Representation of C++ function spctrn_getPacket."); % Modify help description values as needed.
%defineArgument(spctrn_getPacketDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_getPacketDefinition, "index", "int32", "input");
%defineArgument(spctrn_getPacketDefinition, "channel", "int32", "input");
%defineArgument(spctrn_getPacketDefinition, "packet_ptr", "clib.spctrnWrp.AARTSAAPI_Packet", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Packet, or clib.array.spctrnWrp.AARTSAAPI_Packet
%defineArgument(spctrn_getPacketDefinition, "consume", "logical");
%defineOutput(spctrn_getPacketDefinition, "RetVal", "uint32");
%validate(spctrn_getPacketDefinition);

%% C++ function |spctrn_consumePackets| with MATLAB name |clib.spctrnWrp.spctrn_consumePackets|
% C++ Signature: uint32_t spctrn_consumePackets(AARTSAAPI_Device * device_ptr,int32_t const & channel,int32_t const & num)
%spctrn_consumePacketsDefinition = addFunction(libDef, ...
%    "uint32_t spctrn_consumePackets(AARTSAAPI_Device * device_ptr,int32_t const & channel,int32_t const & num)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_consumePackets", ...
%    "Description", "clib.spctrnWrp.spctrn_consumePackets    Representation of C++ function spctrn_consumePackets."); % Modify help description values as needed.
%defineArgument(spctrn_consumePacketsDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_consumePacketsDefinition, "channel", "int32", "input");
%defineArgument(spctrn_consumePacketsDefinition, "num", "int32", "input");
%defineOutput(spctrn_consumePacketsDefinition, "RetVal", "uint32");
%validate(spctrn_consumePacketsDefinition);

%% C++ function |spctrn_availPackets| with MATLAB name |clib.spctrnWrp.spctrn_availPackets|
% C++ Signature: int32_t spctrn_availPackets(AARTSAAPI_Device * device_ptr,int32_t const & channel)
%spctrn_availPacketsDefinition = addFunction(libDef, ...
%    "int32_t spctrn_availPackets(AARTSAAPI_Device * device_ptr,int32_t const & channel)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_availPackets", ...
%    "Description", "clib.spctrnWrp.spctrn_availPackets    Representation of C++ function spctrn_availPackets."); % Modify help description values as needed.
%defineArgument(spctrn_availPacketsDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_availPacketsDefinition, "channel", "int32", "input");
%defineOutput(spctrn_availPacketsDefinition, "RetVal", "int32");
%validate(spctrn_availPacketsDefinition);

%% C++ function |spctrn_closeDevice| with MATLAB name |clib.spctrnWrp.spctrn_closeDevice|
% C++ Signature: uint32_t spctrn_closeDevice(AARTSAAPI_Device * device_ptr)
%spctrn_closeDeviceDefinition = addFunction(libDef, ...
%    "uint32_t spctrn_closeDevice(AARTSAAPI_Device * device_ptr)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_closeDevice", ...
%    "Description", "clib.spctrnWrp.spctrn_closeDevice    Representation of C++ function spctrn_closeDevice."); % Modify help description values as needed.
%defineArgument(spctrn_closeDeviceDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineOutput(spctrn_closeDeviceDefinition, "RetVal", "uint32");
%validate(spctrn_closeDeviceDefinition);

%% C++ function |spctrn_setConfig_d| with MATLAB name |clib.spctrnWrp.spctrn_setConfig_d|
% C++ Signature: uint32_t spctrn_setConfig_d(AARTSAAPI_Device * device_ptr,wchar_t const * name,double value)
%spctrn_setConfig_dDefinition = addFunction(libDef, ...
%    "uint32_t spctrn_setConfig_d(AARTSAAPI_Device * device_ptr,wchar_t const * name,double value)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_setConfig_d", ...
%    "Description", "clib.spctrnWrp.spctrn_setConfig_d    Representation of C++ function spctrn_setConfig_d."); % Modify help description values as needed.
%defineArgument(spctrn_setConfig_dDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_setConfig_dDefinition, "name", "char", "input", <SHAPE>); % '<MLTYPE>' can be char, or string
%defineArgument(spctrn_setConfig_dDefinition, "value", "double");
%defineOutput(spctrn_setConfig_dDefinition, "RetVal", "uint32");
%validate(spctrn_setConfig_dDefinition);

%% C++ function |spctrn_setConfig_s| with MATLAB name |clib.spctrnWrp.spctrn_setConfig_s|
% C++ Signature: uint32_t spctrn_setConfig_s(AARTSAAPI_Device * device_ptr,wchar_t const * name,wchar_t const * value)
%spctrn_setConfig_sDefinition = addFunction(libDef, ...
%    "uint32_t spctrn_setConfig_s(AARTSAAPI_Device * device_ptr,wchar_t const * name,wchar_t const * value)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_setConfig_s", ...
%    "Description", "clib.spctrnWrp.spctrn_setConfig_s    Representation of C++ function spctrn_setConfig_s."); % Modify help description values as needed.
%defineArgument(spctrn_setConfig_sDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_setConfig_sDefinition, "name", "char", "input", <SHAPE>); % '<MLTYPE>' can be char, or string
%defineArgument(spctrn_setConfig_sDefinition, "value", "char", "input", <SHAPE>); % '<MLTYPE>' can be char, or string
%defineOutput(spctrn_setConfig_sDefinition, "RetVal", "uint32");
%validate(spctrn_setConfig_sDefinition);

%% C++ function |spctrn_getConfig_d| with MATLAB name |clib.spctrnWrp.spctrn_getConfig_d|
% C++ Signature: double spctrn_getConfig_d(AARTSAAPI_Device * device_ptr,wchar_t const * name)
%spctrn_getConfig_dDefinition = addFunction(libDef, ...
%    "double spctrn_getConfig_d(AARTSAAPI_Device * device_ptr,wchar_t const * name)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_getConfig_d", ...
%    "Description", "clib.spctrnWrp.spctrn_getConfig_d    Representation of C++ function spctrn_getConfig_d."); % Modify help description values as needed.
%defineArgument(spctrn_getConfig_dDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_getConfig_dDefinition, "name", "char", "input", <SHAPE>); % '<MLTYPE>' can be char, or string
%defineOutput(spctrn_getConfig_dDefinition, "RetVal", "double");
%validate(spctrn_getConfig_dDefinition);

%% C++ function |spctrn_init| with MATLAB name |clib.spctrnWrp.spctrn_init|
% C++ Signature: uint32_t spctrn_init(uint32_t memory)
spctrn_initDefinition = addFunction(libDef, ...
    "uint32_t spctrn_init(uint32_t memory)", ...
    "MATLABName", "clib.spctrnWrp.spctrn_init", ...
    "Description", "clib.spctrnWrp.spctrn_init    Representation of C++ function spctrn_init."); % Modify help description values as needed.
defineArgument(spctrn_initDefinition, "memory", "uint32");
defineOutput(spctrn_initDefinition, "RetVal", "uint32");
validate(spctrn_initDefinition);

%% C++ function |spctrn_shutdown| with MATLAB name |clib.spctrnWrp.spctrn_shutdown|
% C++ Signature: uint32_t spctrn_shutdown()
spctrn_shutdownDefinition = addFunction(libDef, ...
    "uint32_t spctrn_shutdown()", ...
    "MATLABName", "clib.spctrnWrp.spctrn_shutdown", ...
    "Description", "clib.spctrnWrp.spctrn_shutdown    Representation of C++ function spctrn_shutdown."); % Modify help description values as needed.
defineOutput(spctrn_shutdownDefinition, "RetVal", "uint32");
validate(spctrn_shutdownDefinition);

%% C++ function |spctrn_getConfig_s| with MATLAB name |clib.spctrnWrp.spctrn_getConfig_s|
% C++ Signature: wchar_t const * spctrn_getConfig_s(AARTSAAPI_Device * device_ptr,wchar_t const * name,wchar_t * value,int64_t size_value)
%spctrn_getConfig_sDefinition = addFunction(libDef, ...
%    "wchar_t const * spctrn_getConfig_s(AARTSAAPI_Device * device_ptr,wchar_t const * name,wchar_t * value,int64_t size_value)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_getConfig_s", ...
%    "Description", "clib.spctrnWrp.spctrn_getConfig_s    Representation of C++ function spctrn_getConfig_s."); % Modify help description values as needed.
%defineArgument(spctrn_getConfig_sDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_getConfig_sDefinition, "name", "char", "input", <SHAPE>); % '<MLTYPE>' can be char, or string
%defineArgument(spctrn_getConfig_sDefinition, "value", "char", <DIRECTION>, <SHAPE>); % '<MLTYPE>' can be char, or string
%defineArgument(spctrn_getConfig_sDefinition, "size_value", "int64");
%defineOutput(spctrn_getConfig_sDefinition, "RetVal", "char", <SHAPE>); % '<MLTYPE>' can be char, or string
%validate(spctrn_getConfig_sDefinition);

%% C++ function |spctrn_setConfig_i| with MATLAB name |clib.spctrnWrp.spctrn_setConfig_i|
% C++ Signature: uint32_t spctrn_setConfig_i(AARTSAAPI_Device * device_ptr,wchar_t const * name,int64_t value)
%spctrn_setConfig_iDefinition = addFunction(libDef, ...
%    "uint32_t spctrn_setConfig_i(AARTSAAPI_Device * device_ptr,wchar_t const * name,int64_t value)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_setConfig_i", ...
%    "Description", "clib.spctrnWrp.spctrn_setConfig_i    Representation of C++ function spctrn_setConfig_i."); % Modify help description values as needed.
%defineArgument(spctrn_setConfig_iDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_setConfig_iDefinition, "name", "char", "input", <SHAPE>); % '<MLTYPE>' can be char, or string
%defineArgument(spctrn_setConfig_iDefinition, "value", "int64");
%defineOutput(spctrn_setConfig_iDefinition, "RetVal", "uint32");
%validate(spctrn_setConfig_iDefinition);

%% C++ function |spctrn_getConfig_i| with MATLAB name |clib.spctrnWrp.spctrn_getConfig_i|
% C++ Signature: int64_t spctrn_getConfig_i(AARTSAAPI_Device * device_ptr,wchar_t const * name)
%spctrn_getConfig_iDefinition = addFunction(libDef, ...
%    "int64_t spctrn_getConfig_i(AARTSAAPI_Device * device_ptr,wchar_t const * name)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_getConfig_i", ...
%    "Description", "clib.spctrnWrp.spctrn_getConfig_i    Representation of C++ function spctrn_getConfig_i."); % Modify help description values as needed.
%defineArgument(spctrn_getConfig_iDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_getConfig_iDefinition, "name", "char", "input", <SHAPE>); % '<MLTYPE>' can be char, or string
%defineOutput(spctrn_getConfig_iDefinition, "RetVal", "int64");
%validate(spctrn_getConfig_iDefinition);

%% C++ function |spctrn_sendPacket| with MATLAB name |clib.spctrnWrp.spctrn_sendPacket|
% C++ Signature: uint32_t spctrn_sendPacket(AARTSAAPI_Device * device_ptr,int32_t const & channel,AARTSAAPI_Packet * packet_ptr)
%spctrn_sendPacketDefinition = addFunction(libDef, ...
%    "uint32_t spctrn_sendPacket(AARTSAAPI_Device * device_ptr,int32_t const & channel,AARTSAAPI_Packet * packet_ptr)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_sendPacket", ...
%    "Description", "clib.spctrnWrp.spctrn_sendPacket    Representation of C++ function spctrn_sendPacket."); % Modify help description values as needed.
%defineArgument(spctrn_sendPacketDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_sendPacketDefinition, "channel", "int32", "input");
%defineArgument(spctrn_sendPacketDefinition, "packet_ptr", "clib.spctrnWrp.AARTSAAPI_Packet", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Packet, or clib.array.spctrnWrp.AARTSAAPI_Packet
%defineOutput(spctrn_sendPacketDefinition, "RetVal", "uint32");
%validate(spctrn_sendPacketDefinition);

%% C++ function |spctrn_sendData| with MATLAB name |clib.spctrnWrp.spctrn_sendData|
% C++ Signature: double spctrn_sendData(AARTSAAPI_Device * device_ptr,int32_t const & channel,double const & centerF,double const & rate,double const & span,double const & start,int64_t const & num,float * data,int32_t const & loop,bool const & absoluteTime)
%spctrn_sendDataDefinition = addFunction(libDef, ...
%    "double spctrn_sendData(AARTSAAPI_Device * device_ptr,int32_t const & channel,double const & centerF,double const & rate,double const & span,double const & start,int64_t const & num,float * data,int32_t const & loop,bool const & absoluteTime)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_sendData", ...
%    "Description", "clib.spctrnWrp.spctrn_sendData    Representation of C++ function spctrn_sendData."); % Modify help description values as needed.
%defineArgument(spctrn_sendDataDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_sendDataDefinition, "channel", "int32", "input");
%defineArgument(spctrn_sendDataDefinition, "centerF", "double", "input");
%defineArgument(spctrn_sendDataDefinition, "rate", "double", "input");
%defineArgument(spctrn_sendDataDefinition, "span", "double", "input");
%defineArgument(spctrn_sendDataDefinition, "start", "double", "input");
%defineArgument(spctrn_sendDataDefinition, "num", "int64", "input");
%defineArgument(spctrn_sendDataDefinition, "data", "clib.array.spctrnWrp.Float", "input", <SHAPE>); % '<MLTYPE>' can be clib.array.spctrnWrp.Float, or single
%defineArgument(spctrn_sendDataDefinition, "loop", "int32", "input");
%defineArgument(spctrn_sendDataDefinition, "absoluteTime", "logical", "input");
%defineOutput(spctrn_sendDataDefinition, "RetVal", "double");
%validate(spctrn_sendDataDefinition);

%% C++ function |spctrn_deviceState| with MATLAB name |clib.spctrnWrp.spctrn_deviceState|
% C++ Signature: uint32_t spctrn_deviceState(AARTSAAPI_Device * device_ptr)
%spctrn_deviceStateDefinition = addFunction(libDef, ...
%    "uint32_t spctrn_deviceState(AARTSAAPI_Device * device_ptr)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_deviceState", ...
%    "Description", "clib.spctrnWrp.spctrn_deviceState    Representation of C++ function spctrn_deviceState."); % Modify help description values as needed.
%defineArgument(spctrn_deviceStateDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineOutput(spctrn_deviceStateDefinition, "RetVal", "uint32");
%validate(spctrn_deviceStateDefinition);

%% C++ function |spctrn_getApiHandle| with MATLAB name |clib.spctrnWrp.spctrn_getApiHandle|
% C++ Signature: uint64_t spctrn_getApiHandle()
spctrn_getApiHandleDefinition = addFunction(libDef, ...
    "uint64_t spctrn_getApiHandle()", ...
    "MATLABName", "clib.spctrnWrp.spctrn_getApiHandle", ...
    "Description", "clib.spctrnWrp.spctrn_getApiHandle    Representation of C++ function spctrn_getApiHandle."); % Modify help description values as needed.
defineOutput(spctrn_getApiHandleDefinition, "RetVal", "uint64");
validate(spctrn_getApiHandleDefinition);

%% C++ function |spctrn_getDeviceHandle| with MATLAB name |clib.spctrnWrp.spctrn_getDeviceHandle|
% C++ Signature: uint64_t spctrn_getDeviceHandle(AARTSAAPI_Device * device_ptr)
%spctrn_getDeviceHandleDefinition = addFunction(libDef, ...
%    "uint64_t spctrn_getDeviceHandle(AARTSAAPI_Device * device_ptr)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_getDeviceHandle", ...
%    "Description", "clib.spctrnWrp.spctrn_getDeviceHandle    Representation of C++ function spctrn_getDeviceHandle."); % Modify help description values as needed.
%defineArgument(spctrn_getDeviceHandleDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineOutput(spctrn_getDeviceHandleDefinition, "RetVal", "uint64");
%validate(spctrn_getDeviceHandleDefinition);

%% C++ function |spctrn_getIqData| with MATLAB name |clib.spctrnWrp.spctrn_getIqData|
% C++ Signature: uint32_t spctrn_getIqData(AARTSAAPI_Device * device_ptr,int32_t const & DeviceIndex,int32_t const & channel,int64_t const & numberOfSamples,double samplingRate,char const * filename,double const & start)
%spctrn_getIqDataDefinition = addFunction(libDef, ...
%    "uint32_t spctrn_getIqData(AARTSAAPI_Device * device_ptr,int32_t const & DeviceIndex,int32_t const & channel,int64_t const & numberOfSamples,double samplingRate,char const * filename,double const & start)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_getIqData", ...
%    "Description", "clib.spctrnWrp.spctrn_getIqData    Representation of C++ function spctrn_getIqData."); % Modify help description values as needed.
%defineArgument(spctrn_getIqDataDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_getIqDataDefinition, "DeviceIndex", "int32", "input");
%defineArgument(spctrn_getIqDataDefinition, "channel", "int32", "input");
%defineArgument(spctrn_getIqDataDefinition, "numberOfSamples", "int64", "input");
%defineArgument(spctrn_getIqDataDefinition, "samplingRate", "double");
%defineArgument(spctrn_getIqDataDefinition, "filename", <MLTYPE>, "input", <SHAPE>); % '<MLTYPE>' can be clib.array.spctrnWrp.Char,int8,string, or char
%defineArgument(spctrn_getIqDataDefinition, "start", "double", "input");
%defineOutput(spctrn_getIqDataDefinition, "RetVal", "uint32");
%validate(spctrn_getIqDataDefinition);

%% C++ function |spctrn_getSpectraData| with MATLAB name |clib.spctrnWrp.spctrn_getSpectraData|
% C++ Signature: uint32_t spctrn_getSpectraData(AARTSAAPI_Device * device_ptr,int32_t const & DeviceIndex,int32_t const & channel,size_t numberOfSamples,double samplingRate,char const * filename,double const & start)
%spctrn_getSpectraDataDefinition = addFunction(libDef, ...
%    "uint32_t spctrn_getSpectraData(AARTSAAPI_Device * device_ptr,int32_t const & DeviceIndex,int32_t const & channel,size_t numberOfSamples,double samplingRate,char const * filename,double const & start)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_getSpectraData", ...
%    "Description", "clib.spctrnWrp.spctrn_getSpectraData    Representation of C++ function spctrn_getSpectraData."); % Modify help description values as needed.
%defineArgument(spctrn_getSpectraDataDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_getSpectraDataDefinition, "DeviceIndex", "int32", "input");
%defineArgument(spctrn_getSpectraDataDefinition, "channel", "int32", "input");
%defineArgument(spctrn_getSpectraDataDefinition, "numberOfSamples", "uint64");
%defineArgument(spctrn_getSpectraDataDefinition, "samplingRate", "double");
%defineArgument(spctrn_getSpectraDataDefinition, "filename", <MLTYPE>, "input", <SHAPE>); % '<MLTYPE>' can be clib.array.spctrnWrp.Char,int8,string, or char
%defineArgument(spctrn_getSpectraDataDefinition, "start", "double", "input");
%defineOutput(spctrn_getSpectraDataDefinition, "RetVal", "uint32");
%validate(spctrn_getSpectraDataDefinition);

%% C++ function |spctrn_getConfigOptions| with MATLAB name |clib.spctrnWrp.spctrn_getConfigOptions|
% C++ Signature: wchar_t const * spctrn_getConfigOptions(AARTSAAPI_Device * device_ptr,wchar_t const * name,wchar_t * value,int64_t size_value)
%spctrn_getConfigOptionsDefinition = addFunction(libDef, ...
%    "wchar_t const * spctrn_getConfigOptions(AARTSAAPI_Device * device_ptr,wchar_t const * name,wchar_t * value,int64_t size_value)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_getConfigOptions", ...
%    "Description", "clib.spctrnWrp.spctrn_getConfigOptions    Representation of C++ function spctrn_getConfigOptions."); % Modify help description values as needed.
%defineArgument(spctrn_getConfigOptionsDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_getConfigOptionsDefinition, "name", "char", "input", <SHAPE>); % '<MLTYPE>' can be char, or string
%defineArgument(spctrn_getConfigOptionsDefinition, "value", "char", <DIRECTION>, <SHAPE>); % '<MLTYPE>' can be char, or string
%defineArgument(spctrn_getConfigOptionsDefinition, "size_value", "int64");
%defineOutput(spctrn_getConfigOptionsDefinition, "RetVal", "char", <SHAPE>); % '<MLTYPE>' can be char, or string
%validate(spctrn_getConfigOptionsDefinition);

%% C++ function |spctrn_transceiveData| with MATLAB name |clib.spctrnWrp.spctrn_transceiveData|
% C++ Signature: uint32_t spctrn_transceiveData(AARTSAAPI_Device * device_ptr,int32_t const & index,int32_t const & channelTrans,int32_t const & channelRec,double const & centerFTrans,double const & centerFRec,double const & samplingRateTrans,double const & samplingRateRec,double const & spanTrans,double const & spanRec,int64_t const & numTrans,int32_t const & numRec,float * data,double const & startTrans,double const & startRec,int32_t const & loop,char const * filename)
%spctrn_transceiveDataDefinition = addFunction(libDef, ...
%    "uint32_t spctrn_transceiveData(AARTSAAPI_Device * device_ptr,int32_t const & index,int32_t const & channelTrans,int32_t const & channelRec,double const & centerFTrans,double const & centerFRec,double const & samplingRateTrans,double const & samplingRateRec,double const & spanTrans,double const & spanRec,int64_t const & numTrans,int32_t const & numRec,float * data,double const & startTrans,double const & startRec,int32_t const & loop,char const * filename)", ...
%    "MATLABName", "clib.spctrnWrp.spctrn_transceiveData", ...
%    "Description", "clib.spctrnWrp.spctrn_transceiveData    Representation of C++ function spctrn_transceiveData."); % Modify help description values as needed.
%defineArgument(spctrn_transceiveDataDefinition, "device_ptr", "clib.spctrnWrp.AARTSAAPI_Device", "input", <SHAPE>); % '<MLTYPE>' can be clib.spctrnWrp.AARTSAAPI_Device, or clib.array.spctrnWrp.AARTSAAPI_Device
%defineArgument(spctrn_transceiveDataDefinition, "index", "int32", "input");
%defineArgument(spctrn_transceiveDataDefinition, "channelTrans", "int32", "input");
%defineArgument(spctrn_transceiveDataDefinition, "channelRec", "int32", "input");
%defineArgument(spctrn_transceiveDataDefinition, "centerFTrans", "double", "input");
%defineArgument(spctrn_transceiveDataDefinition, "centerFRec", "double", "input");
%defineArgument(spctrn_transceiveDataDefinition, "samplingRateTrans", "double", "input");
%defineArgument(spctrn_transceiveDataDefinition, "samplingRateRec", "double", "input");
%defineArgument(spctrn_transceiveDataDefinition, "spanTrans", "double", "input");
%defineArgument(spctrn_transceiveDataDefinition, "spanRec", "double", "input");
%defineArgument(spctrn_transceiveDataDefinition, "numTrans", "int64", "input");
%defineArgument(spctrn_transceiveDataDefinition, "numRec", "int32", "input");
%defineArgument(spctrn_transceiveDataDefinition, "data", "clib.array.spctrnWrp.Float", "input", <SHAPE>); % '<MLTYPE>' can be clib.array.spctrnWrp.Float, or single
%defineArgument(spctrn_transceiveDataDefinition, "startTrans", "double", "input");
%defineArgument(spctrn_transceiveDataDefinition, "startRec", "double", "input");
%defineArgument(spctrn_transceiveDataDefinition, "loop", "int32", "input");
%defineArgument(spctrn_transceiveDataDefinition, "filename", <MLTYPE>, "input", <SHAPE>); % '<MLTYPE>' can be clib.array.spctrnWrp.Char,int8,string, or char
%defineOutput(spctrn_transceiveDataDefinition, "RetVal", "uint32");
%validate(spctrn_transceiveDataDefinition);

%% Validate the library definition
validate(libDef);

end
