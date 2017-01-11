--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是排名奖励金额数据获取模块
 * @DateTime:    2017-01-11 13:57:10
 --]]

require "sgoly_query"
require "sgoly_printf"

 local rank_award = {}

 --[[
 函数说明：
 		函数作用：获取前5名应获得的奖励金额
 		传入参数：表名字符串和名次数值
 		返回参数：应获得金额的数字
 --]]
 function rank_award.get(tableName, rank)
 	if((nil == tableName) or ("" == tableName)) then
 		return false, "空表名错误"
 	elseif((1 > rank) or (5 < rank)) then
 		return false, "排名范围错误"
 	else
 		local sql = string.format("select money from sgoly.'%s' where id = '%s'; "
 			,rank)
 		 local tmptable = mysql_query(sql)
 		if(1 == #tmptable) then
 			return true, tmptable[1].money
 		else
 			return false, "找不到数据"
 		end
 			
 end

 return rank_award