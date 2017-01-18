--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是一个检查sgoly_single_award模块的模块
 * @DateTime:    2017-01-17 11:01:08
 --]]

 require "sgoly_printf"
 local single_award = require "sgoly_single_award"

 local single_award_dao ={}

--[[
函数说明：
		函数作用：检查single_award.insert(id, value)函数,并调用执行
		传入参数：id(名次), value(奖励金额)
		返回参数：true or false 和相关消息
--]]
function single_award_dao.insert(id, value)
 	printD("single_award_dao.insert(%d, %d)", id, value)
 	printI("single_award_dao.insert(%d, %d)", id, value)
 	if(nil == id) then
 		return false, "名次空值错误"
 	elseif(nil == value) then
 		return false, "奖金值错误"
 	else
 		local status = single_award.insert(id, value)
 		if((0 == status.warning_count) and (1 == status.affected_rows)) then
			return true, "插入数据成功"
		else
			return false, status.err
		end
 	end
end

--[[
函数说明：
		函数作用：检查single_award.delete(id)函数,并调用执行
		传入参数：id(名次)
		返回参数：true or false 和相关消息
--]]
function single_award_dao.delete(id)
 	printD("single_award_dao.delete(%d)", id)
 	printI("single_award_dao.delete(%d)", id)
 	if(nil == id) then
 		return false, "名次空值错误"
 	else
 		local status = single_award.delete(id)
 		if((0 == status.warning_count) and (1 == status.affected_rows)) then
			return true, "删除数据成功"
		else
			return false, status.err
		end
 	end
end

--[[
函数说明：
		函数作用：检查single_award.update(id)函数,并调用执行
		传入参数：id(名次), value(奖励金额)
		返回参数：true or false 和相关消息
--]]
function single_award_dao.update(id, value)
 	printD("single_award_dao.update(%d, %d)", id, value)
 	printI("single_award_dao.update(%d, %d)", id, value)
 	if(nil == id) then
 		return false, "名次空值错误"
 	elseif(nil == value) then
 		return false, "奖金值错误"
 	else
 		local status = single_award.update(id, value)
 		if((0 == status.warning_count) and (1 == status.affected_rows)) then
			return true, "更改数据成功"
		else
			return false, status.err
		end
 	end
end

--[[
函数说明：
		函数作用：检查single_award.select(id)函数,并调用执行
		传入参数：id(名次)
		返回参数：true or false 和相关消息
--]]
function single_award_dao.select(id)
 	printD("single_award_dao.select(%d)", id)
 	printI("single_award_dao.select(%d)", id)
	if(nil == id) then
 		return false, "名次空值错误"
 	else
 		local status = single_award.select(id)
 		if(1 == #status) then
			return true, status[1].value
		else
			return false, status.err
		end
 	end
end

return single_award_dao
