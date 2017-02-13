
--[[
 * @brief:		sgoly_union_query.lua

 * @author:		kun si
 * @email:	  	627795061@qq.com
 * @date:		2017-01-20
--]]

local query = {}
require "sgoly_query"

--!
--! @brief      查用户结算
--!
--! @param      nickname  用户名
--! @param      dt        日期
--!
--! @return     table     查询结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-21
--!
function query.get_statments_from_MySQL(nickname, dt)
	local sql = string.format(
		[[
			SELECT
				nickname,
				win,
				cost,
				times,
				win_times,
				single_max,
				conti_max,
				dmax.s_date
			FROM
				day_io AS dio
			LEFT JOIN day_times AS dti ON dio.uid = dti.uid
			AND dio.s_date = dti.s_date
			LEFT JOIN day_max AS dmax ON dti.uid = dmax.uid
			AND dti.s_date = dmax.s_date
			LEFT JOIN users AS u ON dmax.uid = u.id
			WHERE
				u.id = %d
			AND dmax.s_date = '%s';
		]], nickname, dt)
	local status = mysql_query(sql)
	if status.err then
		return false, status.err
	end
	
	return  true, status
end

--!
--! @brief      查用户结算统计
--!
--! @param      nickname  用户名
--! @param      dt        日期
--!
--! @return     table     查询结果
--!
--! @author     kun si, 627795061@qq.com
--! @date       2017-01-21
--!
function query.get_count_statements_from_MySQL(nickname, dt)
	local sql = string.format(
		[[
			SELECT
				sum(win) AS win,
				sum(cost) AS cost,
				sum(times) AS times,
				sum(win_times) AS win_times,
				max(single_max) AS single_max,
				max(conti_max) AS conti_max
			FROM
				day_io AS dio
			LEFT JOIN day_times AS dti ON dio.uid = dti.uid
			AND dio.s_date = dti.s_date
			AND dio.s_date < '%s'
			LEFT JOIN day_max AS dmax ON dti.uid = dmax.uid
			AND dti.s_date = dmax.s_date
			LEFT JOIN users AS u ON dmax.uid = u.id
			GROUP BY
				u.id
			HAVING
				u.id = %d;
		]], dt, nickname)

	local status = mysql_query(sql)
	if status.err then
		return false, status.err
	end
	
	return true, status
end

return query