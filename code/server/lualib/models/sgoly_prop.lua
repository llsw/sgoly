--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is a prop model
 * @DateTime:    2017-02-22 09:12:10
--]]

require "sgoly_query"

local prop = {}

-- func  : insert
-- argv  : uid(user id), type(the type of prop), value(the value of type prop)
-- return: (true, true_msg) or (false, err_msg)
function prop.insert(uid, type, value)
  local sql = string.format("insert ignore into prop value(%d, %d, %d);", uid, type, value)
  local status = mysql_query(sql)
  if(0 == status.warning_count) then
    return true, "插入成功"
  else
    return false, "插入失败"
  end
end

-- func : delete
-- argv : uid(user id), type(prop type)
-- return: (true, true_msg) or (false, err_msg)
function prop.delete(uid, type)
  local sql = string.format("delete from prop where uid = %d and type = %d;", uid, type)
  local status = mysql_query(sql)
  if(0 == status.warning_count) then
    return true, "删除成功"
  else
    return false, "删除失败"
  end
end

-- func : update
-- argv : uid(user id), type(prop type), value(the value of type prop)
-- return: (true, true_msg) or (false, err_msg)
function prop.update(uid, type, value)
  local sql = string.format("update prop set value = %d where uid = %d and type = %d;", value, uid, type)
  local status = mysql_query(sql)
  if(0 == status.warning_count) then
    return true, "更新成功"
  else
    return false, "更新失败"
  end
end

-- func : select
-- argv : uid(user id)
-- return: (true, value) or (false, err_msg)
function prop.select(uid)
  local sql = string.format("select type,value from prop where uid = %d;", uid)
  local status = mysql_query(sql)
  local res = {}
  if(1 <= #status) then
    for k, v in pairs(status)  do
      res[v.type] = v.value
    end
    return true, res
  else
    return false, res
  end
end

return prop

