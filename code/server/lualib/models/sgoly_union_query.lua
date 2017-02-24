
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

function query.set_user_online(uid, addr, isOnline)
	local sql = string.format(
		[[
			UPDATE account
			SET account.online = %d,
			 account.ip = '%s'
			WHERE
				account.id = %d;
		]], isOnline, addr, uid)

	local status = mysql_query(sql)
	if status.err then
		return false, status.err
	end
	
	return true, status
end

function query.set_user_exit(uid)
	local sql = string.format(
		[[
			UPDATE account
			SET account.online = 0
			WHERE
				account.id = %d;
		]], uid)

	local status = mysql_query(sql)
	if status.err then
		return false, status.err
	end
	
	return true, status	
end

function query.saveProbabilityToMySQL(type, modle)
	for k, v in ipairs(modle) do
		local sql = string.format(
			[[
				INSERT INTO probability
				VALUES
					(%d, '%s', '%s') 
				ON DUPLICATE KEY UPDATE
					value = '%s';
			]], k, type, v, v)
		mysql_query(sql)
	end
end

function query.getProbabilityFromMySQL(type)
	local sql = string.format(
		[[
		SELECT
			sort,
			value
		FROM
			probability
		WHERE
			type = '%s';
		]], type)
	local status = mysql_query(sql)
	if status.err then
		return false, status.err
	end
	
	return true, status	
end

function query.setUserLoginTime(uid)
	local time = os.date("%Y-%m-%d %H:%M:%S")
	local sql = string.format(
	[[
		INSERT INTO login(`date`, `uid`, `login`)
		VALUES
			('%s', %d, '%s') 
		ON DUPLICATE KEY UPDATE
			login = '%s';
	]], os.date("%Y-%m-%d"), uid, time, time )

	local status = mysql_query(sql)

	if status.err then
		return false, status.err
	end
	
	return true, status	
	
end


function query.setUserLogoutTime(uid)
	local time = os.date("%Y-%m-%d %H:%M:%S")
	local sql = string.format(
	[[
		INSERT INTO login(`date`, `uid`, `logout`)
		VALUES
			('%s', %d, '%s') 
		ON DUPLICATE KEY UPDATE
			logout = '%s';
	]], os.date("%Y-%m-%d"), uid, time, time )

	local status = mysql_query(sql)

	if status.err then
		return false, status.err
	end
	
	return true, status	
end

return query