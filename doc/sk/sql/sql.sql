
#查询
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

###更新

UPDATE day_io,
 day_max
SET day_io.win = 6,
 day_max.single_max = 6
WHERE
	day_io.s_date = day_max.s_date
AND day_io.s_date = '2017-01-19'

UPDATE users AS u
LEFT JOIN day_io AS dio ON u.id = dio.uid
SET dio.win = % d,
 dio.cost = % d
WHERE
	u.nickname = % s
AND dio.s_date = % s;

UPDATE users AS u
LEFT JOIN day_io AS dio ON u.id = dio.uid
SET dio.win = 3,
 dio.cost = 4
WHERE
	u.nickname = 'interface'
AND dio.s_date = '2017-01-20';


###更新钱

UPDATE account AS acc
LEFT JOIN users AS u ON acc.id = u.id
SET acc.money = 100000
WHERE
	u.nickname = 'interface';


