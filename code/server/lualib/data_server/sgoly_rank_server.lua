
--[[
 * @brief:		sgoly_rank_server.lua

 * @author:		kun si
 * @email:	  	627795061@qq.com
 * @date:		2017-01-24
--]]

local dao = require "sgoly_rank_dao"
local server = {}

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
function server.save_rank_to_MySQL(rank_type, rank, args, date)
	if not rank_type or not rank or not args or not date then
		return false, "Sgoly_rank_server.save_rank_to_MySQL args nil"
	end
	return dao.save_rank_to_MySQL(rank_type, rank, args, date)
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
function server.get_rank_from_MySQL(rank_type, date)
	if not rank_type or not date then
		return false, "Sgoly_rank_server.get_rank_from_MySQL args nil"
	end
	return dao.get_rank_from_MySQL(rank_type, date)
end

return server