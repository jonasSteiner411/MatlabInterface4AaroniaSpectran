% This document lists configuration elements that are available for the operation modes of the spectran V6.
% All seperate lists start with spectranv6/deviceName, where "deviceName" is one of the names used for an operation mode of the spectran V6, e.g. "iqreceiver", "iqraw"
% The configuration is made up of groups, which are expressed by opening and closing angled bracket expressions in XML-style: opening = <example>; closing </example>
% Also listed are ranges for numerical type values and options for enumerations, as well as a unit.
% 
% When using the configuration functions of the spectran api the respective name of any configuration element is made up of the name used in this document (the string before the colon) prefixed by all group names the respective element may be in.
% Any element (numeric, string, enum, group, etc.) that is contained in a group named "exampleGroup" gets prefixed by the string "exampleGroup/".
% For example when accessing/changing the value of the element named "fftsize" in the group "fft0", which itself is inside group "device" use the name "device/fft0/fftsize".
% When using the c++ api always use wide character strings that are null terminated.
%  
% spectranv6/iqreceiver
% <main>
% 	centerfreq : range = [5e+06, 6e+09], unit = Frequency
% 	reflevel : range = [-20, 10], unit = dBm
% 	spanfreq : range = [1, 2e+08], unit = Frequency
% </main>
% <device>
% 	usbcompression : enum = {auto;compressed;raw} disabled: {000}
% 	gaincontrol : enum = {manual;peak;power} disabled: {000}
% 	loharmonic : enum = {base;third;fifth} disabled: {000}
% 	outputformat : enum = {iq;spectra;both;auto} disabled: {0000}
% 	<fft0>
% 		fftmergemode : enum = {avg;sum;min;max} disabled: {0000}
% 		fftaggregate : range = [1, 65535], unit = 1
% 		fftsizemode : enum = {FFT;Bins;Step Frequency;RBW} disabled: {0000}
% 		fftsize : range = [8, 8192], unit = 1
% 		fftbinsize : range = [32, 8192], unit = 1
% 		fftstepfreq : range = [1000, 1e+08], unit = Frequency
% 		fftrbwfreq : range = [0.001, 1e+08], unit = Frequency
% 		fftwindow : enum = {Hamming;Hann;Uniform;Blackman;Blackman Harris;Blackman Harris 7;Flat Top;Lanczos;Gaussion 0.5;Gaussion 0.4;Gaussian 0.3;Gaussion 0.2;Gaussian 0.1;Kaiser 6;Kaiser 12;Kaiser 18;Kaiser 36;Kaiser 72;Tukey 0.1;Tukey 0.3;Tukey 0.5;Tukey 0.7;Tukey 0.9} disabled: {0000000000000000}
% 	</fft0>
% 	<fft1>
% 		fftmergemode : enum = {avg;sum;min;max} disabled: {0000}
% 		fftaggregate : range = [1, 65535], unit = 1
% 		fftsizemode : enum = {FFT;Bins;Step Frequency;RBW} disabled: {0000}
% 		fftsize : range = [8, 8192], unit = 1
% 		fftbinsize : range = [32, 8192], unit = 1
% 		fftstepfreq : range = [1000, 1e+08], unit = Frequency
% 		fftrbwfreq : range = [0.001, 1e+08], unit = Frequency
% 		fftwindow : enum = {Hamming;Hann;Uniform;Blackman;Blackman Harris;Blackman Harris 7;Flat Top;Lanczos;Gaussion 0.5;Gaussion 0.4;Gaussian 0.3;Gaussion 0.2;Gaussian 0.1;Kaiser 6;Kaiser 12;Kaiser 18;Kaiser 36;Kaiser 72;Tukey 0.1;Tukey 0.3;Tukey 0.5;Tukey 0.7;Tukey 0.9} disabled: {0000000000000000}
% 	</fft1>
% 	receiverclock : enum = {92MHz;122MHz;184MHz;245MHz} disabled: {0000}
% 	receiverchannel : enum = {Rx1;Rx2;Rx1+Rx2;Rx1/Rx2;Rx Off;auto} disabled: {000000}
% 	receiverchannelsel : enum = {Rx1;Rx2;Rx2->1;Rx1->2} disabled: {0000}
% 	transmittermode : enum = {Off;Test;Stream;Reactive;Signal Generator;Pattern Generator} disabled: {000000}
% 	<generator>
% 		type : enum = {Relative Tone;Absolute Tone;Step;Sweep;Full Sweep;Center Sweep;Polytone;Relative Ditone;Absolute Ditone;Noise;Digital Noise;Off} disabled: {000000000000}
% 		startfreq : range = [1000, 2e+10], unit = Frequency
% 		stopfreq : range = [1000, 2e+10], unit = Frequency
% 		stepfreq : range = [1, 2e+08], unit = Frequency
% 		offsetfreq : range = [-6e+07, 6e+07], unit = Frequency
% 		duration : range = [1e-05, 3600], unit = Time
% 		powerramp : range = [-150, 150], unit = dB
% 	</generator>
% 	sclksource : enum = {Consumer;Oscillator;GPS;Oscillator Provider;GPS Provider} disabled: {00101}
% 	gpsmode : enum = {Disabled;Location;Time;Location and Time} disabled: {0111}
% 	gpsrate : range = [0.1, 5], unit = Time
% 	tempfancontrol : boolean
% 	serial : wide character string
% </device>
% <calibration>
% 	rffilter : enum = {Calibration;Bypass;Auto;Auto Extended;75-145 (50);90-160 (50);110-195 (50);135-205 (50);155-270 (50);155-270 (100);155-280 (100);180-350 (100);230-460 (100);240-545;340-650;440-815;610-1055;850-1370;1162-2060;1850-3010;2800-4610;4400-6100} disabled: {0000000000000000}
% 	preamp : enum = {Disabled;Auto;None;Amp;Preamp;Both} disabled: {000000}
% 	rftxfilter : enum = {Calibration;Bypass;Auto;Auto Extended;75-145 (50);90-160 (50);110-195 (50);135-205 (50);155-270 (50);155-270 (100);155-280 (100);180-350 (100);230-460 (100);240-545;340-650;440-815;610-1055;850-1370;1162-2060;1850-3010;2800-4610;4400-6100} disabled: {0000000000000000}
% 	calibrationmode : enum = {Off;RX Attenuator;TX Attenuator;Tx No Amplifier;Tx Amplifier;Rx Thermal;Tx Thermal;Rx RTBW;Tx RTBW;Rx Filter;Rx Amplifier;Tx LO Leakage;Clock;Raw;Free} disabled: {000000000000000}
% 	txioffset : range = [-0.1, 0.1], unit = Number
% 	txqoffset : range = [-0.1, 0.1], unit = Number
% 	txexcent : range = [-0.1, 0.1], unit = Percentage
% 	txphaseskew : range = [-15, 15], unit = Degree
% 	clockscale : range = [-100, 100], unit = Frequency
% 	clockbygpsupdate : enum = {Never;Once;Reset;On Startup;Slow;Fast;Realtime} disabled: {0000000}
% 	calibrationreload : boolean
% </calibration>
% 
% 
% spectranv6/iqtransmitter
% <main>
% 	centerfreq : range = [1.925e+08, 6e+09], unit = Frequency
% 	spanfreq : range = [1, 2e+08], unit = Frequency
% 	transgain : range = [-100, 10], unit = dB
% </main>
% <device>
% 	usbcompression : enum = {auto;compressed;raw} disabled: {000}
% 	gaincontrol : enum = {manual;peak;power} disabled: {000}
% 	loharmonic : enum = {base;third;fifth} disabled: {000}
% 	outputformat : enum = {iq;spectra;both;auto} disabled: {0000}
% 	<fft0>
% 		fftmergemode : enum = {avg;sum;min;max} disabled: {0000}
% 		fftaggregate : range = [1, 65535], unit = 1
% 		fftsizemode : enum = {FFT;Bins;Step Frequency;RBW} disabled: {0000}
% 		fftsize : range = [8, 8192], unit = 1
% 		fftbinsize : range = [32, 8192], unit = 1
% 		fftstepfreq : range = [1000, 1e+08], unit = Frequency
% 		fftrbwfreq : range = [0.001, 1e+08], unit = Frequency
% 		fftwindow : enum = {Hamming;Hann;Uniform;Blackman;Blackman Harris;Blackman Harris 7;Flat Top;Lanczos;Gaussion 0.5;Gaussion 0.4;Gaussian 0.3;Gaussion 0.2;Gaussian 0.1;Kaiser 6;Kaiser 12;Kaiser 18;Kaiser 36;Kaiser 72;Tukey 0.1;Tukey 0.3;Tukey 0.5;Tukey 0.7;Tukey 0.9} disabled: {0000000000000000}
% 	</fft0>
% 	<fft1>
% 		fftmergemode : enum = {avg;sum;min;max} disabled: {0000}
% 		fftaggregate : range = [1, 65535], unit = 1
% 		fftsizemode : enum = {FFT;Bins;Step Frequency;RBW} disabled: {0000}
% 		fftsize : range = [8, 8192], unit = 1
% 		fftbinsize : range = [32, 8192], unit = 1
% 		fftstepfreq : range = [1000, 1e+08], unit = Frequency
% 		fftrbwfreq : range = [0.001, 1e+08], unit = Frequency
% 		fftwindow : enum = {Hamming;Hann;Uniform;Blackman;Blackman Harris;Blackman Harris 7;Flat Top;Lanczos;Gaussion 0.5;Gaussion 0.4;Gaussian 0.3;Gaussion 0.2;Gaussian 0.1;Kaiser 6;Kaiser 12;Kaiser 18;Kaiser 36;Kaiser 72;Tukey 0.1;Tukey 0.3;Tukey 0.5;Tukey 0.7;Tukey 0.9} disabled: {0000000000000000}
% 	</fft1>
% 	receiverclock : enum = {92MHz;122MHz;184MHz;245MHz} disabled: {0011}
% 	receiverchannel : enum = {Rx1;Rx2;Rx1+Rx2;Rx1/Rx2;Rx Off;auto} disabled: {000000}
% 	receiverchannelsel : enum = {Rx1;Rx2;Rx2->1;Rx1->2} disabled: {0000}
% 	transmittermode : enum = {Off;Test;Stream;Reactive;Signal Generator;Pattern Generator} disabled: {000000}
% 	<generator>
% 		type : enum = {Relative Tone;Absolute Tone;Step;Sweep;Full Sweep;Center Sweep;Polytone;Relative Ditone;Absolute Ditone;Noise;Digital Noise;Off} disabled: {000000000000}
% 		startfreq : range = [1000, 2e+10], unit = Frequency
% 		stopfreq : range = [1000, 2e+10], unit = Frequency
% 		stepfreq : range = [1, 2e+08], unit = Frequency
% 		offsetfreq : range = [-6e+07, 6e+07], unit = Frequency
% 		duration : range = [1e-05, 3600], unit = Time
% 		powerramp : range = [-150, 150], unit = dB
% 	</generator>
% 	sclksource : enum = {Consumer;Oscillator;GPS;Oscillator Provider;GPS Provider} disabled: {00101}
% 	gpsmode : enum = {Disabled;Location;Time;Location and Time} disabled: {0111}
% 	gpsrate : range = [0.1, 5], unit = Time
% 	tempfancontrol : boolean
% 	serial : wide character string
% </device>
% <calibration>
% 	rffilter : enum = {Calibration;Bypass;Auto;Auto Extended;75-145 (50);90-160 (50);110-195 (50);135-205 (50);155-270 (50);155-270 (100);155-280 (100);180-350 (100);230-460 (100);240-545;340-650;440-815;610-1055;850-1370;1162-2060;1850-3010;2800-4610;4400-6100} disabled: {0000000000000000}
% 	preamp : enum = {Disabled;Auto;None;Amp;Preamp;Both} disabled: {000000}
% 	rftxfilter : enum = {Calibration;Bypass;Auto;Auto Extended;75-145 (50);90-160 (50);110-195 (50);135-205 (50);155-270 (50);155-270 (100);155-280 (100);180-350 (100);230-460 (100);240-545;340-650;440-815;610-1055;850-1370;1162-2060;1850-3010;2800-4610;4400-6100} disabled: {0000000000000000}
% 	calibrationmode : enum = {Off;RX Attenuator;TX Attenuator;Tx No Amplifier;Tx Amplifier;Rx Thermal;Tx Thermal;Rx RTBW;Tx RTBW;Rx Filter;Rx Amplifier;Tx LO Leakage;Clock;Raw;Free} disabled: {000000000000000}
% 	txioffset : range = [-0.1, 0.1], unit = Number
% 	txqoffset : range = [-0.1, 0.1], unit = Number
% 	txexcent : range = [-0.1, 0.1], unit = Percentage
% 	txphaseskew : range = [-15, 15], unit = Degree
% 	clockscale : range = [-100, 100], unit = Frequency
% 	clockbygpsupdate : enum = {Never;Once;Reset;On Startup;Slow;Fast;Realtime} disabled: {0000000}
% 	calibrationreload : boolean
% </calibration>
% 
% 
% spectranv6/raw
% <main>
% 	centerfreq : range = [1.925e+08, 6e+09], unit = Frequency
% 	decimation : enum = {Full;1 / 2;1 / 4;1 / 8;1 / 16;1 / 32;1 / 64;1 / 128;1 / 256;1 / 512} disabled: {0000000000}
% 	reflevel : range = [-20, 10], unit = dBm
% 	transgain : range = [-100, 10], unit = dB
% </main>
% <device>
% 	usbcompression : enum = {auto;compressed;raw} disabled: {000}
% 	gaincontrol : enum = {manual;peak;power} disabled: {000}
% 	loharmonic : enum = {base;third;fifth} disabled: {000}
% 	outputformat : enum = {iq;spectra;both;auto} disabled: {0000}
% 	<fft0>
% 		fftmergemode : enum = {avg;sum;min;max} disabled: {0000}
% 		fftaggregate : range = [1, 65535], unit = 1
% 		fftsizemode : enum = {FFT;Bins;Step Frequency;RBW} disabled: {0000}
% 		fftsize : range = [8, 8192], unit = 1
% 		fftbinsize : range = [32, 8192], unit = 1
% 		fftstepfreq : range = [1000, 1e+08], unit = Frequency
% 		fftrbwfreq : range = [0.001, 1e+08], unit = Frequency
% 		fftwindow : enum = {Hamming;Hann;Uniform;Blackman;Blackman Harris;Blackman Harris 7;Flat Top;Lanczos;Gaussion 0.5;Gaussion 0.4;Gaussian 0.3;Gaussion 0.2;Gaussian 0.1;Kaiser 6;Kaiser 12;Kaiser 18;Kaiser 36;Kaiser 72;Tukey 0.1;Tukey 0.3;Tukey 0.5;Tukey 0.7;Tukey 0.9} disabled: {0000000000000000}
% 	</fft0>
% 	<fft1>
% 		fftmergemode : enum = {avg;sum;min;max} disabled: {0000}
% 		fftaggregate : range = [1, 65535], unit = 1
% 		fftsizemode : enum = {FFT;Bins;Step Frequency;RBW} disabled: {0000}
% 		fftsize : range = [8, 8192], unit = 1
% 		fftbinsize : range = [32, 8192], unit = 1
% 		fftstepfreq : range = [1000, 1e+08], unit = Frequency
% 		fftrbwfreq : range = [0.001, 1e+08], unit = Frequency
% 		fftwindow : enum = {Hamming;Hann;Uniform;Blackman;Blackman Harris;Blackman Harris 7;Flat Top;Lanczos;Gaussion 0.5;Gaussion 0.4;Gaussian 0.3;Gaussion 0.2;Gaussian 0.1;Kaiser 6;Kaiser 12;Kaiser 18;Kaiser 36;Kaiser 72;Tukey 0.1;Tukey 0.3;Tukey 0.5;Tukey 0.7;Tukey 0.9} disabled: {0000000000000000}
% 	</fft1>
% 	receiverclock : enum = {92MHz;122MHz;184MHz;245MHz} disabled: {0000}
% 	receiverchannel : enum = {Rx1;Rx2;Rx1+Rx2;Rx1/Rx2;Rx Off;auto} disabled: {000000}
% 	receiverchannelsel : enum = {Rx1;Rx2;Rx2->1;Rx1->2} disabled: {0000}
% 	transmittermode : enum = {Off;Test;Stream;Reactive;Signal Generator;Pattern Generator} disabled: {000000}
% 	<generator>
% 		type : enum = {Relative Tone;Absolute Tone;Step;Sweep;Full Sweep;Center Sweep;Polytone;Relative Ditone;Absolute Ditone;Noise;Digital Noise;Off} disabled: {000000000000}
% 		startfreq : range = [1000, 2e+10], unit = Frequency
% 		stopfreq : range = [1000, 2e+10], unit = Frequency
% 		stepfreq : range = [1, 2e+08], unit = Frequency
% 		offsetfreq : range = [-6e+07, 6e+07], unit = Frequency
% 		duration : range = [1e-05, 3600], unit = Time
% 		powerramp : range = [-150, 150], unit = dB
% 	</generator>
% 	sclksource : enum = {Consumer;Oscillator;GPS;Oscillator Provider;GPS Provider} disabled: {00101}
% 	gpsmode : enum = {Disabled;Location;Time;Location and Time} disabled: {0111}
% 	gpsrate : range = [0.1, 5], unit = Time
% 	tempfancontrol : boolean
% 	serial : wide character string
% </device>
% <calibration>
% 	rffilter : enum = {Calibration;Bypass;Auto;Auto Extended;75-145 (50);90-160 (50);110-195 (50);135-205 (50);155-270 (50);155-270 (100);155-280 (100);180-350 (100);230-460 (100);240-545;340-650;440-815;610-1055;850-1370;1162-2060;1850-3010;2800-4610;4400-6100} disabled: {0000000000000000}
% 	preamp : enum = {Disabled;Auto;None;Amp;Preamp;Both} disabled: {000000}
% 	rftxfilter : enum = {Calibration;Bypass;Auto;Auto Extended;75-145 (50);90-160 (50);110-195 (50);135-205 (50);155-270 (50);155-270 (100);155-280 (100);180-350 (100);230-460 (100);240-545;340-650;440-815;610-1055;850-1370;1162-2060;1850-3010;2800-4610;4400-6100} disabled: {0000000000000000}
% 	calibrationmode : enum = {Off;RX Attenuator;TX Attenuator;Tx No Amplifier;Tx Amplifier;Rx Thermal;Tx Thermal;Rx RTBW;Tx RTBW;Rx Filter;Rx Amplifier;Tx LO Leakage;Clock;Raw;Free} disabled: {000000000000000}
% 	txioffset : range = [-0.1, 0.1], unit = Number
% 	txqoffset : range = [-0.1, 0.1], unit = Number
% 	txexcent : range = [-0.1, 0.1], unit = Percentage
% 	txphaseskew : range = [-15, 15], unit = Degree
% 	clockscale : range = [-100, 100], unit = Frequency
% 	clockbygpsupdate : enum = {Never;Once;Reset;On Startup;Slow;Fast;Realtime} disabled: {0000000}
% 	calibrationreload : boolean
% </calibration>
% 
% 
% spectranv6/sweepsa
% <main>
% 	startfreq : range = [5e+06, 6e+09], unit = Frequency
% 	stopfreq : range = [5e+06, 6e+09], unit = Frequency
% 	reflevel : range = [-20, 10], unit = dBm
% 	rbwfreq : range = [0.01, 1e+07], unit = Frequency
% </main>
% <device>
% 	usbcompression : enum = {auto;compressed;raw} disabled: {000}
% 	gaincontrol : enum = {manual;peak;power} disabled: {000}
% 	loharmonic : enum = {base;third;fifth} disabled: {000}
% 	outputformat : enum = {iq;spectra;both;auto} disabled: {0000}
% 	<fft0>
% 		fftmergemode : enum = {avg;sum;min;max} disabled: {0000}
% 		fftaggregate : range = [1, 65535], unit = 1
% 		fftsizemode : enum = {FFT;Bins;Step Frequency;RBW} disabled: {0000}
% 		fftsize : range = [8, 8192], unit = 1
% 		fftbinsize : range = [32, 8192], unit = 1
% 		fftstepfreq : range = [1000, 1e+08], unit = Frequency
% 		fftrbwfreq : range = [0.001, 1e+08], unit = Frequency
% 		fftwindow : enum = {Hamming;Hann;Uniform;Blackman;Blackman Harris;Blackman Harris 7;Flat Top;Lanczos;Gaussion 0.5;Gaussion 0.4;Gaussian 0.3;Gaussion 0.2;Gaussian 0.1;Kaiser 6;Kaiser 12;Kaiser 18;Kaiser 36;Kaiser 72;Tukey 0.1;Tukey 0.3;Tukey 0.5;Tukey 0.7;Tukey 0.9} disabled: {0000000000000000}
% 	</fft0>
% 	<fft1>
% 		fftmergemode : enum = {avg;sum;min;max} disabled: {0000}
% 		fftaggregate : range = [1, 65535], unit = 1
% 		fftsizemode : enum = {FFT;Bins;Step Frequency;RBW} disabled: {0000}
% 		fftsize : range = [8, 8192], unit = 1
% 		fftbinsize : range = [32, 8192], unit = 1
% 		fftstepfreq : range = [1000, 1e+08], unit = Frequency
% 		fftrbwfreq : range = [0.001, 1e+08], unit = Frequency
% 		fftwindow : enum = {Hamming;Hann;Uniform;Blackman;Blackman Harris;Blackman Harris 7;Flat Top;Lanczos;Gaussion 0.5;Gaussion 0.4;Gaussian 0.3;Gaussion 0.2;Gaussian 0.1;Kaiser 6;Kaiser 12;Kaiser 18;Kaiser 36;Kaiser 72;Tukey 0.1;Tukey 0.3;Tukey 0.5;Tukey 0.7;Tukey 0.9} disabled: {0000000000000000}
% 	</fft1>
% 	receiverclock : enum = {92MHz;122MHz;184MHz;245MHz} disabled: {0000}
% 	receiverchannel : enum = {Rx1;Rx2;Rx1+Rx2;Rx1/Rx2;Rx Off;auto} disabled: {000000}
% 	receiverchannelsel : enum = {Rx1;Rx2;Rx2->1;Rx1->2} disabled: {0000}
% 	transmittermode : enum = {Off;Test;Stream;Reactive;Signal Generator;Pattern Generator} disabled: {000000}
% 	<generator>
% 		type : enum = {Relative Tone;Absolute Tone;Step;Sweep;Full Sweep;Center Sweep;Polytone;Relative Ditone;Absolute Ditone;Noise;Digital Noise;Off} disabled: {000000000000}
% 		startfreq : range = [1000, 2e+10], unit = Frequency
% 		stopfreq : range = [1000, 2e+10], unit = Frequency
% 		stepfreq : range = [1, 2e+08], unit = Frequency
% 		offsetfreq : range = [-6e+07, 6e+07], unit = Frequency
% 		duration : range = [1e-05, 3600], unit = Time
% 		powerramp : range = [-150, 150], unit = dB
% 	</generator>
% 	sclksource : enum = {Consumer;Oscillator;GPS;Oscillator Provider;GPS Provider} disabled: {00101}
% 	gpsmode : enum = {Disabled;Location;Time;Location and Time} disabled: {0111}
% 	gpsrate : range = [0.1, 5], unit = Time
% 	tempfancontrol : boolean
% 	serial : wide character string
% </device>
% <calibration>
% 	rffilter : enum = {Calibration;Bypass;Auto;Auto Extended;75-145 (50);90-160 (50);110-195 (50);135-205 (50);155-270 (50);155-270 (100);155-280 (100);180-350 (100);230-460 (100);240-545;340-650;440-815;610-1055;850-1370;1162-2060;1850-3010;2800-4610;4400-6100} disabled: {0000000000000000}
% 	preamp : enum = {Disabled;Auto;None;Amp;Preamp;Both} disabled: {000000}
% 	rftxfilter : enum = {Calibration;Bypass;Auto;Auto Extended;75-145 (50);90-160 (50);110-195 (50);135-205 (50);155-270 (50);155-270 (100);155-280 (100);180-350 (100);230-460 (100);240-545;340-650;440-815;610-1055;850-1370;1162-2060;1850-3010;2800-4610;4400-6100} disabled: {0000000000000000}
% 	calibrationmode : enum = {Off;RX Attenuator;TX Attenuator;Tx No Amplifier;Tx Amplifier;Rx Thermal;Tx Thermal;Rx RTBW;Tx RTBW;Rx Filter;Rx Amplifier;Tx LO Leakage;Clock;Raw;Free} disabled: {000000000000000}
% 	txioffset : range = [-0.1, 0.1], unit = Number
% 	txqoffset : range = [-0.1, 0.1], unit = Number
% 	txexcent : range = [-0.1, 0.1], unit = Percentage
% 	txphaseskew : range = [-15, 15], unit = Degree
% 	clockscale : range = [-100, 100], unit = Frequency
% 	clockbygpsupdate : enum = {Never;Once;Reset;On Startup;Slow;Fast;Realtime} disabled: {0000000}
% 	calibrationreload : boolean
% </calibration>
% 
% 
% spectranv6/iqtransceiver
% <main>
% 	centerfreq : range = [5e+06, 6e+09], unit = Frequency
% 	demodcenterfreq : range = [5e+06, 6e+09], unit = Frequency
% 	reflevel : range = [-20, 10], unit = dBm
% 	spanfreq : range = [1, 2e+08], unit = Frequency
% 	demodspanfreq : range = [1, 2e+08], unit = Frequency
% 	transgain : range = [-100, 10], unit = dB
% </main>
% <device>
% 	usbcompression : enum = {auto;compressed;raw} disabled: {000}
% 	gaincontrol : enum = {manual;peak;power} disabled: {000}
% 	loharmonic : enum = {base;third;fifth} disabled: {000}
% 	outputformat : enum = {iq;spectra;both;auto} disabled: {0000}
% 	<fft0>
% 		fftmergemode : enum = {avg;sum;min;max} disabled: {0000}
% 		fftaggregate : range = [1, 65535], unit = 1
% 		fftsizemode : enum = {FFT;Bins;Step Frequency;RBW} disabled: {0000}
% 		fftsize : range = [8, 8192], unit = 1
% 		fftbinsize : range = [32, 8192], unit = 1
% 		fftstepfreq : range = [1000, 1e+08], unit = Frequency
% 		fftrbwfreq : range = [0.001, 1e+08], unit = Frequency
% 		fftwindow : enum = {Hamming;Hann;Uniform;Blackman;Blackman Harris;Blackman Harris 7;Flat Top;Lanczos;Gaussion 0.5;Gaussion 0.4;Gaussian 0.3;Gaussion 0.2;Gaussian 0.1;Kaiser 6;Kaiser 12;Kaiser 18;Kaiser 36;Kaiser 72;Tukey 0.1;Tukey 0.3;Tukey 0.5;Tukey 0.7;Tukey 0.9} disabled: {0000000000000000}
% 	</fft0>
% 	<fft1>
% 		fftmergemode : enum = {avg;sum;min;max} disabled: {0000}
% 		fftaggregate : range = [1, 65535], unit = 1
% 		fftsizemode : enum = {FFT;Bins;Step Frequency;RBW} disabled: {0000}
% 		fftsize : range = [8, 8192], unit = 1
% 		fftbinsize : range = [32, 8192], unit = 1
% 		fftstepfreq : range = [1000, 1e+08], unit = Frequency
% 		fftrbwfreq : range = [0.001, 1e+08], unit = Frequency
% 		fftwindow : enum = {Hamming;Hann;Uniform;Blackman;Blackman Harris;Blackman Harris 7;Flat Top;Lanczos;Gaussion 0.5;Gaussion 0.4;Gaussian 0.3;Gaussion 0.2;Gaussian 0.1;Kaiser 6;Kaiser 12;Kaiser 18;Kaiser 36;Kaiser 72;Tukey 0.1;Tukey 0.3;Tukey 0.5;Tukey 0.7;Tukey 0.9} disabled: {0000000000000000}
% 	</fft1>
% 	receiverclock : enum = {92MHz;122MHz;184MHz;245MHz} disabled: {0011}
% 	receiverchannel : enum = {Rx1;Rx2;Rx1+Rx2;Rx1/Rx2;Rx Off;auto} disabled: {000000}
% 	receiverchannelsel : enum = {Rx1;Rx2;Rx2->1;Rx1->2} disabled: {0000}
% 	transmittermode : enum = {Off;Test;Stream;Reactive;Signal Generator;Pattern Generator} disabled: {000000}
% 	<generator>
% 		type : enum = {Relative Tone;Absolute Tone;Step;Sweep;Full Sweep;Center Sweep;Polytone;Relative Ditone;Absolute Ditone;Noise;Digital Noise;Off} disabled: {000000000000}
% 		startfreq : range = [1000, 2e+10], unit = Frequency
% 		stopfreq : range = [1000, 2e+10], unit = Frequency
% 		stepfreq : range = [1, 2e+08], unit = Frequency
% 		offsetfreq : range = [-6e+07, 6e+07], unit = Frequency
% 		duration : range = [1e-05, 3600], unit = Time
% 		powerramp : range = [-150, 150], unit = dB
% 	</generator>
% 	sclksource : enum = {Consumer;Oscillator;GPS;Oscillator Provider;GPS Provider} disabled: {00101}
% 	gpsmode : enum = {Disabled;Location;Time;Location and Time} disabled: {0111}
% 	gpsrate : range = [0.1, 5], unit = Time
% 	tempfancontrol : boolean
% 	serial : wide character string
% </device>
% <calibration>
% 	rffilter : enum = {Calibration;Bypass;Auto;Auto Extended;75-145 (50);90-160 (50);110-195 (50);135-205 (50);155-270 (50);155-270 (100);155-280 (100);180-350 (100);230-460 (100);240-545;340-650;440-815;610-1055;850-1370;1162-2060;1850-3010;2800-4610;4400-6100} disabled: {0000000000000000}
% 	preamp : enum = {Disabled;Auto;None;Amp;Preamp;Both} disabled: {000000}
% 	rftxfilter : enum = {Calibration;Bypass;Auto;Auto Extended;75-145 (50);90-160 (50);110-195 (50);135-205 (50);155-270 (50);155-270 (100);155-280 (100);180-350 (100);230-460 (100);240-545;340-650;440-815;610-1055;850-1370;1162-2060;1850-3010;2800-4610;4400-6100} disabled: {0000000000000000}
% 	calibrationmode : enum = {Off;RX Attenuator;TX Attenuator;Tx No Amplifier;Tx Amplifier;Rx Thermal;Tx Thermal;Rx RTBW;Tx RTBW;Rx Filter;Rx Amplifier;Tx LO Leakage;Clock;Raw;Free} disabled: {000000000000000}
% 	txioffset : range = [-0.1, 0.1], unit = Number
% 	txqoffset : range = [-0.1, 0.1], unit = Number
% 	txexcent : range = [-0.1, 0.1], unit = Percentage
% 	txphaseskew : range = [-15, 15], unit = Degree
% 	clockscale : range = [-100, 100], unit = Frequency
% 	clockbygpsupdate : enum = {Never;Once;Reset;On Startup;Slow;Fast;Realtime} disabled: {0000000}
% 	calibrationreload : boolean
% </calibration>
