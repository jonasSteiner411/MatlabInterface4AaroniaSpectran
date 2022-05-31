classdef deviceTypes
    %DEVICETYPES is a class containing only constant string values which
    %   represent the different devices(operating modes) of the spectran v6.
    %
    %deviceTypes properties:
    %   iqReceiver      - "spectranv6/iqreceiver"
    %   iqTransmitter   - "spectranv6/iqtransmitter"
    %   iqTransmitter   - "spectranv6/iqtransceiver"
    %   iqRaw           - "spectranv6/raw"
    %   sweep           - "spectranv6/sweepsa"
    properties (Constant)
        iqReceiver string = "spectranv6/iqreceiver";
        iqTransmitter string = "spectranv6/iqtransmitter";
        iqTransceiver string = "spectranv6/iqtransceiver";
        iqRaw string = "spectranv6/raw";
        sweep string = "spectranv6/sweepsa";
    end
end

