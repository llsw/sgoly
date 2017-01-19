local crypt = require "crypt"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
sgoly_pack={}
function sgoly_pack.encode(req)
	local who="123456"
	local json_texten = cjson.encode(req)
    local pden =crypt.aesencode(json_text,who,"")
    local stren = crypt.base64encode(password)
    return stren
end

function sgoly_pack.decode(req)
	local who="123456"
	local json_textde = cjson.decode(req)
    local pdde =crypt.aesdecode(json_textde,who,"")
    local strde = crypt.base64encode(pdde)
    return strde
end

function sgoly_pack.c2s(req)
	local who="123456"
	local json_textc2s = cjson.encode(req)
    local pdc2s =crypt.aesencode(json_textc2s,who,"")
    local strc2s = crypt.base64encode(pdc2s)
    local result = string.pack(">s2", strc2s)
    return result
end
return sgoly_pack