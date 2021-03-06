--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 这是一个记录用户当日收支情况的数据管理模块
 * @DateTime:    2017-01-16 18:02:33
 --]]

require "sgoly_query"
require "sgoly_printf"

 local day_io = {}

 --[[
 函数说明：
 		函数作用：插入用户当日收支情况的数据
 		传入参数：uid(用户id), win(收入), cost(支出), dt(日期)
 		返回参数：sql语句执行状态
 --]]
 function day_io.insert(uid, win, cost, dt)
 	local sql = string.format("insert into sgoly.day_io value(null, %d, %d, "
 		.."%d, '%s' );", uid, win, cost, dt)
 	return mysql_query(sql)
 end

 --[[
 函数说明：
 		函数作用：更改用户当日收入数据
 		传入参数：uid(用户id), win(收入), dt(日期)
 		返回参数：sql语句执行状态
 --]]
 function day_io.update_win(uid, win, dt)
 	local sql = string.format("update sgoly.day_io set win = %d where uid = %d and dt ="
 						.." '%s' ;", win, uid, dt)
 	return mysql_query(sql)
 end

  --[[
 函数说明：
 		函数作用：更改用户当日支出数据
 		传入参数：uid(用户id), cost(支出), dt(日期)
 		返回参数：sql语句执行状态
 --]]
 function day_io.update_cost(uid, cost, dt)
 	local sql = string.format("")
 	local sql = string.format("update sgoly.day_io set cost = %d where uid = %d and dt ="
 						.." '%s' ;", cost, uid, dt)
 	return mysql_query(sql)
 end

 --[[
 函数说明：
 		函数作用：查询用户当日收支情况数据
 		传入参数：uid(用户id), dt(日期)
 		返回参数：sql语句执行状态
 --]]
 function day_io.select(uid, dt)
 	local sql = string.format("select * from sgoly.day_io where uid = %d and "
 						.."dt ='%s' ;", uid, dt)
 	return mysql_query(sql)
 end

 --[[
 函数说明：
 		函数作用：查询用户当日收入情况数据
 		传入参数：uid(用户id), dt(日期)
 		返回参数：sql语句执行状态
 --]]
 function day_io.select_win(uid, dt)
 	local sql = string.format("select win from sgoly.day_io where uid = %d and "
 						.."dt ='%s' ;", uid, dt)
 	return mysql_query(sql)
 end

  --[[
 函数说明：
 		函数作用：查询用户当日支出情况数据
 		传入参数：uid(用户id), dt(日期)
 		返回参数：sql语句执行状态
 --]]
 function day_io.select_cost(uid, dt)
 	local sql = string.format("select cost from sgoly.day_io where uid = %d and "
 						.."dt ='%s' ;", uid, dt)
 	return mysql_query(sql)
 end

 --!
 --! @brief      更新当天用户中将金币
 --!
 --! @param      nickname  用户名
 --! @param      win       中奖金额
 --! @param      cost      消耗金额
 --! @param      dt        日期
 --!
 --! @return     table		执行结果
 --!
 --! @author     kun si, 627795061@qq.com
 --! @date       2017-01-21
 --!
 function day_io.updateS(nickname, win, cost, dt)
 	local sql = string.format(
 		[[
 			UPDATE users AS u
		  	LEFT JOIN day_io AS dio ON u.id = dio.uid
			SET dio.win = %d,
 				dio.cost = %d
			WHERE
				u.nickname = '%s'
			AND dio.s_date = '%s';
		]],win, cost, nickname, dt)
 	
 	return mysql_query(sql)
 end

 return day_io