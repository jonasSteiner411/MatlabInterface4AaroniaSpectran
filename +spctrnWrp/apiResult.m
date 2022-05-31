classdef apiResult < uint32
    %APIRESULT enumeration class containing all spectran api error codes 
    %   and possible device states. 
    %   This enum class is mainly used in the api class for printing more
    %   sensible error messages from the generated error codes.
    %
    %apiResult codes:
    %   ok
    %   empt
    %   retry
    %   warning
    %   valueAdjusted
    %   valueDisabled
    %   error
    %   errorNotInitialized
    %   errorNotFound      
    %   errorBusy          
    %   errorNotOpen       
    %   errorNotConnected  
    %   errorInvalidConfig 
    %   errorBufferSize    
    %   errorInvalidChannel
    %   errorInvalidParam  
    %   errorInvalidSize   
    %   errorMissingPaths  
    %   errorValueInvalid  
    %   errorValueMalformed
    %
    %apiResult device states:
    %   idle
    %   connecting
    %   connected
    %   starting
    %   running
    %   stopping
    %   disconnecting
    %   
    %see also: api
    enumeration
        ok   (0x00000000),
        empt (0x00000001),
        retry(0x00000002),
        
        idle         (0x10000000),
        connecting   (0x10000001),
        connected    (0x10000002),
        starting     (0x10000003),
        running      (0x10000004),
        stopping     (0x10000005),
        disconnecting(0x10000006),
        
        warning      (0x40000000),
        valueAdjusted(0x40000001),
        valueDisabled(0x40000002),
        
        error              (0x80000000),
        errorNotInitialized(0x80000001),
        errorNotFound      (0x80000002),
        errorBusy          (0x80000003),
        errorNotOpen       (0x80000004),
        errorNotConnected  (0x80000005),
        errorInvalidConfig (0x80000006),
        errorBufferSize    (0x80000007),
        errorInvalidChannel(0x80000008),
        errorInvalidParam  (0x80000009),
        errorInvalidSize   (0x8000000a),
        errorMissingPaths  (0x8000000b),
        errorValueInvalid  (0x8000000c),
        errorValueMalformed(0x8000000d),
        
        errorWrpDllLoad         (0x81000001),
        errorAlreadyInitiallised(0x81000002)
        
    end
end

