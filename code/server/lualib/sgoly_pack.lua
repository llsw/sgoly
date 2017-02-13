local crypt = require "crypt"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
sgoly_pack={}
function sgoly_pack.encode(req)
	local who="123456"
	local json_texten = cjson.encode(req)
    local pden =crypt.aesencode(json_texten,who,"")
    local stren = crypt.base64encode(pden)
    return stren
end

function sgoly_pack.decode(req)
	local who="123456"
	local json_textde = crypt.base64decode(req)
    local pdde =crypt.aesdecode(json_textde,who,"")
    local strde = cjson.decode(pdde)
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

function sgoly_pack.checkup(end_point,beilv,k,cost)
    if end_point*beilv*k==tonumber(cost) then
        if (end_point=="1000" or end_point=="2000" or end_point=="3000" 
            or end_point=="4000" or end_point=="5000") and 
        (beilv=="1" or beilv=="5" or beilv=="10" or beilv=="50" or beilv=="100") and 
        (k=="1" or k=="10" or k=="30" or k=="50" or k=="100") then
        return true
        else
            return false
        end
    else
        return false
    end
end
return sgoly_pack