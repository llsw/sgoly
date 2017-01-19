--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是一个当日单次获奖最大前n名应该奖励金额数据管理模块
 * @DateTime:    2017-01-16 17:16:07
 --]]

require "sgoly_query"
require "sgoly_printf"

 local single_award = {}

 --[[
 函数说明：
 		函数作用：插入单次获奖金额名次对应应获奖金币金额键值对
 		传入参数：id(主键, 名次), value(对应奖励金额)
 		返回参数：sql语句执行状态
 --]]
 function single_award.insert(id, value)
 	printD("single_award.insert(%d, %d)", id, value)
 	printI("single_award.insert(%d, %d)", id, value)
 	local sql = string.format("insert into sgoly.single_award value(%d, %d)",
 	 						   id, value)
 	return mysql_query(sql)
 end

  --[[
 函数说明：
 		函数作用：删除单次获奖金额名次对应应获奖金币金额键值对
 		传入参数：id(主键, 名次)
 		返回参数：sql语句执行状态
 --]]
 function single_award.delete(id)
 	printD("single_award.delete(%d)", id)
 	printI("single_award.delete(%d)", id)
 	local sql = string.format("delete from sgoly.single_award where id = %d ;",
 	 						   id)
 	return mysql_query(sql)
 end

 --[[
 函数说明：
 		函数作用：更改单次获奖金额名次对应应获奖金币金额键值对
 		传入参数：id(主键, 名次), value(对应奖励金额)
 		返回参数：sql语句执行状态
 --]]
 function single_award.update(id, value)
 	printD("single_award.update(%d, %d)", id, value)
 	printI("single_award.update(%d, %d)", id, value)
 	local sql = string.format("update sgoly.single_award set value = %d where"
 							   .." id = %d ;",value, id)
 	return mysql_query(sql)
 end

  --[[
 函数说明：
 		函数作用：获取当日单次对应名次应获得的金币数额
 		传入参数：id(主键, 名次)
 		返回参数：sql语句执行状态
 --]]
 function single_award.select(id)
 	printD("single_award.select(%d)", id)
 	printI("single_award.select(%d)", id)
 	local sql = string.format("select value sgoly.single_award where id = %d ;"
 							   , id)
 	return mysql_query(sql)
 end

 return single_award