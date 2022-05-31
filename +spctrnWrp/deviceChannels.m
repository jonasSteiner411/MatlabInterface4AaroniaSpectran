classdef deviceChannels < int32
    %DEVICECHANNEL Enumeration class for the data exchange channels of the
    %   spectran v6.
    %
    %hint: The transmitter uses the same channels as RX1.
    %
    %deviceChannels enumeration:
    %   iqRX1        - IQ Data channel for RX1.
    %   iqRX2        - IQ Data channel for RX2.
    %   spectraRX1   - Spectra Data channel for RX1.
    %   spectraRX2   - Spectra Data channel for RX1.
    %
    %deviceChannels methods:
    %   dim          - Get dimensions of the data on the specified channel.
   properties (Constant)
       iqRX1 = 0;
       iqRX2 = 0;
       spectraRX1 = 2;
       spectraRX2 = 2;
       iqTX = 0;
   end
   
   methods
       function y = dim(obj)
           %DEVICECHANNELS returns the dimensions for a given channel
           % dim(deviceChannels)
           %
           %y = dim()
           %
           %output arguments:
           %    y   - cell array of strings representing the dimensions of
           %          the data on this channel.
           if floor(double(obj) / 2) == 0
               y = {'time', 'I/Q'};
           else
               y = {'time', 'frequency'};
           end
       end
   end
end

