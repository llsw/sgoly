--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是一个当日或得金币次数最大前n名用户的对应的奖励金额数据管理模块
 * @DateTime:    2017-01-16 17:54:11
 --]]

require "sgoly_query"
require "sgoly_printf"

 local max_times_award = {}

 --[[
 函数说明：
 		函数作用：插入当日或得金币次数最大前n名,应该获得奖励数额键值对
 		传入参数：id(主键, 名次), value(对应奖励金额)
 		返回参数：sql语句执行状态
 --]]
 function max_times_award.insert(id, value)
 	printD("max_times_award.insert(%d, %d)", id, value)
 	printI("max_times_award.insert(%d, %d)", id, value)
 	local sql = string.format("insert into sgoly.max_times_award value(%d, %d)",
 	 						   id, value)
 	return mysql_query(sql)
 end

  --[[
 函数说明：
 		函数作用：删除当日或得金币次数最大前n名,应该获得奖励数额键值对
 		传入参数：id(主键, 名次)
 		返回参数：sql语句执行状态
 --]]
 function max_times_award.delete(id)
 	printD("max_times_award.delete(%d)", id)
 	printI("max_times_award.delete(%d)", id)
 	local sql = string.format("delete from sgoly.max_times_award where id = %d ;",
 	 						   id)
 	return mysql_query(sql)
 end

 --[[
 函数说明：
 		函数作用：更改当日或得金币次数最大前n名,应该获得奖励数额键值对
 		传入参数：id(主键, 名次), value(对应奖励金额)
 		返回参数：sql语句执行状态
 --]]
 function max_times_award.update(id, value)
 	printD("max_times_award.update(%d, %d)", id, value)
 	printI("max_times_award.update(%d, %d)", id, value)
 	local sql = string.format("update sgoly.max_times_award set value = %d where"
 							   .." id = %d ;",value, id)
 	return mysql_query(sql)
 end

  --[[
 函数说明：
 		函数作用：获取当日或得金币次数最大前n名,应该获得奖励数额键值对
 		传入参数：id(主键, 名次)
 		返回参数：sql语句执行状态
 --]]
 function max_times_award.select(id)
 	printD("max_times_award.select(%d)", id)
 	printI("max_times_award.select(%d)", id)
 	local sql = string.format("select value from sgoly.max_times_award where id = %d ;"
 							   , id)
 	return mysql_query(sql)
 end

 return max_times_award