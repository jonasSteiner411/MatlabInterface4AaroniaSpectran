#include "pch.h"
#include "spctrnWrp.h"
#include <Windows.h>
#include <thread>
#include <iostream>
#include <delayimp.h>
#include <strsafe.h>
#include <shlobj_core.h>
#pragma comment (lib, "aaroniartsaapi.lib")

#define SPCTRN_WRP_ERROR_DLL_LOAD AARTSAAPI_Result(0x81000001)	
#define SPCTRN_WRP_ERROR_ALREADY_INITIALIZED AARTSAAPI_Result(0x81000002)
#define SPCTRN_WRP_ERROR_MAT_DIM_OVERFLOW AARTSAAPI_Result(0x81000003)

#pragma region MatlabWrite

void writeMatArrayFlag(uint8_t flags, uint8_t arrayClass, char* buffer, const size_t& bufferSize, size_t& bufferPosition, std::fstream& out)
{
	if (!out.is_open() || !out.good())
	{
		std::cerr << "Stream is not open!" << std::endl;
		return;
	}

	if (bufferSize < 50)
	{
		std::cerr << "Infeasible buffer size!" << std::endl;
		return;
	}

	if ((bufferPosition + 16) >= bufferSize)
	{
		out.write(buffer, bufferPosition);
		bufferPosition = 0;
	}

	uint32_t flagData = 0;

	*(uint32_t*)&buffer[bufferPosition] = 6;	// Data Type = UINT32
	*(uint32_t*)&buffer[bufferPosition + 1 * sizeof(uint32_t)] = 8;	// subelement size
	*(uint32_t*)&buffer[bufferPosition + 2 * sizeof(uint32_t)] = ((uint32_t)flags << (1 * 8)) + (uint32_t)arrayClass;
	bufferPosition += 16;
}

//This function is only capable of writing matrix dimensions despite mat files allowing for more than 2D data.
void writeMatArrayDim(int32_t n, int32_t m, char* buffer, const size_t& bufferSize, size_t& bufferPosition, std::fstream& out)
{
	if (!out.is_open() || !out.good())
	{
		std::cerr << "Stream is not open!" << std::endl;
		return;
	}

	if (bufferSize < 50)
	{
		std::cerr << "Infeasible buffer size!" << std::endl;
		return;
	}

	if ((bufferPosition + 16) >= bufferSize)
	{
		out.write(buffer, bufferPosition);
		bufferPosition = 0;
	}

	*(uint32_t*)&buffer[bufferPosition] = 5; // Data type is INT32
	*(uint32_t*)&buffer[bufferPosition + 1 * sizeof(uint32_t)] = 8;	// subelement size
	*(int32_t*)&buffer[bufferPosition + 2 * sizeof(uint32_t)] = n;
	*(int32_t*)&buffer[bufferPosition + 3 * sizeof(uint32_t)] = m;
	bufferPosition += 16;
}

void writeMatName(const char* str, char* buffer, const size_t& bufferSize, size_t& bufferPosition, std::fstream& out)
{
	if (!out.is_open() || !out.good())
	{
		std::cerr << "Stream is not open!" << std::endl;
		return;
	}

	if (bufferSize < 50)
	{
		std::cerr << "Infeasible buffer size!" << std::endl;
		return;
	}

	if ((bufferPosition + 8) >= bufferSize)
	{
		out.write(buffer, bufferPosition);
		bufferPosition = 0;
	}

	size_t strLen = 0;
	while (str[strLen++] != '\0');

	*(uint32_t*)&buffer[bufferPosition] = 1; // Data type is INT8
	*(uint32_t*)&buffer[bufferPosition + 1 * sizeof(uint32_t)] = (uint32_t)strLen - 1U;	// subelement size
	bufferPosition += 8;
	size_t padding = (8 - (strLen % 8)) % 8;

	if ((bufferPosition + strLen + padding) < bufferSize)
	{
		// Name fits into buffer
		std::memcpy(&buffer[bufferPosition], str, strLen);
		std::memset(&buffer[bufferPosition + strLen], 0, padding);
		bufferPosition += strLen + padding;
	}
	else
	{
		// Name does not fit in buffer
		out.write(buffer, bufferPosition);
		out.write(str, strLen);
		out.seekp(padding, std::ios_base::cur);
		bufferPosition = 0;
	}
}

void writeMatFieldNameLength(int32_t length, char* buffer, const size_t& bufferSize, size_t& bufferPosition, std::fstream& out)
{
	if (!out.is_open() || !out.good())
	{
		std::cerr << "Stream is not open!" << std::endl;
		return;
	}

	if (bufferSize < 50UI64)
	{
		std::cerr << "Infeasible buffer size!" << std::endl;
		return;
	}

	if ((bufferPosition + 8) >= bufferSize)
	{
		out.write(buffer, bufferPosition);
		bufferPosition = 0;
	}

	*(uint32_t*)&buffer[bufferPosition] = (4U << (2 * 8)) + 5U;	// Short format size
	*(int32_t*)&buffer[bufferPosition + sizeof(uint32_t)] = length;
	bufferPosition += 2 * sizeof(uint32_t);
}

void writeMatFieldNames(const char* fieldNames[], size_t numFieldNames, size_t fieldNameSize, char* buffer, const size_t& bufferSize, size_t& bufferPosition, std::fstream& out)
{
	if (!out.is_open() || !out.good())
	{
		std::cerr << "Stream is not open!" << std::endl;
		return;
	}

	if (bufferSize < max(50UI64, fieldNameSize))
	{
		std::cerr << "Infeasible buffer size!" << std::endl;
		return;
	}

	if ((bufferPosition + 8) >= bufferSize)
	{
		out.write(buffer, bufferPosition);
		bufferPosition = 0;
	}

	*(uint32_t*)&buffer[bufferPosition] = 1;	// type = INT8
	*(uint32_t*)&buffer[bufferPosition += sizeof(uint32_t)] = (uint32_t)(numFieldNames * fieldNameSize);
	bufferPosition += sizeof(uint32_t);

	size_t strLen = 0;
	for (size_t i = 0; i < numFieldNames; i++)
	{
		if ((bufferPosition + fieldNameSize) >= bufferSize)
		{
			out.write(buffer, bufferPosition);
			bufferPosition = 0;
		}
		strLen = 0;
		while (fieldNames[i][strLen++] != '\0');
		std::memcpy(&buffer[bufferPosition], fieldNames[i], strLen);
		std::memset(&buffer[bufferPosition + strLen], 0, fieldNameSize - strLen);
		bufferPosition += fieldNameSize;
	}
}

// Returns the position of the unsigned 32 bit int telling the number of bytes follwing the tag
[[nodiscard]] size_t writeMatTag(uint32_t type, char* buffer, const size_t& bufferSize, size_t& bufferPosition, std::fstream& out)
{
	if (!out.is_open() || !out.good())
	{
		std::cerr << "Stream is not open!" << std::endl;
		return 0;
	}

	if (bufferSize < 50)
	{
		std::cerr << "Infeasible buffer size!" << std::endl;
		return 0;
	}

	if ((bufferPosition + 8) >= bufferSize)
	{
		out.write(buffer, bufferPosition);
		bufferPosition = 0;
	}

	*(uint32_t*)&buffer[bufferPosition] = type;
	bufferPosition += 8;
	return (size_t)(bufferPosition - 4) + out.tellp();
}

size_t writeMatField(uint8_t arrayClass, uint32_t type, size_t elmSize, int32_t n, int32_t m, /*optional*/ const void* dat, char* buffer, const size_t& bufferSize, size_t& bufferPosition, std::fstream& out)
{
	if (!out.is_open() || !out.good())
	{
		std::cerr << "Stream is not open!" << std::endl;
		return 0;
	}

	if (bufferSize < 50)
	{
		std::cerr << "Infeasible buffer size!" << std::endl;
		return 0;
	}

	// size of the 'header' for each data block
	if ((bufferPosition + 4 * 8) >= bufferSize)
	{
		out.write(buffer, bufferPosition);
		bufferPosition = 0;
	}

	size_t dataLocation = 0;
	uint32_t blockSize = (uint32_t)(n * m * elmSize);
	size_t padding = (8 - (blockSize % 8)) % 8;

	*(uint32_t*)&buffer[bufferPosition] = 14;	// type = MATRIX
	*(uint32_t*)&buffer[bufferPosition + sizeof(uint32_t)] = 5 * 8 + blockSize;
	bufferPosition += 2 * sizeof(uint32_t);
	writeMatArrayFlag(0, arrayClass, buffer, bufferSize, bufferPosition, out);
	writeMatArrayDim(n, m, buffer, bufferSize, bufferPosition, out);

	// empty Array Name subelement; not used because field names are already set
	*(uint32_t*)&buffer[bufferPosition] = 1;	// type = INT8
	*(uint32_t*)&buffer[bufferPosition + sizeof(uint32_t)] = 0;
	bufferPosition += 2 * sizeof(uint32_t);

	// Data
	*(uint32_t*)&buffer[bufferPosition] = type;
	*(uint32_t*)&buffer[bufferPosition += sizeof(uint32_t)] = blockSize;
	bufferPosition += sizeof(uint32_t);
	dataLocation = bufferPosition + out.tellp();	// data starts here
	if ((bufferPosition + blockSize + padding) >= bufferSize)
	{
		// empty buffer before writing
		out.write(buffer, bufferPosition);
		if (dat == nullptr)
		{
			padding += blockSize;
		}
		else
		{
			out.write((const char*)dat, blockSize);
		}
		out.seekp(padding, std::ios_base::cur);
		bufferPosition = 0;
	}
	else
	{
		// data fits inside buffer
		if (dat == nullptr)
		{
			padding += blockSize;
		}
		else
		{
			std::memcpy(&buffer[bufferPosition], dat, blockSize);
			bufferPosition += blockSize;
		}
		std::memset(&buffer[bufferPosition], 0, padding);
		bufferPosition += padding;
	}
	return dataLocation;
}

void writeMatHeader(char* buffer, const size_t& bufferSize, size_t& bufferPosition, std::fstream& out)
{
	if (!out.is_open() || !out.good())
	{
		std::cerr << "Stream is not open!" << std::endl;
		return;
	}

	if (bufferSize < 128)
	{
		std::cerr << "Infeasible buffer size! (< 128)" << std::endl;
		return;
	}

	if ((bufferPosition + 128) >= bufferSize)
	{
		out.write(buffer, bufferPosition);
		bufferPosition = 0;
	}

	uint16_t endianCheck = 0x4d49;

	size_t nameLen = sizeof("AARONIA-SPECTRANV6-Data");
	std::memcpy(&buffer[bufferPosition], "AARONIA-SPECTRANV6-Data", nameLen * sizeof(char));
	bufferPosition += nameLen;
	std::memset(&buffer[bufferPosition], 0, 124 - nameLen);
	bufferPosition += 124 - nameLen;
	*(uint16_t*)&buffer[bufferPosition] = 0x0100;
	*(uint16_t*)&buffer[bufferPosition + sizeof(uint16_t)] = endianCheck;
	bufferPosition += 2 * sizeof(uint16_t);
}

#pragma endregion MatlabWrite

/// <summary>
/// This global variable is used in this DLL to check wether the api has already been initialised.
/// This is important since NO api functions should be used whenever the api has not been initialised before.
/// Also Initialising twice, or closing api without initialising causes runtime aborts, that can be avoided this way.
/// </summary>
bool apiInitialized = false;

/// <summary>
/// This is used to keep the API handle out of this wrapper, which makes the api cleaner and more easy to use. 
/// </summary>
AARTSAAPI_Handle globalApiHandle = { nullptr };

// helper function to map any given sampling frequency to one of the clock frequencies
double sampleFrequencyLims(const double& in, AARTSAAPI_Device* device_ptr)
{
	const double lims[] = { 92e6, 122e6, 184e6, 245e6 };
	const double seps[] = { 0.5 * (lims[0] + lims[1]), 0.5 * (lims[1] + lims[2]), 0.5 * (lims[2] + lims[3]) };
	double min = 1e10;
	double val = 0;
	uint8_t minIdx = 0;

	if (in > seps[1])
	{
		minIdx = 2;
	}

	if (in > seps[minIdx])
	{
		minIdx += 1;
	}

	spctrn_setConfig_i(device_ptr, L"device/receiverclock", (int64_t)minIdx);
	return lims[minIdx];
}

#pragma region openingClosing
/// <summary>
/// If the api is not initialised already this function will first load the AaroniaRTSAAPI dll and then initialise the api.
/// This will make sure no api function will be used before the library is loaded.
/// </summary>
/// <param name="memory">0, 1, 2, 3 indicating the amount of memory.</param>
/// <returns>AARTSAAPI_OK(0) if no error occured. Error code otherwise (see AARONIA Documentation).</returns>
uint32_t spctrn_init(uint32_t memory)
{
	AARTSAAPI_Result res = 0;
	if (!apiInitialized)
	{
		HMODULE	mod = ::LoadLibraryEx(L"AaroniaRTSAAPI.dll", NULL, 0);
		if (!mod)
		{
			TCHAR pf[MAX_PATH], ld[MAX_PATH];

			// Find dll default installation location

			::SHGetSpecialFolderPath(0, pf, CSIDL_PROGRAM_FILES, FALSE);
			::StringCbPrintf(ld, sizeof(ld), L"%s\\Aaronia AG\\Aaronia RTSA-Suite PRO\\AaroniaRTSAAPI.dll", pf);

			// Load library from explicit location, using the dll folder as an addition to the search path for dependent dlls

			mod = ::LoadLibraryEx(ld, NULL, LOAD_LIBRARY_SEARCH_DEFAULT_DIRS | LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR);

			if (!mod)
			{
				return SPCTRN_WRP_ERROR_DLL_LOAD;
			}
		}
		apiInitialized = true;
		if ((res = AARTSAAPI_Init(memory)) != AARTSAAPI_OK)
		{
			return res;
		}
		
		if ((res = AARTSAAPI_Open(&globalApiHandle)) != AARTSAAPI_OK)
		{
			return res;
		}
		return AARTSAAPI_OK;
	}
	else
	{
		return SPCTRN_WRP_ERROR_ALREADY_INITIALIZED;
	}
}

/// <summary>
/// Frees memory allocated previously with the spctrn_init function.
/// </summary>
/// <returns>AARTSAAPI_OK(0) if no error occured. Error code otherwise (see AARONIA Documentation).</returns>
uint32_t spctrn_shutdown()
{
	if (apiInitialized)
	{
		apiInitialized = false;
		AARTSAAPI_Close(&globalApiHandle);
		return AARTSAAPI_Shutdown();
	}
	else
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}
}

/// <summary>
/// Open device assuming the library has already been initialised and opened.
/// </summary>
/// <param name="index">The index of the device. (usefull when using multiple devices at once)</param>
/// <param name="handle_ptr">Pointer to the api access handle.</param>
/// <param name="device_ptr">Pointer to the device handle.</param>
/// <param name="deviceName">Name of device that is to be opened. e.g. L"spectranv6/iqReceiver"</param>
/// <param name="start">Device also immediatly starts after opening.</param>
/// <returns>AARTSAAPI_OK(0) if no error occured. Error code otherwise (see AARONIA Documentation).</returns>
uint32_t spctrn_openDevice(const int32_t& index, AARTSAAPI_Device* device_ptr, const wchar_t* type, bool start)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	AARTSAAPI_Result res;
	AARTSAAPI_DeviceInfo	dinfo = { sizeof(AARTSAAPI_DeviceInfo) };
	int counter = 0;

	while ((res = AARTSAAPI_RescanDevices(&globalApiHandle, 2000)) == AARTSAAPI_RETRY)
	{
		if (++counter > 10)return (uint32_t)res;
		std::this_thread::sleep_for(std::chrono::milliseconds(50));
	}
	if (res != AARTSAAPI_OK)
	{
		return res;
	}
	if ((res = AARTSAAPI_EnumDevice(&globalApiHandle, L"spectranv6", index, &dinfo)) != AARTSAAPI_OK)
	{
		return res;
	}
	if ((res = AARTSAAPI_OpenDevice(&globalApiHandle, device_ptr, type, dinfo.serialNumber)) != AARTSAAPI_OK)
	{
		return res;
	}
	if (start)
	{
		res = spctrn_startDevice(device_ptr);
	}
	return res;
}

/// <summary>
/// This function connects and starts the device and waits for the device to get ready. (state = AARTSAAPI_RUNNING)
/// maximum wait time is 5s.
/// </summary>
/// <param name="device_ptr">Pointer to the device handle.</param>
/// <returns>AARTSAAPI_OK(0) if no error occured. Error code otherwise (see AARONIA Documentation).</returns>
uint32_t spctrn_startDevice(AARTSAAPI_Device* device_ptr)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	AARTSAAPI_Result res;
	int counter = 0;
	if ((res = AARTSAAPI_ConnectDevice(device_ptr)) != AARTSAAPI_OK)
	{
		return res;
	}
	if ((res = AARTSAAPI_StartDevice(device_ptr)) != AARTSAAPI_OK)
	{
		return res;
	}
	// Wait for device to start
	while ((res = AARTSAAPI_GetDeviceState(device_ptr)) != AARTSAAPI_RUNNING)
	{
		if (counter++ > 200) return AARTSAAPI_RETRY;
		std::this_thread::sleep_for(std::chrono::milliseconds(50));
	}
	return AARTSAAPI_OK;
}

/// <summary>
/// Stops Device. Stop data transmission/reception.
/// </summary>
/// <param name="device_ptr">Pointer to the device handle.</param>
/// <returns>AARTSAAPI_OK(0) if no error occured. Error code otherwise (see AARONIA Documentation).</returns>
uint32_t spctrn_stopDevice(AARTSAAPI_Device* device_ptr)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	return AARTSAAPI_StopDevice(device_ptr);
}

/// <summary>
/// This function stops, disconnects and closes the device. If the device was not connected when calling this
/// function it will produce some error messages.
/// </summary>
/// <param name="handle_ptr">Pointer to the API access handle.</param>
/// <param name="device_ptr">Pointer to the device handle which is going to be closed.</param>
/// <returns>AARTSAAPI_OK(0) if no error occured. Error code otherwise (see AARONIA Documentation).</returns>
uint32_t spctrn_closeDevice( AARTSAAPI_Device* device_ptr)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	AARTSAAPI_Result res;
	AARTSAAPI_Result out = AARTSAAPI_OK;
	//
	// TODO: check if stopDevice still breaks when using transimtter/transceiver.
	// TODO: find a way of determining device type 
	// 
	// Stop device was excluded because of on error when stopping the device in transmitter mode
	//if ((res = AARTSAAPI_StopDevice(device_ptr)) != AARTSAAPI_OK)out = res;
	if ((res = AARTSAAPI_DisconnectDevice(device_ptr)) != AARTSAAPI_OK)out = res;
	if ((res = AARTSAAPI_CloseDevice(&globalApiHandle, device_ptr)) != AARTSAAPI_OK)out = res;
	
	return out;
}
#pragma endregion openingClosing

#pragma region config
/// <summary>
/// Set value in the configuration tree of the device, assuming the device handle pointer points to a valid device.
/// </summary>
/// <param name="device_ptr">Pointer to the device handle.</param>
/// <param name="name">Name of the configuration tree element. e.g. "main/centerfreq" (see configExplained.txt).</param>
/// <param name="value">Value that is to be assigned to the configuration element.</param>
/// <returns>AARTSAAPI_OK(0) if no error occured. Error code otherwise (see AARONIA Documentation).</returns>
uint32_t spctrn_setConfig_d(AARTSAAPI_Device* device_ptr, const wchar_t* name, double value)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	AARTSAAPI_Result res;
	AARTSAAPI_Config root, elm;
	AARTSAAPI_ConfigInfo ci = { sizeof(AARTSAAPI_ConfigInfo) };

	if ((res = AARTSAAPI_ConfigRoot(device_ptr, &root)) != AARTSAAPI_OK)
	{
		return res;
	}
	if ((res = AARTSAAPI_ConfigFind(device_ptr, &root, &elm, name)) != AARTSAAPI_OK)
	{
		return res;
	}
	if ((res = AARTSAAPI_ConfigSetFloat(device_ptr, &elm, value)) != AARTSAAPI_OK)
	{
		return res;
	}
	
	if ((res = AARTSAAPI_ConfigGetInfo(device_ptr, &elm, &ci)) != AARTSAAPI_OK)
	{
		return AARTSAAPI_ERROR;
	}
	if (ci.type != AARTSAAPI_CONFIG_TYPE_NUMBER)
	{
		return AARTSAAPI_WARNING;
	}
	else
	{
		return AARTSAAPI_OK;
	}
}

/// <summary>
/// Get double type Value of configuration element by name.
/// </summary>
/// <param name="device_ptr">Pointer to the device handle of which the configurated value is to be read.</param>
/// <param name="name">Name of the configuration element e.g. L"main/centerfreq" (see configExplained.txt).</param>
/// <returns>Value of Config element. NaN if an error occured.</returns>
double spctrn_getConfig_d(AARTSAAPI_Device* device_ptr, const wchar_t* name)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	AARTSAAPI_Config root, elm;
	double out = 0;
	if (AARTSAAPI_ConfigRoot(device_ptr, &root) != AARTSAAPI_OK)return std::nan("1");
	if (AARTSAAPI_ConfigFind(device_ptr, &root, &elm, name) != AARTSAAPI_OK)return std::nan("1");
	if (AARTSAAPI_ConfigGetFloat(device_ptr, &elm, &out) != AARTSAAPI_OK)return std::nan("1");
	return out;
}

/// <summary>
/// Set value in the configuration tree of the device, assuming the device handle pointer points to a valid device.
/// </summary>
/// <param name="device_ptr">Pointer to the device handle.</param>
/// <param name="name">Name of the configuration tree element. e.g. "main/centerfreq" (see configExplained.txt).</param>
/// <param name="value">Value that is to be assigned to the configuration element.</param>
/// <returns>AARTSAAPI_OK(0) if no error occured. Error code otherwise (see AARONIA Documentation).</returns>
uint32_t spctrn_setConfig_i(AARTSAAPI_Device* device_ptr, const wchar_t* name, int64_t value)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	AARTSAAPI_Result res;
	AARTSAAPI_Config root, elm;
	AARTSAAPI_ConfigInfo ci = { sizeof(AARTSAAPI_ConfigInfo) };

	if ((res = AARTSAAPI_ConfigRoot(device_ptr, &root)) != AARTSAAPI_OK)
	{
		return res;
	}
	if ((res = AARTSAAPI_ConfigFind(device_ptr, &root, &elm, name)) != AARTSAAPI_OK)
	{
		return res;
	}
	if ((res = AARTSAAPI_ConfigSetInteger(device_ptr, &elm, value)) != AARTSAAPI_OK)
	{
		return res;
	}
	
	if ((res = AARTSAAPI_ConfigGetInfo(device_ptr, &elm, &ci)) != AARTSAAPI_OK)
	{
		return AARTSAAPI_ERROR;
	}
	if (ci.type != AARTSAAPI_CONFIG_TYPE_ENUM)
	{
		return AARTSAAPI_WARNING;
	}
	else
	{
		return AARTSAAPI_OK;
	}
}

/// <summary>
/// Get double type Value of configuration element by name.
/// </summary>
/// <param name="device_ptr">Pointer to the device handle of which the configurated value is to be read.</param>
/// <param name="name">Name of the configuration element e.g. L"main/centerfreq" (see configExplained.txt).</param>
/// <returns>Enumeration index of element. -1 if an error occured (negative integers cannot be enumeration indices and are therefore available to use as error codes).</returns>
int64_t spctrn_getConfig_i(AARTSAAPI_Device* device_ptr, const wchar_t* name)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	AARTSAAPI_Config root, elm;
	int64_t out = -1;
	if (AARTSAAPI_ConfigRoot(device_ptr, &root) != AARTSAAPI_OK)return -1;
	if (AARTSAAPI_ConfigFind(device_ptr, &root, &elm, name) != AARTSAAPI_OK)return -1;
	if (AARTSAAPI_ConfigGetInteger(device_ptr, &elm, &out) != AARTSAAPI_OK)return -1;
	return out;
}

/// <summary>
/// Set value in the configuration tree of the device, assuming the device handle pointer points to a valid device.
/// </summary>
/// <param name="device_ptr">Pointer to the device handle.</param>
/// <param name="name">Name of the configuration element. e.g. L"main/centerfreq" (see confiExplained.txt)</param>
/// <param name="value">Value that is to be assigned to the configuration element (null Terminated string).</param>
/// <returns>AARTSAAPI_OK(0) if no error occured. Error code otherwise (see AARONIA Documentation).</returns>
uint32_t spctrn_setConfig_s(AARTSAAPI_Device* device_ptr, const wchar_t* name, const wchar_t* value)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	AARTSAAPI_Config root, elm;
	AARTSAAPI_Result res;
	AARTSAAPI_ConfigInfo ci = { sizeof(AARTSAAPI_ConfigInfo) };

	if ((res = AARTSAAPI_ConfigRoot(device_ptr, &root)) != AARTSAAPI_OK)
	{
		return res;
	}
	if ((res = AARTSAAPI_ConfigFind(device_ptr, &root, &elm, name)) != AARTSAAPI_OK)
	{
		return res;
	}
	if ((res = AARTSAAPI_ConfigSetString(device_ptr, &elm, value)) != AARTSAAPI_OK)
	{
		return res;
	}
	
	if ((res = AARTSAAPI_ConfigGetInfo(device_ptr, &elm, &ci)) != AARTSAAPI_OK)
	{
		return AARTSAAPI_ERROR;
	}
	if (ci.type != AARTSAAPI_CONFIG_TYPE_ENUM && ci.type != AARTSAAPI_CONFIG_TYPE_STRING)
	{
		return AARTSAAPI_WARNING;
	}
	else
	{
		return AARTSAAPI_OK;
	}
}

/// <summary>
/// Get const wchar_t* type value of configuration element. 
/// </summary>
/// <param name="device_ptr">Pointer to the device handle of which the configurated value is to be read.</param>
/// <param name="name">Name of the configuration element e.g. L"main/centerfreq".</param>
/// <param name="value">Wide char buffer to store the result.</param>
/// <param name="size_value">Amount of Previously allocated bytes for string value.</param>
/// <returns>A Pointer to the first element of the read wide-character array. If an error occures a string of L'#' characters is returned.</returns>
const wchar_t* spctrn_getConfig_s(AARTSAAPI_Device* device_ptr, const wchar_t* name, wchar_t* value, int64_t size_value)
{
	if (!apiInitialized)
	{
		return L"ERROR: not initialised!";
	}

	AARTSAAPI_Config root, elm;

	if (AARTSAAPI_ConfigRoot(device_ptr, &root) != AARTSAAPI_OK)
	{
		std::wmemset(value, L'#', size_value);
		return value;
	}
	if (AARTSAAPI_ConfigFind(device_ptr, &root, &elm, name) != AARTSAAPI_OK)
	{
		std::wmemset(value, L'#', size_value);
		return value;
	}
	if (AARTSAAPI_ConfigGetString(device_ptr, &elm, value, &size_value) != AARTSAAPI_OK)
	{
		std::wmemset(value, L'#', size_value);
		return value;
	}
	return value;
}
#pragma endregion config

#pragma region packet
/// <summary>
/// Retrieve a packet from the usb packet queue if one is available.
/// During a timeout intervall of 0.1s wait one millisecond and try again.
/// </summary>
/// <param name="device_ptr">Pointer to device handle.</param>
/// <param name="index">Index of the device.</param>
/// <param name="channel">Channel of the data € [ iq-Rx1(0), iq-Rx2(1), spectra-Rx1(2), spectra-Rx2(3)]</param>
/// <param name="packet_ptr">Pointer to Packet which is going to be used to store the data.</param>
/// <param name="consume">Consumes Packet after reading if set.</param>
/// <returns>AARTSAAPI_OK(0) if no error occured. Error code otherwise (see AARONIA Documentation).</returns>
uint32_t spctrn_getPacket(AARTSAAPI_Device* device_ptr, const int32_t& index, const int32_t& channel, AARTSAAPI_Packet* packet_ptr, bool consume)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	int loopCounter = 0;
	AARTSAAPI_Result res = 0;
	while ((res = AARTSAAPI_GetPacket(device_ptr, channel, index, packet_ptr)) == AARTSAAPI_EMPTY)
	{
		// No available packets for 0.1 seconds -> break
		if (loopCounter++ > 100)return res;
		std::this_thread::sleep_for(std::chrono::milliseconds(1));
	}
	
	if (consume && (res == AARTSAAPI_OK))
	{
		// Consume the packet which was gathered by the GetPacket function.
		// The data has been copied to packet_ptr and can be released from the usb queue.
		res = AARTSAAPI_ConsumePackets(device_ptr, channel, 1);
	}

	if (packet_ptr == nullptr)
	{
		return AARTSAAPI_EMPTY;
	}

	return res;
}

/// <summary>
/// Consume a number of packets from a devices data channel.  If the data in a data channel is not
/// consumed it will block when the queue is full and new data will be dropped.
/// </summary>
/// <param name="device_ptr">Pointer to the device.</param>
/// <param name="channel">Channel of the data € [ iq-Rx1(0), iq-Rx2(1), spectra-Rx1(2), spectra-Rx2(3)]</param>
/// <param name="num">Number of Packets to be consumed</param>
/// <returns>AARTSAAPI_OK(0) if no error occured. Error code otherwise (see AARONIA Documentation).</returns>
uint32_t spctrn_consumePackets(AARTSAAPI_Device* device_ptr, const int32_t& channel, const int32_t& num)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	return AARTSAAPI_ConsumePackets(device_ptr, channel, num);
}

/// <summary>
/// Get the number of available packets.
/// </summary>
/// <param name="device_ptr">Pointer to device handle.</param>
/// <param name="channel">Channel of the data € [ iq-Rx1(0), iq-Rx2(1), spectra-Rx1(2), spectra-Rx2(3)]</param>
/// <returns>number of available packets on given usb channel. -1 if an error has occured.</returns>
int32_t spctrn_availPackets(AARTSAAPI_Device* device_ptr, const int32_t& channel)
{
	if (!apiInitialized)
	{
		return -1;
	}

	int32_t result = 0;
	if (AARTSAAPI_AvailPackets(device_ptr, channel, &result) != AARTSAAPI_OK)
	{
		// return value of -1 indicating a failed attempt 
		return -1;
	}
	return result;
}

/// <summary>
/// This function is used to send IQ Packets to the transmitter of the spectran v6.
/// </summary>
/// <param name="device_ptr">Pointer to the device which is going to be used as transmitter </param>
/// <param name="channel">Data Channel used.</param>
/// <param name="packet_ptr">Adress of the already filled packet!</param>
/// <returns>AARTSAAPI_OK(0) if no error occured. Error code otherwise (see AARONIA Documentation).</returns>
uint32_t spctrn_sendPacket(AARTSAAPI_Device* device_ptr, const int32_t& channel, AARTSAAPI_Packet* packet_ptr)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	return AARTSAAPI_SendPacket(device_ptr, channel, packet_ptr);
}

// returns (int32_t)(std::ceil((double)a / b)) - 1)
int64_t ceilDiv(int64_t a, int64_t b)
{
	int64_t temp = a / b;
	if (a % b != 0)
	{
		return temp;
	}
	else
	{
		return temp - 1;
	}
}

/// <summary>
/// Send IQ data to spectranV6 transmitter.
/// </summary>
/// <param name="device_ptr"> Pointer to device handle. </param>
/// <param name="channel"> Data exchange channel of the device. See Documentation or matlab api definition. </param>
/// <param name="centerF"> Center frequency to be used. </param>
/// <param name="rate"> Data rate as in samples per second. </param>
/// <param name="span"> Span frequency of the device. </param>
/// <param name="start"> Time offset (in seconds) of when the data is to be played.</param>
/// <param name="num"> Number of samples. </param>
/// <param name="data"> Data array of size 2 * num. </param>
/// <param name="loop"> number of times the given data block is supposed to loop.</param>
/// <param name="absTime"> Switches from using a time offset to specifiyng the absolute start time. see param 'start' </param>
/// <returns>Abosulute end time of the supplied data set. NaN as return value suggest that an error has occured.</returns>
double spctrn_sendData(AARTSAAPI_Device* device_ptr, const int32_t& channel, const double& centerF, const double& rate, 
	const double& span, const double& start, const int64_t& num, float* data, const int32_t& loop, const bool& absTime)
{
	if (!apiInitialized)
	{
		//Error code 1 for api not initialised error
		return std::nan("1");
	}
	AARTSAAPI_Result res = AARTSAAPI_OK;
	if(AARTSAAPI_GetDeviceState(device_ptr) != AARTSAAPI_RUNNING)
	{
		return std::nan("2");
	}

	const double maxQueueFill = 3;
	const int64_t maxPacketSize = 16384;
	int64_t numOfSamplesSent = 0;
	double currentTime = 0.0;
	double packetTime;

	// Setup AARTSAAPI_Packet according to the specified values
	AARTSAAPI_Packet P = AARTSAAPI_Packet{ sizeof(AARTSAAPI_Packet) };
	P.stepFrequency = rate;
	P.startFrequency = centerF - 0.5 * span;
	P.size = 2;
	P.stride = 2;

	// Start time of initial packet is offset by respective parameter
	if (absTime)
	{
		P.startTime = start;
	}
	else
	{
		if (AARTSAAPI_GetMasterStreamTime(device_ptr, currentTime) != AARTSAAPI_OK) return std::nan("3");
		P.startTime = start + currentTime;
	}

	if (num > maxPacketSize)
	{
		//Set Flag indicating start of stream
		P.flags = AARTSAAPI_PACKET_STREAM_START;

		//The number of samples can be preset, since it wont change during the loop
		P.num = maxPacketSize;
		packetTime = P.num / P.stepFrequency;

		for (int32_t L = 0; L < loop; L++)
		{
			//Each outer loop iteration counts as one segment (?)
			P.flags |= AARTSAAPI_PACKET_SEGMENT_START;

			//loop over all but one segments of the complete data set
			for (int32_t segIdx = 0; segIdx < ceilDiv(num, maxPacketSize); segIdx++)
			{
				if (AARTSAAPI_GetMasterStreamTime(device_ptr, currentTime) != AARTSAAPI_OK)
				{
					return std::nan("3");
				}

				//wait if the packet queue contains maxQueueSize or more packets
				if (P.startTime > (currentTime + maxQueueFill * packetTime))
				{
					//wait for time difference minus one packetTime
					std::this_thread::sleep_for(std::chrono::milliseconds((int)(1000 * (P.startTime - currentTime - (maxQueueFill - 1) * packetTime))));
				}

				// all packets are sent with the maximum amount of data
				P.fp32 = &data[segIdx * maxPacketSize * 2];

				P.endTime = P.startTime + packetTime;
				if (AARTSAAPI_SendPacket(device_ptr, channel, &P) != AARTSAAPI_OK)return std::nan("4");
				P.startTime = P.endTime;

				// reset flags after packet was sent
				P.flags = 0;
			}

			//Send remaining samples
			P.num = num % maxPacketSize;
			packetTime = P.num / P.stepFrequency;

			//set stream end flag on final packet of stream
			if (L == (loop - 1)) P.flags |= AARTSAAPI_PACKET_STREAM_END;
			P.flags |= AARTSAAPI_PACKET_SEGMENT_END;

			P.fp32 = &data[num - P.num];

			P.endTime = P.startTime + packetTime;
			if (AARTSAAPI_SendPacket(device_ptr, channel, &P) != AARTSAAPI_OK)return std::nan("4");
			if (AARTSAAPI_GetMasterStreamTime(device_ptr, currentTime) != AARTSAAPI_OK)return std::nan("3");
			std::this_thread::sleep_for(std::chrono::milliseconds((int)(1000 * (packetTime + P.startTime - currentTime))));
		}
	}
	else
	{
		int64_t f = min(loop, maxPacketSize / num);
		float* buffer = new float[f * 2 * num];
		for (int32_t fIdx = 0; fIdx < f; fIdx++)
		{
			//fill previously allocated buffer
			std::memcpy(&buffer[(int64_t)fIdx * 2 * num], data, num * 2 * sizeof(float));
		}

		//All packets sent in the loop use the same buffer
		P.fp32 = buffer;
		P.num = f * num;
		packetTime = P.num / P.stepFrequency;

		P.flags = AARTSAAPI_PACKET_STREAM_START | AARTSAAPI_PACKET_SEGMENT_START;

		int32_t b = (int32_t)ceilDiv(loop, f);
		for(int32_t L = 0; L < b; L++)
		{
			if (AARTSAAPI_GetMasterStreamTime(device_ptr, currentTime) != AARTSAAPI_OK)
			{
				return std::nan("3");
			}

			//wait if the packet queue contains maxQueueSize or more packets
			if (P.startTime > (currentTime + maxQueueFill * packetTime))
			{
				//wait for time difference minus one packetTime
				std::this_thread::sleep_for(std::chrono::milliseconds((int)(1000 * (P.startTime - currentTime - (maxQueueFill - 1) * packetTime))));
			}

			P.endTime = P.startTime + packetTime;
			if (AARTSAAPI_SendPacket(device_ptr, channel, &P) != AARTSAAPI_OK)return std::nan("4");
			P.startTime = P.endTime;

			// reset flags after packet was sent
			P.flags = 0;
		}

		P.num = num * ((int64_t)loop - (int64_t)b * f);
		packetTime = P.num / P.stepFrequency;
		P.flags = AARTSAAPI_PACKET_SEGMENT_END | AARTSAAPI_PACKET_STREAM_END;

		P.endTime = P.startTime + packetTime;
		if (AARTSAAPI_SendPacket(device_ptr, channel, &P) != AARTSAAPI_OK)return std::nan("4");

		//wait until final packet has finished before freeing buffer
		if (AARTSAAPI_GetMasterStreamTime(device_ptr, currentTime) != AARTSAAPI_OK)return std::nan("3");
		std::this_thread::sleep_for(std::chrono::milliseconds((int)(1000 * (packetTime + P.startTime - currentTime))));
		delete[] buffer;
	}

	return P.endTime;
}

// Internal helper function that is not exported as part as this wrapper api
uint32_t streamDataToFile(const double& centerFrequency,const double& spanFrequency,const double& samplingRate,const int32_t& numberOfSamples,
	const int32_t& sampleSize, std::fstream* f, AARTSAAPI_Device* device_ptr, const int32_t& deviceIndex, 
	const int32_t& channel, /*nullTerminated*/ const char* structName, const double& start){

	std::this_thread::sleep_for(std::chrono::milliseconds((size_t)(1000 * start)));

	AARTSAAPI_Result res;
	AARTSAAPI_Packet P = { sizeof(AARTSAAPI_Packet) };
	int32_t sampleCollected = 0;

	size_t maxBufferSize = 1000;
	char* matBuffer = new char[maxBufferSize];
	std::memset(matBuffer, 0, maxBufferSize);

	const char* fieldNames[] = { "dCenterfrequency", "dSpanfrequency", "dSamplefrequency", "mdData" };

	size_t bufferPos = 0;
	size_t dataPos = 0;
	uint32_t fileSize = 0;
	size_t fileSizePos = 0;

	writeMatHeader(matBuffer, maxBufferSize, bufferPos, *f);
	fileSizePos = writeMatTag(14, matBuffer, maxBufferSize, bufferPos, *f);
	writeMatArrayFlag(0, 2, matBuffer, maxBufferSize, bufferPos, *f);
	writeMatArrayDim(1, 1, matBuffer, maxBufferSize, bufferPos, *f);
	writeMatName(structName, matBuffer, maxBufferSize, bufferPos, *f);
	writeMatFieldNameLength(32, matBuffer, maxBufferSize, bufferPos, *f);
	writeMatFieldNames(fieldNames, 4, 32, matBuffer, maxBufferSize, bufferPos, *f);
	writeMatField(6, 9, sizeof(double), 1, 1, &centerFrequency, matBuffer, maxBufferSize, bufferPos, *f);
	writeMatField(6, 9, sizeof(double), 1, 1, &spanFrequency, matBuffer, maxBufferSize, bufferPos, *f);
	writeMatField(6, 9, sizeof(double), 1, 1, &samplingRate, matBuffer, maxBufferSize, bufferPos, *f);
	dataPos = writeMatField(7, 7, sizeof(float), sampleSize, numberOfSamples, nullptr, matBuffer, maxBufferSize, bufferPos, *f);
	f->write(matBuffer, bufferPos);
	fileSize = (uint32_t)f->tellp() - (uint32_t)fileSizePos - 4UL;
	f->seekg(fileSizePos, std::ios_base::beg);
	f->write((const char*)&fileSize, sizeof(uint32_t));
	f->seekp(dataPos, std::ios_base::beg);
	delete[] matBuffer;

	// Consume all available (old) packets, such that only new ones will be streamed to the file.
	res = spctrn_consumePackets(device_ptr, channel, spctrn_availPackets(device_ptr, channel));
	if (res != AARTSAAPI_OK)
	{
		// error consuming packets
		f->close();
		return res;
	}

	while (sampleCollected < numberOfSamples)
	{
		// Get & Consume Packet
		res = spctrn_getPacket(device_ptr, deviceIndex, channel, &P, true);
		if (res != AARTSAAPI_OK)
		{
			// Error retrieving packet
			f->close();
			return res;
		}
		f->write((const char*)P.fp32, 2 * min(P.num, (int64_t)numberOfSamples - (int64_t)sampleCollected) * sizeof(float));
		sampleCollected += (int32_t)P.num;
	}
	return AARTSAAPI_OK;
}

/// <summary>
/// This function is used to grab a set amount of sampled IQ-Datapoints from the spectran V6 device and store it as a JSON file.
/// More clearely it first drops all already available packets (which might be some seconds old depending on the way the device is used) and only save
/// newly arrived data.
/// </summary>
/// <param name="device_ptr">Pointer to SpectranV6 device used.</param>
/// <param name="DeviceIndex">Index of SpectranV6 device used.</param>
/// <param name="channel">Channel number (RX1 / RX2 &amp; IQ / Spectra). Here a number corresponding to an IQ-Channel should be supplied.</param>
/// <param name="numberOfSamples"></param>
/// <param name="samplingRate"></param>
/// <param name="filename">Name of data file to be created. supports ".json" and ".mat" extension.</param>
/// <returns>Api Results if any occure during operation. otherwise OK</returns>
uint32_t spctrn_getIqData(AARTSAAPI_Device* device_ptr, const int32_t& DeviceIndex, const int32_t& channel, const int64_t& numberOfSamples,
	double samplingRate, const char* filename, const double& start)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}
	
	int64_t sampleCollected = 0;

	samplingRate = sampleFrequencyLims(samplingRate, device_ptr);

	// File stream object used to fill data File
	std::fstream f;

	// To reduce the load because of OS write calls a temporary buffer will be used.
	std::stringstream buffer;
	const int64_t maxBufferSize = 1000;

	// required elements for data fetching
	AARTSAAPI_Packet P = { sizeof(AARTSAAPI_Packet) };
	AARTSAAPI_Result res = 0;

	double centerFrequency = spctrn_getConfig_d(device_ptr, L"main/centerfreq");
	double spanFrequency = spctrn_getConfig_d(device_ptr, L"main/spanfreq");

	// Get File extension
	uint8_t ext = 0;
	if (filename != nullptr)
	{
		int i = 0;
		while (filename[i] != '\0')
		{
			if (filename[i++] == '.')
			{
				// not putting a break unconditionally after a dot seems unreasonable, but sometimes dots are placed in json filenames
				if (strcmp(&filename[i], "json") == 0)
				{
					ext = 0;
					break;
				}
				else if (strcmp(&filename[i], "mat") == 0)
				{
					ext = 1;
					break;
				}
			}
		}
	}

	if (filename == nullptr || ext == 0) // .json
	{
		// Open file with default name
		if (filename == nullptr)
		{
			f.open("iqData.json", std::fstream::out);
		}
		else
		{
			f.open(filename, std::fstream::out);
		}

		if (!f.is_open())
		{
			return AARTSAAPI_ERROR;
		}

		// write the receiver setup to the buffer
		buffer << "{\"centerFrequency\":" << centerFrequency << ",\"spanFrequency\":" << spanFrequency <<
			",\"samplingRate\":" << samplingRate << ",\"numberOfSamples\":" << numberOfSamples << ",\"iqData\":[";

		// Consume all available (old) packets, such that only new ones will be streamed to the file.
		res = spctrn_consumePackets(device_ptr, channel, spctrn_availPackets(device_ptr, channel));
		if (res != AARTSAAPI_OK)
		{
			// error consuming packets
			f.close();
			return res;
		}

		while (sampleCollected < numberOfSamples)
		{
			// Get & Consume Packet
			res = spctrn_getPacket(device_ptr, DeviceIndex, channel, &P, true);
			if (res != AARTSAAPI_OK)
			{
				// Error retrieving packet
				f.close();
				return res;
			}

			// This loop may still be slow and require change later!
			// either write the complete packet of data, or what is left to be collected
			for (int64_t i = 0; i < min((numberOfSamples - sampleCollected), P.num); i++)
			{
				buffer << P.fp32[2 * i] << ',' << P.fp32[2 * i + 1] << ',';
				// write to file if buffer has reached limit
				if ((int64_t)(buffer.tellp()) > maxBufferSize)
				{
					f << buffer.rdbuf();
					buffer.str(std::string());
					buffer.clear();
				}
			}
			sampleCollected += P.num; //notice, that the case where less than P.num samples where written the loop should still terminate, which is why this can be done in any case.
		}

		// flush buffer
		if (buffer.tellp() > 0)
		{
			f << buffer.rdbuf();
		}

		// place the 'put' stream position one behind the end of the stream to get rid of the trailing comma
		f.seekp(-1, std::ios_base::end);
		f << "]}\n";
		f.close();
	}
	else // .mat
	{
		// Open file in binary mode
		f.open(filename, std::fstream::out | std::ios_base::binary);
		if (!f.is_open())
		{
			return AARTSAAPI_ERROR;
		}

		if (numberOfSamples > (int64_t)INT32_MAX)
		{
			// The array dimensions need to be a 32bit signed integer
			return SPCTRN_WRP_ERROR_MAT_DIM_OVERFLOW;
		}

		// prepare mat file
		if ((res = streamDataToFile(centerFrequency, spanFrequency, samplingRate, (int32_t)numberOfSamples, 2, &f, device_ptr, DeviceIndex, channel, "IqData", start)) != AARTSAAPI_OK)
		{
			// error streaming data
			return res;
		}
		f.close();
	}

	return AARTSAAPI_OK;
}


/// <summary>
/// This function is used to grab a set amount of spectra measurments at a fixed sampling rate.
/// </summary>
/// <param name="device_ptr">Pointer to AARTSAAPI_Device object.</param>
/// <param name="DeviceIndex">Index of SpectranV6 device.</param>
/// <param name="channel">Channel number (RX1 / RX2 & IQ / Spectra). Here a number corresponding to a spectra should be supplied.</param>
/// <param name="numberOfSamples"></param>
/// <param name="samplingRate"></param>
/// <param name="filename">This funciton only supports ".mat" file extensions</param>
/// <returns>Api Results if any occure during operation. otherwise OK (0)</returns>
uint32_t spctrn_getSpectraData(AARTSAAPI_Device* device_ptr, const int32_t& DeviceIndex, const int32_t& channel, size_t numberOfSamples,
	double samplingRate, const char* filename, const double& start)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	AARTSAAPI_Result res = 0;
	std::fstream f(filename, std::fstream::out | std::ios_base::binary);
	if (!f.is_open())
	{
		return AARTSAAPI_ERROR;
	}

	double centerfrequency = spctrn_getConfig_d(device_ptr, L"main/centerfreq");

	//
	// TODO: calculate spanfrequency & sampleSize
	//
	const int32_t sampleSizes[] = { 1700, 852, 428, 212, 108, 56, 28, 16, 8, 4 };

	double spanfrequency = std::nan("1");
	int64_t decIdx = spctrn_getConfig_i(device_ptr, L"main/decimation");
	samplingRate = sampleFrequencyLims(samplingRate, device_ptr);
	if (std::isnan(centerfrequency) || decIdx == -1)
	{
		return AARTSAAPI_ERROR_INVALID_CONFIG;
	}

	res = streamDataToFile(centerfrequency, spanfrequency, samplingRate, (int32_t)numberOfSamples, sampleSizes[decIdx], &f, device_ptr, DeviceIndex, channel, "spectraData", start);
	f.close();
	return res;
}


/// <summary>
/// This function lets one supply data for the spectran to transmitt and saves the received data to a .mat file.
/// </summary>
/// <param name="device_ptr">Pointer to device handle.</param>
/// <param name="index">Index of Spectran Device. (0 if one is in use)</param>
/// <param name="channelTrans">Channel used for transmitter. (0)</param>
/// <param name="channelRec">Channel used for receiver. (depends on wether Rx1 or Rx2 is used)</param>
/// <param name="centerFTrans">Center frequency of transmitter.</param>
/// <param name="centerFRec">Center frequency of receiver.</param>
/// <param name="samplingRateTrans">Sampling rate of data which is to be transmitted.</param>
/// <param name="samplingRateRec">Sampling rate of receiver. (will be clipped to receiverclock values. see configExplained.txt)</param>
/// <param name="spanTrans">Span frequency of transmitter.</param>
/// <param name="spanRec">Span frequency of receiver.</param>
/// <param name="numTrans">Number of samples in the transmit data.</param>
/// <param name="numRec">Number of samples that are to be collected.</param>
/// <param name="data">2 * numTrans IQ Values (numTrans samples) that will be sent to the transmitter.</param>
/// <param name="startTrans">Time offset in seconds, when the transmition is supposed to begin.</param>
/// <param name="startRec">Time offset in seconds, when the data reception/collection is supposed to begin.</param>
/// <param name="loop">Number of times the supplied data should be looped.</param>
/// <param name="filename">null terminated string of filename (and path) of where the data is to be stored (do not forget the .mat file extension)</param>
/// <returns>Api Results if any errors occure during operation. otherwise OK (0)</returns>
uint32_t spctrn_transceiveData(AARTSAAPI_Device* device_ptr, const int32_t& index, const int32_t& channelTrans, const int32_t& channelRec,
	const double& centerFTrans, const double& centerFRec, const double& samplingRateTrans, const double& samplingRateRec, const double& spanTrans,
	const double& spanRec, const int64_t& numTrans, const int32_t& numRec, float* data, const double& startTrans, const double& startRec,
	const int32_t& loop, const char* filename) 
{

	// Check if api is initialised and device is running before starting
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	AARTSAAPI_Result res = AARTSAAPI_OK;
	if ((res = AARTSAAPI_GetDeviceState(device_ptr)) != AARTSAAPI_RUNNING)
	{
		return res;
	}
	int32_t sampleSize = 2;
	std::fstream f(filename, std::fstream::out | std::ios_base::binary);

	std::thread transmitter(spctrn_sendData, device_ptr, channelTrans, centerFTrans, samplingRateTrans, spanTrans, startTrans, numTrans, data, loop, false);
	std::thread receiver(streamDataToFile, centerFRec, spanRec, samplingRateRec, (int32_t)numRec, sampleSize, &f, device_ptr, index, channelRec, "IqData", startRec);
	transmitter.join();
	receiver.join();

	return AARTSAAPI_OK;
}
#pragma endregion packet

/// <summary>
/// Get the state of the device including:
///		- idle (0x10000000)
///		- connecting (0x10000001)
///		- running (0x10000004)
///		etc.
/// </summary>
/// <param name="device_ptr">Pointer to the device handle.</param>
/// <returns>code for device state. See AARTSAAPI documentation.</returns>
uint32_t spctrn_deviceState(AARTSAAPI_Device* device_ptr)
{
	if (!apiInitialized)
	{
		return AARTSAAPI_ERROR_NOT_INITIALIZED;
	}

	if (device_ptr != nullptr)
	{
		return AARTSAAPI_GetDeviceState(device_ptr);
	}
	else
	{
		return AARTSAAPI_EMPTY;
	}
}

/// <summary>
/// Returns the "d" parameter of type void* of the specified AARTSAAPI_Handle element as 64 bit unsigned integer.
/// This function is used beacuse MATLAB can not work with void type paramteters.
/// </summary>
/// <param name="handle_ptr">Pointer to api handle.</param>
/// <returns>Virtual adress of the API handle as 64 bit unsigned.</returns>
uint64_t spctrn_getApiHandle()
{
	//cast from void* to uint64_t
	return (uint64_t)(globalApiHandle.d);
}

/// <summary>
/// Returns the "d" parameter of type void* of the specified AARTSAAPI_Device element as 64 bit unsigned integer.
/// This function is used beacuse MATLAB can not work with void type paramteters.
/// </summary>
/// <param name="handle_ptr">Pointer to device handle.</param>
/// <returns>Virtual adress of the Device handle as 64 bit unsigned.</returns>
uint64_t spctrn_getDeviceHandle(AARTSAAPI_Device* device_ptr)
{
	//cast from void* to uint64_t
	return (uint64_t)(device_ptr->d);
}

/// <summary>
/// Copy options of specified config parameter to specified buffer.
/// </summary>
/// <param name="device_ptr"></param>
/// <param name="name"></param>
/// <param name="value"></param>
/// <param name="size_value"></param>
/// <returns>Buffer.</returns>
const wchar_t* spctrn_getConfigOptions(AARTSAAPI_Device* device_ptr, const wchar_t* name, wchar_t* value, int64_t size_value)
{
	if (!apiInitialized)
	{
		return L"ERROR: not initialised!";
	}

	AARTSAAPI_Config root, elm;
	AARTSAAPI_ConfigInfo ci = { sizeof(AARTSAAPI_ConfigInfo) };
	int64_t writeSize = min(size_value, 1000);

	if (AARTSAAPI_ConfigRoot(device_ptr, &root) != AARTSAAPI_OK)
	{
		std::wmemset(value, L'#', size_value);
		value[0] = L'0';
	}
	else if (AARTSAAPI_ConfigFind(device_ptr, &root, &elm, name) != AARTSAAPI_OK)
	{
		std::wmemset(value, L'#', size_value);
		value[0] = L'1';
	}
	else if (AARTSAAPI_ConfigGetInfo(device_ptr, &elm, &ci) != AARTSAAPI_OK)
	{
		std::wmemset(value, L'#', size_value);
		value[0] = L'2';
	}
	else
	{
		// copy options to buffer
		std::memcpy(value, ci.options, writeSize);
	}
	return value;
}