--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是一个当日获奖金币最大前n名的奖励数额数据管理模块
 * @DateTime:    2017-01-16 17:35:39
 --]]

require "sgoly_query"
require "sgoly_printf"

 local max_award = {}

 --[[
 函数说明：
 		函数作用：插入当日获得金币最大前n名的奖励数额键值对
 		传入参数：id(主键, 名次), value(对应奖励金额)
 		返回参数：sql语句执行状态
 --]]
 function max_award.insert(id, value)
 	printD("max_award.insert(%d, %d)", id, value)
 	printI("max_award.insert(%d, %d)", id, value)
 	local sql = string.format("insert into sgoly.max_award value(%d, %d)",
 	 						   id, value)
 	return mysql_query(sql)
 end

  --[[
 函数说明：
 		函数作用：删除当日获得金币最大前n名的奖励数额键值对
 		传入参数：id(主键, 名次)
 		返回参数：sql语句执行状态
 --]]
 function max_award.delete(id)
 	printD("max_award.delete(%d)", id)
 	printI("max_award.delete(%d)", id)
 	local sql = string.format("delete from sgoly.max_award where id = %d ;",
 	 						   id)
 	return mysql_query(sql)
 end

 --[[
 函数说明：
 		函数作用：更改当日获得金币最大前n名的奖励数额键值对
 		传入参数：id(主键, 名次), value(对应奖励金额)
 		返回参数：sql语句执行状态
 --]]
 function max_award.update(id, value)
 	printD("max_award.update(%d, %d)", id, value)
 	printI("max_award.update(%d, %d)", id, value)
 	local sql = string.format("update sgoly.max_award set value = %d where"
 							   .." id = %d ;",value, id)
 	return mysql_query(sql)
 end

  --[[
 函数说明：
 		函数作用：获取当日获得金币最大前n名的奖励数额金币数额
 		传入参数：id(主键, 名次)
 		返回参数：sql语句执行状态
 --]]
 function max_award.select(id)
 	printD("max_award.select(%d)", id)
 	printI("max_award.select(%d)", id)
 	local sql = string.format("select value sgoly.max_award where id = %d ;"
 							   , id)
 	return mysql_query(sql)
 end

 return max_award