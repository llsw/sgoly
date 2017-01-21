--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是一个管理用户当日获得金币次数和玩游戏次数据模块
 * @DateTime:    2017-01-16 18:08:41
 --]]

 require "sgoly_query"
require "sgoly_printf"

 local day_times = {}

 --[[
 函数说明：
 		函数作用：插入用户当日有关次数的数据
 		传入参数：uid(用户id), win_times(获得金币次数), times(玩游戏次数), dt(日期)
 		返回参数：sql语句执行状态
 --]]
 function day_times.insert(uid, win_times, times, dt)
 	printD("day_times.insert(%d, %d, %d, %s)", uid, win_times, times, dt)
 	printI("day_times.insert(%d, %d, %d, %s)", uid, win_times, times, dt)
 	local sql = string.format("insert into sgoly.day_times value(null, %d, %d, "
 		.."%d, '%s' );", uid, win_times, times, dt)
 	return mysql_query(sql)
 end

 --[[
 函数说明：
 		函数作用：更改用户当日获得金币次数
 		传入参数：uid(用户id), win_times(获得金币次数), dt(日期)
 		返回参数：sql语句执行状态
 --]]
 function day_times.update_win_times(uid, win_times, dt)
 	printD("day_times.update_win_times(%d, %d, %s)", uid, win_times, dt)
 	printI("day_times.update_win_times(%d, %d, %s)", uid, win_times, dt)
 	local sql = string.format("update sgoly.day_times set win_times = %d where "
 						.."uid = %d and dt = '%s' ;", win_times, uid, dt)
 	return mysql_query(sql)
 end

  --[[
 函数说明：
 		函数作用：更改用户当日玩游戏次数
 		传入参数：uid(用户id), times(玩游戏次数), dt(日期)
 		返回参数：sql语句执行状态
 --]]
 function day_times.update_times(uid, times, dt)
 	printD("day_times.update_times(%d, %d, %s)", uid, times, dt)
 	printI("day_times.update_times(%d, %d, %s)", uid, times, dt)
 	local sql = string.format("update sgoly.day_times set times = %d where "
 						.."uid = %d and dt = '%s' ;", times, uid, dt)
 	return mysql_query(sql)
 end

 --[[
 函数说明：
 		函数作用：查询用户当日获得金币次数和玩游戏次数数据
 		传入参数：uid(用户id), dt(日期)
 		返回参数：sql语句执行状态
 --]]
 function day_times.select(uid, dt)
 	printD("day_times.select(%d, %s)", uid, dt)
 	printI("day_times.select(%d, %s)", uid, dt)
 	local sql = string.format("select * from sgoly.day_times where uid = %d and "
 						.."dt ='%s' ;", uid, dt)
 	return mysql_query(sql)
 end

 --[[
 函数说明：
 		函数作用：查询用户当日获得金币次数
 		传入参数：uid(用户id), dt(日期)
 		返回参数：sql语句执行状态
 --]]
 function day_times.select_win_times(uid, dt)
 	printD("day_times.select_win_times(%d, %s)", uid, dt)
 	printI("day_times.select_win_times(%d, %s)", uid, dt)
 	local sql = string.format("select win_times from sgoly.day_times where uid "
 						.."= %d and dt ='%s' ;", uid, dt)
 	return mysql_query(sql)
 end

  --[[
 函数说明：
 		函数作用：查询用户当日玩游戏次数数据
 		传入参数：uid(用户id), dt(日期)
 		返回参数：sql语句执行状态
 --]]
 function day_times.select_times(uid, dt)
 	printD("day_times.select_times(%d, %s)", uid, dt)
 	printI("day_times.select_times(%d, %s)", uid, dt)
 	local sql = string.format("select times from sgoly.day_times where uid = %d "
 						.."and dt ='%s' ;", uid, dt)
 	return mysql_query(sql)
 end

 --!
 --! @brief      更新用户抽奖次数和中奖次数
 --!
 --! @param      nickname   用户名
 --! @param      times      抽奖次数
 --! @param      win_times  中奖次数
 --! @param      dt         日期
 --!
 --! @return     table		执行结果
 --!
 --! @author     kun si, 627795061@qq.com
 --! @date       2017-01-21
 --!
 function day_times.updateS(nickname, times, win_times, dt)
 	local sql = string.format(
 		[[
 			UPDATE users AS u
		  	LEFT JOIN day_times AS dti ON u.id = dti.uid
			SET dti.times = %d,
 				dti.win_times = %d
			WHERE
				u.nickname = '%s'
			AND dti.s_date = '%s';
		]],times, win_times, nickname, dt)
 	
 	return mysql_query(sql)
 end


 return day_times