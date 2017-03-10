#include <lua.h>
#include <lauxlib.h>
#include <string.h>
#include <xxtea.h>
#include <stdlib.h>


static unsigned char *fix_key_length(unsigned char *key, xxtea_long key_len)
{
    unsigned char *tmp = (unsigned char *)malloc(16);
    memcpy(tmp, key, key_len);
    memset(tmp + key_len, '\0', 16 - key_len);
    return tmp;
}


static unsigned char *xxtea_to_byte_array(xxtea_long *data, xxtea_long len, int include_length, xxtea_long *ret_len) {
    xxtea_long i, n, m;
    unsigned char *result;
    
    n = len << 2;
    if (include_length) {
        m = data[len - 1];
        if ((m < n - 7) || (m > n - 4)) return NULL;
        n = m;
    }
    result = (unsigned char *)malloc(n + 1);
    for (i = 0; i < n; i++) {
        result[i] = (unsigned char)((data[i >> 2] >> ((i & 3) << 3)) & 0xff);
    }
    result[n] = '\0';
    *ret_len = n;
    
    return result;
}


static xxtea_long *xxtea_to_long_array(unsigned char *data, xxtea_long len, int include_length, xxtea_long *ret_len) {
    xxtea_long i, n, *result;
    
    n = len >> 2;
    n = (((len & 3) == 0) ? n : n + 1);
    if (include_length) {
        result = (xxtea_long *)malloc((n + 1) << 2);
        result[n] = len;
        *ret_len = n + 1;
    } else {
        result = (xxtea_long *)malloc(n << 2);
        *ret_len = n;
    }
    memset(result, 0, n << 2);
    for (i = 0; i < len; i++) {
        result[i >> 2] |= (xxtea_long)data[i] << ((i & 3) << 3);
    }
    
    return result;
}

static unsigned char *do_xxtea_encrypt(unsigned char *data, xxtea_long len, unsigned char *key, xxtea_long *ret_len) {
    unsigned char *result;
    xxtea_long *v, *k, v_len, k_len;
    
    v = xxtea_to_long_array(data, len, 1, &v_len);
    k = xxtea_to_long_array(key, 16, 0, &k_len);
    xxtea_long_encrypt(v, v_len, k);
    result = xxtea_to_byte_array(v, v_len, 0, ret_len);
    free(v);
    free(k);
    
    return result;
}

static unsigned char *do_xxtea_decrypt(unsigned char *data, xxtea_long len, unsigned char *key, xxtea_long *ret_len) {
    unsigned char *result;
    xxtea_long *v, *k, v_len, k_len;
    
    v = xxtea_to_long_array(data, len, 0, &v_len);
    k = xxtea_to_long_array(key, 16, 0, &k_len);
    xxtea_long_decrypt(v, v_len, k);
    result = xxtea_to_byte_array(v, v_len, 1, ret_len);
    free(v);
    free(k);
    
    return result;
}

unsigned char *xxtea_encrypt(unsigned char *data, xxtea_long data_len, unsigned char *key, xxtea_long key_len, xxtea_long *ret_length)
{
    unsigned char *result;
    
    *ret_length = 0;
    
    if (key_len < 16) {
        unsigned char *key2 = fix_key_length(key, key_len);
        result = do_xxtea_encrypt(data, data_len, key2, ret_length);
        free(key2);
    }
    else
    {
        result = do_xxtea_encrypt(data, data_len, key, ret_length);
    }
    
    return result;
}

unsigned char *xxtea_decrypt(unsigned char *data, xxtea_long data_len, unsigned char *key, xxtea_long key_len, xxtea_long *ret_length)
{
    unsigned char *result;
    
    *ret_length = 0;
    
    if (key_len < 16) {
        unsigned char *key2 = fix_key_length(key, key_len);
        result = do_xxtea_decrypt(data, data_len, key2, ret_length);
        free(key2);
    }
    else
    {
        result = do_xxtea_decrypt(data, data_len, key, ret_length);
    }
    
    return result;
}


static int lencryptXXTEA(lua_State *L) {
	size_t vsz = 0;
	size_t keysz = 0;

	// xxtea_long * v =(xxtea_long *)luaL_checklstring(L, 1, &vsz);
	unsigned char * v = (unsigned char *)luaL_checklstring(L, 1, &vsz);
	int len = (xxtea_long)luaL_checknumber(L, 2);
	unsigned char * key = (unsigned char *)luaL_checklstring(L, 3, &keysz);

	xxtea_long resultLen;
    unsigned char* result = xxtea_encrypt(v, (xxtea_long)len, key, (xxtea_long)keysz, &resultLen);
	lua_pushlstring(L, (const char *) result, (int)resultLen);
	free(result);
	return 1;
}

static int ldecryptXXTEA(lua_State *L) {
	size_t vsz = 0;
	size_t keysz = 0;

	// xxtea_long * v =(xxtea_long *)luaL_checklstring(L, 1, &vsz);
	unsigned char * v = (unsigned char *)luaL_checklstring(L, 1, &vsz);
	int len = (xxtea_long)luaL_checknumber(L, 2);
	unsigned char * key = (unsigned char *)luaL_checklstring(L, 3, &keysz);

	xxtea_long resultLen;
    unsigned char* result = xxtea_decrypt(v, (xxtea_long)len, key, (xxtea_long)keysz, &resultLen);
	lua_pushlstring(L, (const char *) result, (int)resultLen);
	free(result);
	return 1;
}

int
luaopen_xxtea(lua_State *L) {
	luaL_checkversion(L);

	luaL_Reg l[] = {
		{ "encryptXXTEA", lencryptXXTEA },
		{ "decryptXXTEA", ldecryptXXTEA },
		{ NULL, NULL },
	};

	luaL_newlib(L,l);
	return 1;
}