
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
				win,
				cost,
				times,
				win_times,
				single_max,
				conti_max
			FROM
				users AS u
			LEFT JOIN (
				day_io AS dio
				LEFT JOIN (
					day_max AS dmax
					LEFT JOIN day_times AS dt ON dmax.uid = dt.uid
				) ON dio.uid = dmax.uid
			) ON u.id = dio.uid
			WHERE
				nickname = '%s'
			AND dio.s_date = '%s';
		]], nickname, dt)
	
	return mysql_query(sql)
end

return query