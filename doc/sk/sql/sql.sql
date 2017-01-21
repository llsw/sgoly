###查连接状态
SHOW PROCESSLIST;

###联合查询
SELECT
	*
FROM
	users AS u
LEFT JOIN day_io AS dio ON u.id = dio.uid
AND dio.s_date < '2017-01-20'
LEFT JOIN day_max AS dmax ON dio.uid = dmax.uid
AND dio.s_date = dmax.s_date
LEFT JOIN day_times AS dt ON dmax.uid = dt.uid
AND dmax.s_date = dt.s_date

###统计结算
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
AND dio.s_date < '2017-01-21'
LEFT JOIN day_max AS dmax ON dti.uid = dmax.uid
AND dti.s_date = dmax.s_date
LEFT JOIN users AS u ON dmax.uid = u.id
GROUP BY
	nickname
HAVING
	nickname = 'interface';

###查询结算
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
	nickname = 'interface'
AND dmax.s_date = '2017-01-20';

###更新钱
UPDATE account AS acc
LEFT JOIN users AS u ON acc.id = u.id
SET acc.money = 100000
WHERE
	u.nickname = 'interface';

###更新 day_io.win, day_io.cost
UPDATE users AS u
LEFT JOIN day_io AS dio ON u.id = dio.uid
SET dio.win = 3,
 dio.cost = 4
WHERE
	u.nickname = 'interface'
AND dio.s_date = '2017-01-20';

###更新 day_max.single_max, day_max.conti_max
UPDATE users AS u
	LEFT JOIN day_max AS dmax ON u.id = dmax.uid
SET dmax.single_max = %d,
	dmax.conti_max = %d
WHERE
	u.nickname = '%s'
AND dmax.s_date = '%s';

###更新 day_times.times, day_times.win_times
UPDATE users AS u
	LEFT JOIN day_times AS dti ON u.id = dti.uid
SET dti.times = %d,
	dti.win_times = %d
WHERE
	u.nickname = '%s'
AND dti.s_date = '%s';




