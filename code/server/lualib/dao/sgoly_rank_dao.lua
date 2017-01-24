
--[[
 * @brief:		sgoly_rank_dao.lua

 * @author:		kun si
 * @email:	  	627795061@qq.com
 * @date:		2017-01-24
--]]

local model = require "sgoly_rank"
local dao = {}

--!
--! @brief      保存排行榜到MySQL
--!
--!	@paaram		rank_type 	排行榜类型
--! @param      rank  		排行榜table
--! @param      args  		用户数据table
--! @param      date  		日期
--!
--! @return     bool, string		执行是否成功、查询结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-24
--!
function dao.save_rank_to_MySQL(rank_type, rank, args, date)
	local status = model.save_rank_to_MySQL(rank_type, rank, args, date)
	if status.err then
		return false, status.err
	end

	return true, status
end

--!
--! @brief      从MySQL中查询排行榜
--!
--! @param      rank_type  排行绑类型 "serialWinNum"或"winMoney"
--! @param      date       The date
--!
--! @return     bool, table		执行是否成功、查询结果
--! 
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-24
--!
function dao.get_rank_from_MySQL(rank_type, date)
	local status = model.get_rank_from_MySQL(rank_type, date)
	if status.err then
		return false, status.err
	end

	return true, status
end
return dao 