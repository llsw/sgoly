local crypt = require "crypt"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
package.cpath = "../luaclib/xxtea.so;" .. package.cpath
local cjson = require "cjson"
local xxtea = require "xxtea"
sgoly_pack={}
function sgoly_pack.encode(req)
	local who="123456"
	local json_texten = cjson.encode(req)
    --local pden =crypt.aesencode(json_texten,who,"")
    local pden = xxtea.encryptXXTEA(json_texten, #json_texten, who)
    local stren = crypt.base64encode(pden)
    return stren
end

function sgoly_pack.decode(req)
	local who="123456"
	local json_textde = crypt.base64decode(req)
    --local pdde =crypt.aesdecode(json_textde,who,"")
    local pdde =xxtea.decryptXXTEA(json_textde, #json_textde, who)
    local strde = cjson.decode(pdde)
    return strde
end

function sgoly_pack.c2s(req)
	local who="123456"
	local json_textc2s = cjson.encode(req)
    --local pdc2s = crypt.aesencode(json_textc2s,who,"")
    local pdc2s = xxtea.encryptXXTEA(json_textc2s, #json_textc2s, who)
    local strc2s = crypt.base64encode(pdc2s)
    local result = string.pack(">s2", strc2s)
    return result
end

function sgoly_pack.returnfalse(mes,CID,msg)
            local req1={SESSION=mes.SESSION,ID=CID,STATE=false,MESSAGE=msg}
            local req1_1=sgoly_pack.encode(req1)
            return req1_1
end
function sgoly_pack.typereturn(mes,CID,msg)
            local req1={SESSION=mes.SESSION,ID=CID,STATE=false,TYPE=mes.TYPE,MESSAGE=msg}
            local req1_1=sgoly_pack.encode(req1)
            return req1_1
end

function sgoly_pack.filter_account(mes)
        local ss=filter_spec_chars(mes.NAME)
        if (#ss)~=(#mes.NAME) then
            return false
        else 
            return true
        end
end

function sgoly_pack.filter_password(mes)
        local x = 1
        for s in string.gmatch(mes.PASSWD,"[%W]") do
            if s=="," or s=="." or s=="?" or s=="@" or s=="!" then
                   x = 1
            else
                x=0
                break
            end
        end
        if x==1 then
            return true
        else 
            return false
        end
end

function filter_spec_chars(s)  
    local ss = {}  
    for k = 1, #s do  
        local c = string.byte(s,k)  
        if not c then break end  
        if (c>=48 and c<=57) or (c>= 65 and c<=90) or c==95 or (c>=97 and c<=122) then  
            table.insert(ss, string.char(c))  
        elseif c>=228 and c<=233 then  
            local c1 = string.byte(s,k+1)  
            local c2 = string.byte(s,k+2)  
            if c1 and c2 then  
                local a1,a2,a3,a4 = 128,191,128,191  
                if c == 228 then a1 = 184  
                elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165  
                end  
                if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then  
                    k = k + 2  
                    table.insert(ss, string.char(c,c1,c2))  
                end  
            end  
        end  
    end  
    return table.concat(ss)  
end  


function sgoly_pack.checkup(end_point,beilv,k,cost)
    if end_point*beilv*k==tonumber(cost) then
        if (end_point=="1000"  or end_point=="3000" 
             or end_point=="5000") and 
        (beilv=="1" or beilv=="5" or beilv=="10"  or beilv=="3") and 
        (k=="1" or k=="10" or k=="30" or k=="20") then
        return true
        else
            return false
        end
    else
        return false
    end
end
return sgoly_pack