#ifndef MYSTRINGFUNC_LIB
#define MYSTRINGFUNC_LIB
#include <cstring>

/// <summary>
/// Copies wide char string from source to destination
/// </summary>
/// <param name="src">Source string.</param>
/// <param name="dst">Destination string.</param>
/// <param name="len">Length of destination buffer.</param>
/// <returns>True if destination buffer holds all characters of source string after function returns.</returns>
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

#endif /* MYSTRINGFUNC_LIB */
