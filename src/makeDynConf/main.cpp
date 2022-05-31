#include <aaroniartsaapi.h>
#include "myStringFunc.h"
#include <iostream>


#ifdef MATLAB
#include "mex.hpp"
#include "mexAdapter.hpp"
using namespace matlab::data;
using matlab::mex::ArgumentList;
#pragma comment(lib, "C:\\Program Files\\Aaronia AG\\Aaronia RTSA-Suite PRO\\sdk\\aaroniartsaapi.lib")

/// <summary>
/// return void pointer type from input type uint64_t destructively.
/// The argument check has to be made beforehand!
/// </summary>
/// <param name="args">moste likely the input argument list of the ()operator.</param>
/// <param name="ind">index of the uint64_t parameter to be transformed.</param>
/// <returns>void* value of uint64_t input arg.</returns>
inline void* getVoidP(ArgumentList& args, size_t ind)
{
	return (void*)(uint64_t)(TypedArray<uint64_t>(std::move(args[ind]))[0]);
}

StructArray addGrpProp(AARTSAAPI_Device* device_ptr, AARTSAAPI_Config* grp);

void addElmProp(AARTSAAPI_Device* device_ptr, AARTSAAPI_Config* elm, StructArray& S)
{
	AARTSAAPI_Result res = 0;
	ArrayFactory f;
	int64_t twoHundred = 200;
	char elm_name[200];
	AARTSAAPI_ConfigInfo ci = { sizeof(AARTSAAPI_ConfigInfo) };
	AARTSAAPI_ConfigGetInfo(device_ptr, elm, &ci);
	wideToChar(ci.name, elm_name, 200);
	union U
	{
		double d;
		wchar_t strW[200];
		char16_t str16[200];
		int64_t i;
	}value;

	if ((res = AARTSAAPI_ConfigGetInfo(device_ptr, elm, &ci)) != AARTSAAPI_OK)
	{
		//TODO: No Info Error
	}
	else
	{
		switch (ci.type)
		{
		/* Add Propertie and value */
		case AARTSAAPI_CONFIG_TYPE_NUMBER:
			value.d = 0;
			AARTSAAPI_ConfigGetFloat(device_ptr, elm, &value.d);
			S[0][elm_name] = f.createScalar<double>(value.d);
			break;
		case AARTSAAPI_CONFIG_TYPE_STRING:
		case AARTSAAPI_CONFIG_TYPE_BOOL:
			AARTSAAPI_ConfigGetString(device_ptr, elm, value.strW, &twoHundred);
			wideToChar16(value.strW, value.str16, 200);
			S[0][elm_name] = f.createCharArray(value.str16);
			break;
		case AARTSAAPI_CONFIG_TYPE_ENUM:
			AARTSAAPI_ConfigGetInteger(device_ptr, elm, &value.i);
			S[0][elm_name] = f.createScalar<int>(value.i);
			break;

		/* Add Propertie and call GRP function */
		case AARTSAAPI_CONFIG_TYPE_GROUP:
			S[0][elm_name] = addGrpProp(device_ptr, elm);
			break;
		default:
			std::cerr << elm_name << ", is of non handled type: " << ci.type << std::endl;
			break;
		}
	}
}

void getElmNames(AARTSAAPI_Device* device_ptr, AARTSAAPI_Config* elm, std::vector<std::string>* fieldNames)
{	
	AARTSAAPI_ConfigInfo ci = {sizeof(AARTSAAPI_ConfigInfo )};
	AARTSAAPI_ConfigGetInfo(device_ptr, elm, &ci);
	char elm_name[200];
	wideToChar(ci.name, elm_name, 200);
	fieldNames->push_back(elm_name);
}

StructArray addGrpProp(AARTSAAPI_Device* device_ptr, AARTSAAPI_Config* grp)
{
	//Add all children of grp as Properties to dynConf by first collecting the names
	AARTSAAPI_Config c;
	ArrayFactory f;

	/* First Pass: Get Propertie names */
	std::vector<std::string> names;
	
	if (AARTSAAPI_ConfigFirst(device_ptr, grp, &c) == AARTSAAPI_OK)
	{
		do
		{
			getElmNames(device_ptr, &c, &names);
		} while (AARTSAAPI_ConfigNext(device_ptr, grp, &c) == AARTSAAPI_OK);
	}
	StructArray S = f.createStructArray({ 1,1 }, names);
	
	/* Second Pass: populate fields */
	if (AARTSAAPI_ConfigFirst(device_ptr, grp, &c) == AARTSAAPI_OK)
	{
		do
		{
			addElmProp(device_ptr, &c, S);
		} while (AARTSAAPI_ConfigNext(device_ptr, grp, &c) == AARTSAAPI_OK);
	}

	return S;
}


class MexFunction : public matlab::mex::Function
{
public:
	void operator()(ArgumentList outputArgs, ArgumentList inputArgs)
	{
		std::shared_ptr<matlab::engine::MATLABEngine> matlabPtr = getEngine();
		matlab::data::ArrayFactory factory;

		if (inputArgs.size() < 2)
		{
			matlabPtr->feval(u"error", 0, std::vector<Array>({ factory.createScalar("Not enough input arguments!") }));
		}

		if (inputArgs[0].getType() != ArrayType::UINT64)
		{
			matlabPtr->feval(u"error", 0, std::vector<Array>({ factory.createScalar("Input DEVICE PTR must be of type uint64!") }));
		}

		if (inputArgs[1].getType() != ArrayType::HANDLE_OBJECT_REF)
		{
			matlabPtr->feval(u"error", 0, std::vector<Array>({ factory.createScalar("Input DYNAMIC CONFIG REF must be of type HANDLE_OBJECT_REF!") }));
		}

		/* normale ausführung */
		AARTSAAPI_Device device_handle = { getVoidP(inputArgs, 0) };

		/* dummy variante */
		/* Root has fields Main & Device
		/*  Main has fields someDouble and someEnum
		/*  Device has field someString and group fft1
		/*   fft1 has number fftsize
		*/
		//AARTSAAPI_Device device_handle;
		
		Array dynamicConfig(inputArgs[1]);
		//Dynamically fill Propertie of Class
		//	matlabPtr->feval(u"addprop", 0, std::vector<Array>({ dynamicConfig, factory.createCharArray("mexProp") }));
		//	auto S = factory.createStructArray({ 1,1 }, { "A", "B", "C" });
		//	S[0]["B"] = factory.createScalar<double>(1.2);
		//	S[0]["C"] = factory.createCharArray("String Value");
		//	S[0]["A"] = factory.createStructArray({ 1,1 }, { "X" });
		//	matlabPtr->setProperty(dynamicConfig, u"mexProp", S);

		AARTSAAPI_Config root;
		AARTSAAPI_Config elm;
		AARTSAAPI_ConfigInfo ci = {sizeof(AARTSAAPI_ConfigInfo)};
		char16_t grp_name[200];

		if (AARTSAAPI_ConfigRoot(&device_handle, &root) != AARTSAAPI_OK)
		{
			std::cerr << "Error: No root" << std::endl;
		}
		else
		{
			// Add root group without placing 'root' as propertie
			// Only the first Layer needs to be added as a dynamic propertie!
			if (AARTSAAPI_ConfigFirst(&device_handle, &root, &elm) == AARTSAAPI_OK)
			{
				do
				{
					AARTSAAPI_ConfigGetInfo(&device_handle, &elm, &ci);
					wideToChar16(ci.name, grp_name, 200);
					matlabPtr->feval(u"addprop", 0, std::vector<Array>({ dynamicConfig, factory.createCharArray(grp_name) }));
					matlabPtr->setProperty(dynamicConfig, grp_name, addGrpProp(&device_handle, &elm));
				} while (AARTSAAPI_ConfigNext(&device_handle, &root, &elm) == AARTSAAPI_OK);
			}
			else
			{
				std::cerr << "Error: No First" << std::endl;
			}
		}
		
	}
};
#else

int main(int argc, char** argv)
{
	AARTSAAPI_Device d;
	AARTSAAPI_Device dd;
	
	return 0;
}
#endif