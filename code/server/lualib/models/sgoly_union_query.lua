
--[[
 * @brief:		sgoly_union_query.lua

 * @author:		kun si
 * @email:	  	627795061@qq.com
 * @date:		2017-01-20
--]]

local query = {}
require "sgoly_query"

function query.get_statmens_from_MySQL(nickname, dt)
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
				dio.s_date
			FROM
				users AS u
			LEFT JOIN day_io AS dio ON u.id = dio.uid
			LEFT JOIN day_max AS dmax ON dio.uid = dmax.uid
			AND dio.s_date = dmax.s_date
			LEFT JOIN day_times AS dt ON dmax.uid = dt.uid
			AND dmax.s_date = dt.s_date
			WHERE
				nickname = '%d'
			AND dio.s_date = '%d'
		]], nickname, dt)
	
	return mysql_query(sql)
end

function query.get_count_statements_from_MySQL(nickname)
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
				users AS u
			LEFT JOIN day_io AS dio ON u.id = dio.uid
			LEFT JOIN day_max AS dmax ON dio.uid = dmax.uid
			AND dio.s_date = dmax.s_date
			LEFT JOIN day_times AS dt ON dmax.uid = dt.uid
			AND dmax.s_date = dt.s_date
			GROUP BY
				nickname
			HAVING
				nickname = '%s';
		]], nickname)
	
	return mysql_query(sql)
end

return query