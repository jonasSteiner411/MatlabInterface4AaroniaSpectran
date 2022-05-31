// spctrnWrp.h enthält matlab kompatible versionen der funktionen der AARTSAAPI

#ifndef SPCTRNWRP_LIB
#define SPCTRNWRP_LIB

#ifdef SPCTRNWRP_EXPORTS
#define SPCTRNWRP_API __declspec(dllexport)
#else
#define SPCTRNWRP_API __declspec(dllimport)
#endif

#include "pch.h"

#ifdef __cplusplus
extern "C" {
#endif //!__cplusplus
	SPCTRNWRP_API extern bool apiInitialized;
	SPCTRNWRP_API extern AARTSAAPI_Handle globalApiHandle;

	SPCTRNWRP_API uint32_t spctrn_openDevice(const int32_t & index, AARTSAAPI_Device * device_ptr, const wchar_t* type, bool start);
	SPCTRNWRP_API uint32_t spctrn_startDevice(AARTSAAPI_Device * device_ptr);
	SPCTRNWRP_API uint32_t spctrn_stopDevice(AARTSAAPI_Device * device_ptr);
	SPCTRNWRP_API uint32_t spctrn_getPacket(AARTSAAPI_Device * device_ptr, const int32_t & index, const int32_t & channel, AARTSAAPI_Packet * packet_ptr, bool consume);
	SPCTRNWRP_API uint32_t spctrn_consumePackets(AARTSAAPI_Device* device_ptr, const int32_t& channel, const int32_t& num);
	SPCTRNWRP_API int32_t spctrn_availPackets(AARTSAAPI_Device* device_ptr, const int32_t& channel);
	SPCTRNWRP_API uint32_t spctrn_closeDevice(AARTSAAPI_Device * device_ptr);
	SPCTRNWRP_API uint32_t spctrn_setConfig_d(AARTSAAPI_Device * device_ptr, const wchar_t* name, double value);
	SPCTRNWRP_API uint32_t spctrn_setConfig_s(AARTSAAPI_Device * device_ptr, const wchar_t* name, const wchar_t* value);
	SPCTRNWRP_API double spctrn_getConfig_d(AARTSAAPI_Device * device_ptr, const wchar_t* name);
	SPCTRNWRP_API uint32_t spctrn_init(uint32_t memory);
	SPCTRNWRP_API uint32_t spctrn_shutdown();
	SPCTRNWRP_API const wchar_t* spctrn_getConfig_s(AARTSAAPI_Device * device_ptr, const wchar_t* name, wchar_t* value, int64_t size_value);
	SPCTRNWRP_API uint32_t spctrn_setConfig_i(AARTSAAPI_Device* device_ptr, const wchar_t* name, int64_t value);
	SPCTRNWRP_API int64_t spctrn_getConfig_i(AARTSAAPI_Device* device_ptr, const wchar_t* name);
	SPCTRNWRP_API uint32_t spctrn_sendPacket(AARTSAAPI_Device* device_ptr, const int32_t& channel, AARTSAAPI_Packet* packet_ptr);
	SPCTRNWRP_API double spctrn_sendData(AARTSAAPI_Device* device_ptr, const int32_t& channel, const double& centerF, const double& rate, 
		const double& span, const double& start, const int64_t& num, float* data, const int32_t& loop, const bool& absoluteTime);

	SPCTRNWRP_API uint32_t spctrn_deviceState(AARTSAAPI_Device* device_ptr);
	SPCTRNWRP_API uint64_t spctrn_getApiHandle();
	SPCTRNWRP_API uint64_t spctrn_getDeviceHandle(AARTSAAPI_Device* device_ptr);
	SPCTRNWRP_API uint32_t spctrn_getIqData(AARTSAAPI_Device* device_ptr, const int32_t& DeviceIndex, const int32_t& channel, const int64_t& numberOfSamples,
		double samplingRate, const char* filename, const double& start);
	SPCTRNWRP_API uint32_t spctrn_getSpectraData(AARTSAAPI_Device* device_ptr, const int32_t& DeviceIndex, const int32_t& channel, size_t numberOfSamples, double samplingRate, const char* filename, const double& start);
	SPCTRNWRP_API const wchar_t* spctrn_getConfigOptions(AARTSAAPI_Device* device_ptr, const wchar_t* name, wchar_t* value, int64_t size_value);
	SPCTRNWRP_API uint32_t spctrn_transceiveData(AARTSAAPI_Device* device_ptr, const int32_t& index, const int32_t& channelTrans, const int32_t& channelRec,
		const double& centerFTrans, const double& centerFRec, const double& samplingRateTrans, const double& samplingRateRec, const double& spanTrans,
		const double& spanRec, const int64_t& numTrans, const int32_t& numRec, float* data, const double& startTrans, const double& startRec,
		const int32_t& loop, const char* filename);
#ifdef __cplusplus
}
#endif /* __cplusplus */
#endif /* SPCTRNWRP_LIB */