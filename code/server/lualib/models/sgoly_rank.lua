
--[[
 * @brief:		sgoly_rank.lua

 * @author:		kun si
 * @email:	  	627795061@qq.com
 * @date:		2017-01-24
--]]

require "sgoly_query"
local skynet = require "skynet"
local model = {}

--!
--! @brief      保存排行榜到MySQL
--!
--!	@paaram		rank_type 	排行榜类型
--! @param      rank  		排行榜table
--! @param      args  		用户数据table
--! @param      date  		日期
--!
--! @return     table 		查询结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-24
--!
function model.save_rank_to_MySQL(rank_type, rank, args, date)
	skynet.error("date", date)
	-- local sql = 
	-- string.format(
	-- 	[[
	-- 		INSERT INTO rank 
	-- 			(type, rank, nickname, value, award, date)
	-- 		VALUES
	-- 			('%s',	%d,	'%s', %d, %d, '%s'),
	-- 			('%s',	%d,	'%s', %d, %d, '%s'),
	-- 			('%s',	%d,	'%s', %d, %d, '%s'),
	-- 			('%s',	%d,	'%s', %d, %d, '%s'),
	-- 			('%s',	%d,	'%s', %d, %d, '%s'),
	-- 			('%s',	%d,	'%s', %d, %d, '%s'),
	-- 			('%s',	%d,	'%s', %d, %d, '%s'),
	-- 			('%s',	%d,	'%s', %d, %d, '%s'),
	-- 			('%s',	%d,	'%s', %d, %d, '%s'),
	-- 			('%s',	%d,	'%s', %d, %d, '%s');
	-- 	]],	
	-- 	rank_type, 1, rank[1], args[rank[1]][1], 0, date,
	-- 	rank_type, 2, rank[2], args[rank[2]][1], 0, date,
	-- 	rank_type, 3, rank[3], args[rank[3]][1], 0, date,
	-- 	rank_type, 4, rank[4], args[rank[4]][1], 0, date,
	-- 	rank_type, 5, rank[5], args[rank[5]][1], 0, date,
	-- 	rank_type, 6, rank[6], args[rank[6]][1], 0, date,
	-- 	rank_type, 7, rank[7], args[rank[7]][1], 0, date,
	-- 	rank_type, 8, rank[8], args[rank[8]][1], 0, date,
	-- 	rank_type, 9, rank[9], args[rank[9]][1], 0, date,
	-- 	rank_type, 10, rank[10], args[rank[10]][1], 0, date
	-- 	)
	local sql = [[
			INSERT INTO rank 
				(type, rank, nickname, value, award, date)
			VALUES
				]]
	for i=1, #rank do
		if i == #rank then
			sql = sql .. "('" .. rank_type ..  "', " .. i ..  ", " .. "'" .. rank[i] .. "', "  .. args[rank[i]][1] .. ","  .. 0 .. ", '" .. date .. "');"

		else
			sql = sql .. "('" .. rank_type ..  "', " .. i ..  ", " .. "'" .. rank[i] .. "', "  .. args[rank[i]][1] .. ","  .. 0 .. ", '" .. date .. "'),"
		end
		
	end
	return mysql_query(sql)
end 

--!
--! @brief      从MySQL中查询排行榜
--!
--! @param      rank_type  排行绑类型 "serialWinNum"或"winMoney"
--! @param      date       The date
--!
--! @return     table		执行是否成功、查询结果
--! 
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-24
--!
function model.get_rank_from_MySQL(rank_type, date)
	local sql = 
	string.format(
		[[
			SELECT
				rank, nickname, value, award
			FROM
				rank
			WHERE
				type = '%s'
			AND date = '%s'
			ORDER BY
				rank ASC;
		]],
		rank_type,
		date 
		)
	
	return mysql_query(sql)
end

--!
--! @brief      Gets the money rank.
--!
--! @return     The money rank.
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-02-10
--!
function model.get_money_rank_from_MySQL()
	local sql = string.format(
		[[
			SELECT
				nickname,
				money,
				update_time
			FROM
				users,
				account
			WHERE
				users.id = account.id
			ORDER BY
				money DESC,
				update_time ASC
			LIMIT 10;

		]]
		)
	return true, mysql_query(sql)
	
end

return model
