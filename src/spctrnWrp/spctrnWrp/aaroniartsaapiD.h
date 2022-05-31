// DUMMY Version of the AARTSAAPI in order to test other functionallity without access to actual device

#ifdef _DEBUG
#ifndef AARTSAAPI_LIB
#define AARTSAAPI_LIB
#include <cstdint>
#include <vector>
#include <iostream>
#include <cstring>
#include <cstdlib>
#include <thread>

#pragma region helperFunctions

bool wstringCpy(const wchar_t* src, wchar_t* dst, const size_t& len)
{
	if (dst == nullptr || src == nullptr)return false;
	size_t i;
	for (i = 0; ; i++)if (src[i] == L'\0' || i == len - 1)break;
	std::memcpy(dst, src, i * sizeof(wchar_t));
	dst[i] = L'\0';
	return(src[i] == L'\0');
}

bool wstringComp(const wchar_t* a, const wchar_t* b)
{
	size_t pos = 0;
	while (a[pos] == b[pos])
	{
		if (a[pos++] == L'0')return true;
	}
	return false;
}

bool wideToChar(const wchar_t* src, char* dst, size_t len)
{
	if (dst == nullptr || src == nullptr)return false;
	size_t i;
	for (i = 0; ; i++)
	{
		if (src[i] == L'\0' || i == len - 1)break;
		else dst[i] = (char)src[i];
	}
	dst[i] = '\0';
	return(src[i] == L'\0');
}

bool wideToChar16(const wchar_t* src, char16_t* dst, size_t len)
{
	if (dst == nullptr || src == nullptr)return false;
	size_t i;
	for (i = 0; ; i++)
	{
		if (src[i] == L'\0' || i == len - 1)break;
		else dst[i] = (char16_t)src[i];
	}
	dst[i] = u'\0';
	return(src[i] == L'\0');
}
#pragma endregion

typedef uint32_t AARTSAAPI_Result;

/* Values not present in the original API */
bool API_INIT = false;
const size_t STR_BUF_LEN = 40;
const unsigned int PACKET_GEN_TIME = 500; // time in milliseconds that a device takes to generate a new data packet
const int32_t AARTSAAPI_CONFIG_TYPE_ERROR	= -1;
const AARTSAAPI_Result AARTSAAPI_ERROR_CBSIZE_NOT_SET = 0x8100'0001;

const uint16_t HANDLE_OPEN = 1 << 0;
const uint16_t DEVICE_OPEN = 1 << 0;
const uint16_t DEVICE_CONNECTED = 1 << 1;
const uint16_t DEVICE_RUNNING = 1 << 2;

/* Constants defined in the original API */
const uint32_t AARTSAAPI_MEMORY_SMALL		= 0;
const uint32_t AARTSAAPI_MEMORY_MEDIUM		= 1;
const uint32_t AARTSAAPI_MEMORY_LARGE		= 2;
const uint32_t AARTSAAPI_MEMORY_LUDICROUS	= 3;

const unsigned long long AARTSAAPI_PACKET_STREAM_START  = 1;
const unsigned long long AARTSAAPI_PACKET_STREAM_END	= 2;
const unsigned long long AARTSAAPI_PACKET_SEGMENT_START = 4;
const unsigned long long AARTSAAPI_PACKET_SEGMENT_END	= 8;

const int32_t AARTSAAPI_CONFIG_TYPE_OTHER	= 0;
const int32_t AARTSAAPI_CONFIG_TYPE_GROUP	= 1;
const int32_t AARTSAAPI_CONFIG_TYPE_BLOB	= 2;
const int32_t AARTSAAPI_CONFIG_TYPE_NUMBER	= 3;
const int32_t AARTSAAPI_CONFIG_TYPE_BOOL	= 4;
const int32_t AARTSAAPI_CONFIG_TYPE_ENUM	= 5;
const int32_t AARTSAAPI_CONFIG_TYPE_STRING	= 6;

const AARTSAAPI_Result AARTSAAPI_OK			= 0x0000'0000;
const AARTSAAPI_Result AARTSAAPI_EMPTY		= 0x0000'0001;
const AARTSAAPI_Result AARTSAAPI_RETRY		= 0x0000'0002;
const AARTSAAPI_Result AARTSAAPI_WARNING	= 0x4000'0000;
const AARTSAAPI_Result AARTSAAPI_ERROR		= 0x8000'0000;
const AARTSAAPI_Result AARTSAAPI_ERROR_NOT_INITIALIZED = 0x8000'0001;
const AARTSAAPI_Result AARTSAAPI_ERROR_NOT_FOUND = 0x8000'0002;
const AARTSAAPI_Result AARTSAAPI_ERROR_BUSY = 0x8000'0003;
const AARTSAAPI_Result AARTSAAPI_ERROR_NOT_OPEN = 0x8000'0004;
const AARTSAAPI_Result AARTSAAPI_ERROR_NOT_CONNECTED = 0x8000'0005;
const AARTSAAPI_Result AARTSAAPI_ERROR_INVALID_CONFIG = 0x8000'0006;
const AARTSAAPI_Result AARTSAAPI_ERROR_BUFFER_SIZE = 0x8000'0007;
const AARTSAAPI_Result AARTSAAPI_ERROR_INVALID_CHANNEL = 0x8000'0008;
const AARTSAAPI_Result AARTSAAPI_ERROR_INVALID_PARAMETR = 0x8000'0009;
const AARTSAAPI_Result AARTSAAPI_ERROR_INVALID_SIZE = 0x8000'000a;
const AARTSAAPI_Result AARTSAAPI_ERROR_MISSING_PATHS_FILE = 0x8000'000b;
const AARTSAAPI_Result AARTSAAPI_ERROR_VALUE_INVALID = 0x8000'000c;
const AARTSAAPI_Result AARTSAAPI_ERROR_VALUE_MALFORMED = 0x8000'000d;

#define NULLPTR_CHECK(X){ if(X == nullptr){std::cerr << __func__ << ": " << #X << " was nullptr!" << std::endl; return AARTSAAPI_ERROR;}}
#define API_INIT_CHECK {if(!API_INIT){std::cerr << __func__ << ": api not initialised" << std::endl; return AARTSAAPI_ERROR_NOT_INITIALIZED;}}
#define ERROR_MSG(X) std::cerr << __func__ << ": " << X << std::endl

struct AARTSAAPI_ConfigInfo
{
	int64_t cbsize = 0;
	wchar_t name[STR_BUF_LEN] = {};
	wchar_t title[STR_BUF_LEN] = {};
	int32_t type = AARTSAAPI_CONFIG_TYPE_ERROR;
	union S
	{
		wchar_t str[STR_BUF_LEN];
		double value = 0;
		int64_t idx;
	}data;
};

struct AARTSAAPI_ConfigData
{
	std::vector<AARTSAAPI_ConfigData*> children;	//AARTSAAPI_Config
	size_t idx = 0;
	AARTSAAPI_ConfigInfo ci;
};
typedef AARTSAAPI_ConfigData* AARTSAAPI_Config;

struct AARTSAAPI_DeviceInfo
{
	int64_t		cbsize;				// size of data structure, filled in by caller

	wchar_t		serialNumber[120];	// serial number of the device
	bool		ready;				// device is ready and booted
	bool		boost;				// device has a second USB connector
	bool		superspeed;			// device uses superspeed
	bool		active;				// device is already in use
};

struct AARTSAAPI_Device
{
	void* d;
	AARTSAAPI_Config root = nullptr;
	uint16_t flags = 0;
	std::thread packetGenerator;
	int32_t numberOfPackets = 0;
	void init()
	{
		AARTSAAPI_ConfigData* cdRoot = new AARTSAAPI_ConfigData;
		wstringCpy(L"root", cdRoot->ci.name, STR_BUF_LEN);
		cdRoot->ci.type = AARTSAAPI_CONFIG_TYPE_GROUP;

		AARTSAAPI_ConfigData* cdMain = new AARTSAAPI_ConfigData;
		wstringCpy(L"main", cdMain->ci.name, STR_BUF_LEN);
		cdMain->ci.type = AARTSAAPI_CONFIG_TYPE_GROUP;
		cdRoot->children.push_back(cdMain);

		AARTSAAPI_ConfigData* cdNum = new AARTSAAPI_ConfigData;
		wstringCpy(L"someDouble", cdNum->ci.name, STR_BUF_LEN);
		cdNum->ci.type = AARTSAAPI_CONFIG_TYPE_NUMBER;
		cdNum->ci.data.value = 3.14159;
		cdMain->children.push_back(cdNum);

		AARTSAAPI_ConfigData* cdEnum = new AARTSAAPI_ConfigData;
		wstringCpy(L"someEnum", cdEnum->ci.name, STR_BUF_LEN);
		cdEnum->ci.type = AARTSAAPI_CONFIG_TYPE_ENUM;
		cdEnum->ci.data.idx = 99;
		cdMain->children.push_back(cdEnum);

		AARTSAAPI_ConfigData* cdDevice = new AARTSAAPI_ConfigData;
		wstringCpy(L"device", cdDevice->ci.name, STR_BUF_LEN);
		cdDevice->ci.type = AARTSAAPI_CONFIG_TYPE_GROUP;
		cdRoot->children.push_back(cdDevice);

		AARTSAAPI_ConfigData* cdStr = new AARTSAAPI_ConfigData;
		wstringCpy(L"someString", cdStr->ci.name, STR_BUF_LEN);
		cdStr->ci.type = AARTSAAPI_CONFIG_TYPE_STRING;
		wstringCpy(L"some Value", cdStr->ci.data.str, STR_BUF_LEN);
		cdDevice->children.push_back(cdStr);

		AARTSAAPI_ConfigData* cdfft = new AARTSAAPI_ConfigData;
		wstringCpy(L"fft1", cdfft->ci.name, STR_BUF_LEN);
		cdfft->ci.type = AARTSAAPI_CONFIG_TYPE_GROUP;
		cdDevice->children.push_back(cdfft);

		AARTSAAPI_ConfigData* cdfftSize = new AARTSAAPI_ConfigData;
		wstringCpy(L"fftsize", cdfftSize->ci.name, STR_BUF_LEN);
		cdfftSize->ci.type = AARTSAAPI_CONFIG_TYPE_NUMBER;
		cdfftSize->ci.data.value = 1200;
		cdfft->children.push_back(cdfftSize);

		this->root = cdRoot;
	}
	~AARTSAAPI_Device()
	{
		if (flags & DEVICE_RUNNING)
		{
			ERROR_MSG("Device was not stopped.");
		}
		if (flags & DEVICE_CONNECTED)
		{
			ERROR_MSG("Device was not disconnected.");
		}
		if (packetGenerator.joinable())
		{
			this->flags = 0;
			packetGenerator.join();
		}
		if(root != nullptr)cleanConf(root);
	}

	static void generatePackets(AARTSAAPI_Device* dPtr)
	{
		while (dPtr->flags & DEVICE_RUNNING)
		{
			(dPtr->numberOfPackets)++;
			if (dPtr->numberOfPackets < 0) dPtr->numberOfPackets = INT32_MAX;
			std::this_thread::sleep_for(std::chrono::milliseconds(PACKET_GEN_TIME));
		}
	}
private:
	static void cleanConf(AARTSAAPI_ConfigData* elm)
	{
		if (elm->children.size() > 0)
		{
			for (auto& child : elm->children)delete child;
		}
		delete elm;
	}
};

struct AARTSAAPI_Handle
{
	void* d;
	uint16_t flags = 0;
	std::vector<AARTSAAPI_Device*> devices;
	~AARTSAAPI_Handle()
	{
		if (API_INIT)
		{
			std::cerr << __func__ << ": program might have terminated without a call to AARTSAAPI_Shutdown" << std::endl;
		}
	}
};

struct AARTSAAPI_Packet
{
	int64_t		cbsize;				// size of data structure, filled in by caller

	uint64_t	streamID;
	uint64_t	flags;

	double		startTime;			// start time in seconds since start of the unix epoch
	double		endTime;			// end time in seconds since start of the unix epoch
	double		startFrequency;		// start frequency of the data
	double		stepFrequency;		// bin size or sampel rate of the data
	double		spanFrequency;		// valid frequency range, center is start + span / 2
	double		rbwFrequency;		// realtime bandwidth in spectrum data

	int64_t		num;				// number of samples used in the packet
	int64_t		total;				// total number of samples of the packet
	int64_t		size;				// size of each sample
	int64_t		stride;				// offset from sample to sample in floats
	float* fp32;
};

AARTSAAPI_Result AARTSAAPI_ConfigRoot(AARTSAAPI_Device* dP, AARTSAAPI_Config* cP)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dP);
	NULLPTR_CHECK(cP);

	*cP = dP->root;
	return AARTSAAPI_OK;
}

AARTSAAPI_Result AARTSAAPI_ConfigNext(AARTSAAPI_Device* dP, AARTSAAPI_Config* configIn, AARTSAAPI_Config* configOut)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dP);
	NULLPTR_CHECK(configIn);
	NULLPTR_CHECK(configOut);

	(*configIn)->idx += 1;
	if ((*configIn)->idx >= (*configIn)->children.size())
	{
		return AARTSAAPI_EMPTY;
	}
	else
	{
		*configOut = (*configIn)->children[(*configIn)->idx];
		return AARTSAAPI_OK;
	}
}

AARTSAAPI_Result AARTSAAPI_ConfigGetInfo(AARTSAAPI_Device* dP, AARTSAAPI_Config* configIn, AARTSAAPI_ConfigInfo* cInfoOut)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dP);
	NULLPTR_CHECK(configIn);
	NULLPTR_CHECK(cInfoOut);

	if (cInfoOut->cbsize != sizeof(AARTSAAPI_ConfigInfo))
	{
		std::cerr << "cbSize not set error!" << std::endl;
		return AARTSAAPI_ERROR_CBSIZE_NOT_SET;
	}

	*cInfoOut = (*configIn)->ci;
	if (cInfoOut->type == AARTSAAPI_CONFIG_TYPE_ERROR)
	{
		return AARTSAAPI_EMPTY;
	}
	else
	{
		return AARTSAAPI_OK;
	}
}

AARTSAAPI_Result AARTSAAPI_ConfigGetString(AARTSAAPI_Device* dP, AARTSAAPI_Config* configIn, wchar_t* strOut, int64_t* len)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dP);
	NULLPTR_CHECK(configIn);
	NULLPTR_CHECK(strOut);
	NULLPTR_CHECK(len);

	if (wstringCpy((*configIn)->ci.data.str, strOut, (size_t)*len))
	{
		return AARTSAAPI_OK;
	}
	else
	{
		return AARTSAAPI_ERROR;
	}
}

AARTSAAPI_Result AARTSAAPI_ConfigSetString(AARTSAAPI_Device* dhandle, AARTSAAPI_Config* config, const wchar_t* value)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);
	NULLPTR_CHECK(config);
	NULLPTR_CHECK(value);

	if (wstringCpy(value, (*config)->ci.data.str, STR_BUF_LEN))
	{
		return AARTSAAPI_OK;
	}
	else
	{
		return AARTSAAPI_ERROR;
	}
}

AARTSAAPI_Result AARTSAAPI_ConfigSetFloat(AARTSAAPI_Device* dhandle, AARTSAAPI_Config* config, double value)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);
	NULLPTR_CHECK(config);

	(*config)->ci.data.value = value;
	return AARTSAAPI_OK;
}

AARTSAAPI_Result AARTSAAPI_ConfigGetFloat(AARTSAAPI_Device* dhandle, AARTSAAPI_Config* config, double* value)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);
	NULLPTR_CHECK(config);
	NULLPTR_CHECK(value);

	*value = (*config)->ci.data.value;
	return AARTSAAPI_OK;
}

AARTSAAPI_Result AARTSAAPI_ConfigSetInteger(AARTSAAPI_Device* dhandle, AARTSAAPI_Config* config, int64_t value)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);
	NULLPTR_CHECK(config);

	(*config)->ci.data.idx = value;
	return AARTSAAPI_OK;
}

AARTSAAPI_Result AARTSAAPI_ConfigGetInteger(AARTSAAPI_Device* dhandle, AARTSAAPI_Config* config, int64_t* value)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);
	NULLPTR_CHECK(config);
	NULLPTR_CHECK(value);

	*value = (*config)->ci.data.idx;
	return AARTSAAPI_OK;
}

AARTSAAPI_Result AARTSAAPI_ConfigFirst(AARTSAAPI_Device* dhandle, AARTSAAPI_Config* group, AARTSAAPI_Config* config)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);
	NULLPTR_CHECK(group);
	NULLPTR_CHECK(config);

	if ((*group)->children.size() == 0)
	{
		std::cerr << "AARTSAAPI_ConfigFirst: empty config group." << std::endl;
		return AARTSAAPI_EMPTY;
	}
	else
	{
		*config = (*group)->children[0];
		(*group)->idx = 0;
		return AARTSAAPI_OK;
	}
}

AARTSAAPI_Result AARTSAAPI_ConfigGetName(AARTSAAPI_Device* dhandle, AARTSAAPI_Config* config, wchar_t* name)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);
	NULLPTR_CHECK(config);
	NULLPTR_CHECK(name);

	if (wstringCpy((*config)->ci.name, name, STR_BUF_LEN))
	{
		return AARTSAAPI_OK;
	}
	else
	{
		return AARTSAAPI_ERROR;
	}
}

AARTSAAPI_Result AARTSAAPI_RescanDevices(AARTSAAPI_Handle* handle, int timeout)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(handle);

	for (auto& device : handle->devices)device->flags = 0;
	return AARTSAAPI_OK;
}

AARTSAAPI_Result AARTSAAPI_ResetDevices(AARTSAAPI_Handle* handle)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(handle);

	for (auto& device : handle->devices)device->flags = 0;
	return AARTSAAPI_OK;
}

AARTSAAPI_Result AARTSAAPI_EnumDevice(AARTSAAPI_Handle* handle, const wchar_t* type, int32_t index, AARTSAAPI_DeviceInfo* dinfo)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(handle);
	NULLPTR_CHECK(type);
	NULLPTR_CHECK(dinfo);

	if (dinfo->cbsize != sizeof(AARTSAAPI_DeviceInfo))
	{
		std::cerr << "cbSize not set error!" << std::endl;
		return AARTSAAPI_ERROR_CBSIZE_NOT_SET;
	}

	if (wstringComp(L"spectranv6", type) && (handle->flags & HANDLE_OPEN))
	{
		return AARTSAAPI_OK;
	}
	else
	{
		return AARTSAAPI_ERROR;
	}
}

AARTSAAPI_Result AARTSAAPI_OpenDevice(AARTSAAPI_Handle* handle, AARTSAAPI_Device* dhandle, const wchar_t* type, const wchar_t* serialNumber)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(handle);
	NULLPTR_CHECK(dhandle);
	NULLPTR_CHECK(type);
	NULLPTR_CHECK(serialNumber);

	if (handle == nullptr || !(handle->flags & HANDLE_OPEN))
	{
		std::cerr << "AARTSAAPI_OpenDevice : handle" << std::endl;
		return AARTSAAPI_ERROR;
	}
	if (dhandle == nullptr || dhandle->flags & DEVICE_OPEN)
	{
		std::cerr << "AARTSAAPI_OpenDevice : device" << std::endl;
		return AARTSAAPI_ERROR;
	}
	else
	{
		dhandle->flags |= DEVICE_OPEN;
		handle->devices.push_back(dhandle);
		dhandle->init();
		return AARTSAAPI_OK;
	}
}

AARTSAAPI_Result AARTSAAPI_CloseDevice(AARTSAAPI_Handle* handle, AARTSAAPI_Device* dhandle)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(handle);
	NULLPTR_CHECK(dhandle);

	if (dhandle->flags & DEVICE_OPEN)
	{
		dhandle->flags = 0;
		for (auto it = handle->devices.begin(); it != handle->devices.end(); it++)
		{
			if (*it == dhandle)handle->devices.erase(it);
		}
		return AARTSAAPI_OK;
	}
	else
	{
		std::cerr << "AARTSAAPI_CloseDevice : device not open" << std::endl;
		return AARTSAAPI_ERROR;
	}
}

AARTSAAPI_Result AARTSAAPI_ConnectDevice(AARTSAAPI_Device* dhandle)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);

	if (dhandle->flags & DEVICE_CONNECTED)
	{
		std::cerr << "AARTSAAPI_ConnectDevice : device already connected" << std::endl;
		return AARTSAAPI_ERROR;
	}
	else
	{
		dhandle->flags |= DEVICE_CONNECTED;
		return AARTSAAPI_OK;
	}
}

AARTSAAPI_Result AARTSAAPI_DisconnectDevice(AARTSAAPI_Device* dhandle)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);

	if (dhandle != nullptr && dhandle->flags & DEVICE_CONNECTED)
	{
		dhandle->flags &= ~DEVICE_CONNECTED;
		return AARTSAAPI_OK;
	}
	else
	{
		std::cerr << "AARTSAAPI_DisconnectDevice : device not connected" << std::endl;
		return AARTSAAPI_ERROR;
	}
}

AARTSAAPI_Result AARTSAAPI_StartDevice(AARTSAAPI_Device* dhandle)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);

	if (dhandle == nullptr || dhandle->flags & DEVICE_RUNNING)
	{
		std::cerr << "AARTSAAPI_StartDevice : device" << std::endl;
		return AARTSAAPI_ERROR;
	}
	else
	{
		dhandle->flags |= DEVICE_RUNNING;
		dhandle->packetGenerator = std::thread(AARTSAAPI_Device::generatePackets, dhandle);
		return AARTSAAPI_OK;
	}
}

AARTSAAPI_Result AARTSAAPI_StopDevice(AARTSAAPI_Device* dhandle)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);

	if (dhandle != nullptr && dhandle->flags & DEVICE_RUNNING)
	{
		dhandle->flags &= ~DEVICE_RUNNING;
		dhandle->packetGenerator.join();
		return AARTSAAPI_OK;
	}
	else
	{
		std::cerr << "AARTSAAPI_StopDevice : device" << std::endl;
		return AARTSAAPI_ERROR;
	}
}

AARTSAAPI_Result AARTSAAPI_GetDeviceState(AARTSAAPI_Device* dhandle)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);

	//TODO: implementation
	if (dhandle == nullptr)
	{
		std::cerr << "AARTSAAPI_GetDeviceState : device" << std::endl;
		return AARTSAAPI_ERROR;
	}
	return AARTSAAPI_OK;
}

AARTSAAPI_Result AARTSAAPI_Init(uint32_t memory)
{
	if (API_INIT)
	{
		std::cerr << "DOUBLE INIT CAUSED ABORT!" << std::endl;
		exit(1);
	}
	else if(memory >= 0 && memory <= 3)
	{
		API_INIT = true;
	}
	else
	{
		std::cerr << __func__ << ": memory needs to be in {0, 1, 2, 3}, was " << memory << std::endl;
	}
	return AARTSAAPI_OK;
}

AARTSAAPI_Result AARTSAAPI_Shutdown(void)
{
	if (API_INIT)
	{
		API_INIT = false;
		return AARTSAAPI_OK;
	}
	else
	{
		std::cerr << "SHUTDOWN WITHOUT INIT CAUSES NULL POINTER DEALLOCATION!" << std::endl;
		exit(1);
	}
}

AARTSAAPI_Result AARTSAAPI_Version(void)
{
	std::cout << "DEBUG VERSION OF API" << std::endl;
	return AARTSAAPI_OK;
}

AARTSAAPI_Result AARTSAAPI_Open(AARTSAAPI_Handle* handle)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(handle);

	if (handle->flags & HANDLE_OPEN)
	{
		std::cerr << "AARTSAAPI_Open : handle already open" << std::endl;
		return AARTSAAPI_ERROR;
	}
	else
	{
		handle->flags |= HANDLE_OPEN;
		return AARTSAAPI_OK;
	}
}

AARTSAAPI_Result AARTSAAPI_Close(AARTSAAPI_Handle* handle)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(handle);

	if (handle != nullptr && handle->flags & HANDLE_OPEN)
	{
		handle->flags &= ~HANDLE_OPEN;
		return AARTSAAPI_OK;
	}
	else
	{
		std::cerr << "AARTSAAPI_Close : handle" << std::endl;
		return AARTSAAPI_ERROR;
	}
}

AARTSAAPI_Result AARTSAAPI_AvailPackets(AARTSAAPI_Device* dhandle, int32_t channel, int32_t* num)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);
	NULLPTR_CHECK(num);

	//TODO: check valid channel
	if (dhandle != nullptr && dhandle->flags & DEVICE_RUNNING)
	{
		if (num == nullptr)
		{
			std::cerr << "AARTSAAPI_AvailPackets : num" << std::endl;
			return AARTSAAPI_ERROR;
		}
		else
		{
			*num = dhandle->numberOfPackets;
		}
		return AARTSAAPI_OK;
	}
	else
	{
		std::cerr << "AARTSAAPI_AvailPackets : device" << std::endl;
		return AARTSAAPI_ERROR;
	}
}

AARTSAAPI_Result AARTSAAPI_GetPacket(AARTSAAPI_Device* dhandle, int32_t channel, int32_t index, AARTSAAPI_Packet* packet)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);
	NULLPTR_CHECK(packet);

	if (packet->cbsize != sizeof(AARTSAAPI_Packet))
	{
		std::cerr << "AARTSAAPI_GetPacket: cbSize not set error!" << std::endl;
		return AARTSAAPI_ERROR_CBSIZE_NOT_SET;
	}

	if (dhandle == nullptr)
	{
		std::cerr << "AARTSAAPI_GetPacket : device" << std::endl;
		return AARTSAAPI_ERROR;
	}

	if (packet == nullptr)
	{
		std::cerr << "AARTSAAPI_GetPacket : packet" << std::endl;
		return AARTSAAPI_ERROR;
	}

	if (dhandle->flags & DEVICE_RUNNING)
	{
		//TODO: check valid channel
		if (dhandle->numberOfPackets <= 0)
		{
			return AARTSAAPI_EMPTY;
		}
		else
		{
			packet->num = 10;
			packet->size = 2;
			packet->stride = 2;
			packet->fp32 = new float[20];	// memory leak
			for (int i = 0; i < 20; i++)packet->fp32[i] = (rand() % 200)/ 100.0f - 1.0f;
			return AARTSAAPI_OK;
		}
	}
	else
	{
		std::cerr << "AARTSAAPI_GetPacket: device not running." << std::endl;
		return AARTSAAPI_ERROR;
	}
}

AARTSAAPI_Result AARTSAAPI_ConsumePackets(AARTSAAPI_Device* dhandle, int32_t channel, int32_t num)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);

	//TOD: check valid channel
	if (num < 0)
	{
		std::cerr << "AARTSAAPI_ConsumePackets: Number of packets to consume must be non-negative, was : " << num << std::endl;
		return AARTSAAPI_ERROR;
	}

	if (num > dhandle->numberOfPackets)
	{
		std::cerr << "AARTSAAPI_ConsumePackets: Number of packets to consume exceeds available packets : " << num << " > " << dhandle->numberOfPackets << std::endl;
		return AARTSAAPI_ERROR;
	}

	dhandle->numberOfPackets -= num;

	return AARTSAAPI_OK;
}

AARTSAAPI_Result AARTSAAPI_GetMasterStreamTime(AARTSAAPI_Device* dhandle, double& stime)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);

	if (dhandle->flags & DEVICE_RUNNING)
	{
		stime = 0;
		return AARTSAAPI_OK;
	}
	else
	{
		std::cerr << "AARTSAAPI_GetMasterStreamTime : device not running" << std::endl;
		return AARTSAAPI_ERROR;
	}
}

AARTSAAPI_Result AARTSAAPI_SendPacket(AARTSAAPI_Device* dhandle, int32_t channel, const AARTSAAPI_Packet* packet)
{
	API_INIT_CHECK;
	NULLPTR_CHECK(dhandle);
	NULLPTR_CHECK(packet);

	if (packet->cbsize != sizeof(AARTSAAPI_Packet))
	{
		std::cerr << "AARTSAAPI_SendPacket: cbSize not set error!" << std::endl;
		return AARTSAAPI_ERROR_CBSIZE_NOT_SET;
	}
	//TODO: check valid channel and valid packet
	//eg. valid packet times, valid frequencies, etc
	if (dhandle->flags & DEVICE_RUNNING)
	{
		return AARTSAAPI_OK;
	}
	else
	{
		std::cerr << "AARTSAAPI_GetMasterStreamTime : device not running" << std::endl;
		return AARTSAAPI_ERROR;
	}
}

#endif /* AARTSAAPI_LIB */
#endif /* _DEBUG */