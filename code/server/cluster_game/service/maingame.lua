require "skynet.manager"
local socket=require "socket"
local skynet=require "skynet"
local crypt 	= require "crypt"
local cluster   = require "cluster"
local sgoly_tool = require"sgoly_tool"
require "sgoly_printf"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
local CMD = {}
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))

function picture_order(picturetype)                       --图片序列函数
	local letter = string.sub(picturetype,1,1)
	local num = tonumber(string.sub(picturetype,2,2))
	if num == 5  then
		skynet.error("图片顺序为",letter:rep(num))
		local sequence = letter:rep(num)
		return sequence
	elseif num ==4 then
		local a = math.random(1,2)
		local b
		repeat
			b =string.char(math.random(65,70))
			until (letter~=b)
		if a==1 then
			skynet.error("图片顺序为",letter:rep(num) .. b)
			local sequence = letter:rep(num) .. b
			return sequence
		else 
			skynet.error("图片顺序为",b .. letter:rep(num))
			local sequence = b .. letter:rep(num)
		    return sequence
		end
	elseif num ==3 then
		local a = math.random(1,3)
		local b,c 
		repeat
			 b =string.char(math.random(65,70))
			 c =string.char(math.random(65,70))
		until (letter~=b and letter~=c)
		if a==1 then
			skynet.error("图片顺序为",letter:rep(num) .. b..c)
			local sequence = letter:rep(num).. b..c
		    return sequence
		elseif a==2 then
			skynet.error("图片顺序为",b .. letter:rep(num)..c)
			local sequence = b..letter:rep(num)..c
		    return sequence
		elseif a==3 then
			skynet.error("图片顺序为",b ..c.. letter:rep(num))
			local sequence = b..c..letter:rep(num)
		    return sequence
		end
	else
		local a,b,c,d,e
		repeat
		 a = string.char(math.random(65,70))
		 b = string.char(math.random(65,70))
		 c = string.char(math.random(65,70))
		 d = string.char(math.random(65,70))
		 e = string.char(math.random(65,70))
		until((a~=b and b~=c) and (b~=c and c~=d) and (c~=d and d~=e))
			skynet.error("图片顺序为",a..b..c..d..e)
			local sequence = a..b..c..d..e
		    return sequence
	end
end

function send_result(fd,session,SERIES,WCOUNT,MAXMONEY,SUNMONEY,FINMONEY,WINLIST,WMONEY)
	local who = "123456"
	local result={ID="4",STATE=true,SERIES=SERIES,WCOUNT=WCOUNT,
	       MAXMONEY=MAXMONEY,SUNMONEY=SUNMONEY,FINMONEY=FINMONEY,
	       WINLIST=WINLIST,WMONEY=WMONEY}
    local result1=cjson.encode(result)
    local result1_1=crypt.aesencode(result1,who,"")
    local result1_2 = crypt.base64encode(result1_1)
    return result1_2
end

	--记录中奖类型

 -- 	gamenum=0          --游戏次数
 -- 	gamenum8=0         --8次游戏次数
 -- 	money=0            --赚的金额
 -- 	money8=0		   --8次游戏金额
 -- 	moneydb=0          --赚得金额存数据库
	-- deposit=0          --消耗金额
	-- depositdb=0        --消耗金额存数据库
	-- historyj=0         --历史中奖次数
	-- n=1                --number1 的索引
 --    x = 1              --1 为普通模式 2为困难模式 3为简单模式	
	-- historynum=0       --历史抽奖次数
	-- winmoney={}        --中奖金额
--主循环判断
function gamemain(fd,session,end_point,beilv,k,MONEY,cost,name) 
    gamenum=0          --游戏次数
 	gamenum8=0         --8次游戏次数
 	money=0            --赚的金额
 	money8=0		   --8次游戏金额
 	moneydb=0          --赚得金额存数据库
	deposit=0          --消耗金额
	depositdb=0        --消耗金额存数据库
	historyj=0         --历史中奖次数
	n=1                --number1 的索引
    x = 1              --1 为普通模式 2为困难模式 3为简单模式	
	historynum=0       --历史抽奖次数
	winmoney={}        --中奖金额                        --end_point底分    beilv 倍率   k 次数
	skynet.error("zxxxxxx",MONEY,COST)
	historynum=historynum+k
	local j=0           --记录本轮中奖总次数
	local number1={}    --第几次中奖
	local number2={}	--第几次中的什么奖
	local wintype={A5=0,B5=0,C5=0,D5=0,E5=0,A4=0,B4=0,C4=0,D4=0,E4=0,A3=0,B3=0,C3=0,D3=0,E3=0}
	local sequence = {}	
for i=1,k do
	a=math.random(1,1000000)
	skynet.error("-----------------------------")
	-- --------------普通模式---------------------

	if x==1 then
		skynet.error("这是普通模式")
		if a>=1 and a<=4 then
			skynet.error(i,"中奖类型AAAAA----O(∩_∩)O~~-!")
			j=j+1
			wintype.A5=wintype.A5+1
			table.insert(number1,i)
			table.insert(number2,"A5")
			n=n+1
			table.insert(sequence,picture_order("A5"))
			skynet.error("得分为",end_point*beilv*100)
			money=money+end_point*beilv*100
			table.insert(winmoney,end_point*beilv*100)
		elseif a>=5 and a<=34 then
			skynet.error(i,"中奖类型BBBBB----O(∩_∩)O~~-!")
			j=j+1
			wintype.B5=wintype.B5+1
			table.insert(number1,i)
			table.insert(number2,"B5")
			n=n+1
			table.insert(sequence,picture_order("B5"))
			skynet.error("得分为",end_point*beilv*90) 
			money=money+end_point*beilv*90
			table.insert(winmoney,end_point*beilv*90)
		elseif a>=35 and a<=254 then
			skynet.error(i,"中奖类型CCCCC----O(∩_∩)O~~-!")
			j=j+1
			wintype.C5=wintype.C5+1
			table.insert(number1,i)
			table.insert(number2,"C5")
			n=n+1
			table.insert(sequence,picture_order("C5"))
			skynet.error("得分为",end_point*beilv*80) 
			money=money+end_point*beilv*80
			table.insert(winmoney,end_point*beilv*80)
		elseif a>=255 and a<=704 then
			skynet.error(i,"中奖类型DDDDD----O(∩_∩)O~~-!")
			j=j+1
			wintype.D5=wintype.D5+1
			table.insert(number1,i)
			table.insert(number2,"D5")
			n=n+1
			table.insert(sequence,picture_order("D5"))
			skynet.error("得分为",end_point*beilv*70) 
			money=money+end_point*beilv*70
			table.insert(winmoney,end_point*beilv*70)
		elseif a>=705 and a<=7174 then
			skynet.error(i,"中奖类型EEEEE----O(∩_∩)O~~-!")
			j=j+1
			wintype.E5=wintype.E5+1
			table.insert(number1,i)
			table.insert(number2,"E5")
			n=n+1
			table.insert(sequence,picture_order("E5"))
			skynet.error("得分为",end_point*beilv*60) 
			money=money+end_point*beilv*100
			table.insert(winmoney,end_point*beilv*100)
		elseif a>=7175 and a<=7254 then
			skynet.error(i,"中奖类型AAAA----O(∩_∩)O~~-!")
			j=j+1
			wintype.A4=wintype.A4+1
			table.insert(number1,i)
			table.insert(number2,"A4")
			n=n+1
			table.insert(sequence,picture_order("A4"))
			skynet.error("得分为",end_point*beilv*30) 
			money=money+end_point*beilv*30
			table.insert(winmoney,end_point*beilv*30)
		elseif a>=7255 and a<=7704 then
			skynet.error(i,"中奖类型BBBB----O(∩_∩)O~~-!")
			j=j+1
			wintype.B4=wintype.B4+1
			table.insert(number1,i)
			table.insert(number2,"B4")
			n=n+1
			table.insert(sequence,picture_order("B4"))
			skynet.error("得分为",end_point*beilv*25) 
			money=money+end_point*beilv*25
			table.insert(winmoney,end_point*beilv*25)
		elseif a>=7705 and a<=9564 then
			skynet.error(i,"中奖类型CCCC----O(∩_∩)O~~-!")
			j=j+1
			wintype.C4=wintype.C4+1
			table.insert(number1,i)
			table.insert(number2,"C4")
			n=n+1
			table.insert(sequence,picture_order("C4"))
			skynet.error("得分为",end_point*beilv*20) 
			money=money+end_point*beilv*20
			table.insert(winmoney,end_point*beilv*20)
		elseif a>=9565 and a<=12664 then
			skynet.error(i,"中奖类型DDDD----O(∩_∩)O~~-!")
			j=j+1
			wintype.D4=wintype.D4+1
			table.insert(number1,i)
			table.insert(number2,"D4")
			n=n+1
			table.insert(sequence,picture_order("D4"))
			skynet.error("得分为",end_point*beilv*15) 
			money=money+end_point*beilv*15
			table.insert(winmoney,end_point*beilv*15)
		elseif a>=12665 and a<=39854 then
			skynet.error(i,"中奖类型EEEE----O(∩_∩)O~~-!")
			j=j+1
			wintype.E4=wintype.E4+1
			table.insert(number1,i)
			table.insert(number2,"E4")
			n=n+1
			table.insert(sequence,picture_order("E4"))
			skynet.error("得分为",end_point*beilv*10) 
			money=money+end_point*beilv*10
			table.insert(winmoney,end_point*beilv*10)
		elseif a>=39855 and a<=41274 then
			skynet.error(i,"中奖类型AAA----O(∩_∩)O~~-!") 
			j=j+1
			wintype.A3=wintype.A3+1
			table.insert(number1,i)
			table.insert(number2,"A3")
			n=n+1
			table.insert(sequence,picture_order("A3"))
			skynet.error("得分为",end_point*beilv*5) 
			money=money+end_point*beilv*5
			table.insert(winmoney,end_point*beilv*5)
		elseif a>=41274 and a<=45224 then
			skynet.error(i,"中奖类型BBB----O(∩_∩)O~~-!") 
			j=j+1
			wintype.B3=wintype.B3+1
			table.insert(number1,i)
			table.insert(number2,"B3")
			n=n+1
			table.insert(sequence,picture_order("B3"))
			skynet.error("得分为",end_point*beilv*3) 
			money=money+end_point*beilv*3
			table.insert(winmoney,end_point*beilv*3)
		elseif a>=45225 and a<=57534 then
			skynet.error(i,"中奖类型CCC----O(∩_∩)O~~-!") 
			j=j+1
			wintype.C3=wintype.C3+1
			table.insert(number1,i)
			table.insert(number2,"C3")
			n=n+1
			table.insert(sequence,picture_order("C3"))
			skynet.error("得分为",end_point*beilv*1)
			money=money+end_point*beilv*1 
			table.insert(winmoney,end_point*beilv*1)
		elseif a>=57535 and a<=76744 then
			skynet.error(i,"中奖类型DDD----O(∩_∩)O~~-!") 
			j=j+1
			wintype.D3=wintype.D3+1
			table.insert(number1,i)
			table.insert(number2,"D3")
			n=n+1
			table.insert(sequence,picture_order("D3"))
			skynet.error("得分为",end_point*beilv*0.5)
			money=money+end_point*beilv*0.5
			table.insert(winmoney,end_point*beilv*0.5) 
		elseif a>=76745 and a<=148224 then
			skynet.error(i,"中奖类型EEE----O(∩_∩)O~~-!") 
			j=j+1
			wintype.E3=wintype.E3+1
			table.insert(number1,i)
			table.insert(number2,"E3")
			n=n+1
			table.insert(sequence,picture_order("E3"))
			skynet.error("得分为",end_point*beilv*0.3)
			money=money+end_point*beilv*0.3 
			table.insert(winmoney,end_point*beilv*0.3)
		else 
			skynet.error(i,"没有中奖")
			table.insert(sequence,picture_order("NO"))
			skynet.error("得分为",end_point*beilv*0) 
			money=money+end_point*beilv*0
			table.insert(winmoney,end_point*beilv*0)
		end

---------------------困难模式-----------------------	

	elseif  x==2   then
		skynet.error("这是困难模式")
		if a>=1 and a<=30 then
			skynet.error(i,"中奖类型AAAAA----O(∩_∩)O~~-!")
			j=j+1
			wintype.A5=wintype.A5+1
			table.insert(number1,i)
			table.insert(number2,"A5")
			n=n+1
			table.insert(sequence,picture_order("A5"))
			skynet.error("得分为",end_point*beilv*100)
			money=money+end_point*beilv*100
			table.insert(winmoney,end_point*beilv*100) 
		elseif a>=31 and a<=80 then
			skynet.error(i,"中奖类型BBBBB----O(∩_∩)O~~-!")
			j=j+1
			wintype.B5=wintype.B5+1
			table.insert(number1,i)
			table.insert(number2,"B5")
			n=n+1
			table.insert(sequence,picture_order("B5"))
			skynet.error("得分为",end_point*beilv*90)
			money=money+end_point*beilv*90 
			table.insert(winmoney,end_point*beilv*90)
		elseif a>=81 and a<=230 then
			skynet.error(i,"中奖类型CCCCC----O(∩_∩)O~~-!")
			j=j+1
			wintype.C5=wintype.C5+1
			table.insert(number1,i)
			table.insert(number2,"C5")
			n=n+1
			table.insert(sequence,picture_order("C5"))
			skynet.error("得分为",end_point*beilv*80)
			money=money+end_point*beilv*80
			table.insert(winmoney,end_point*beilv*80) 
		elseif a>=231 and a<=460 then
			skynet.error(i,"中奖类型DDDDD----O(∩_∩)O~~-!")
			j=j+1
			wintype.D5=wintype.D5+1
			table.insert(number1,i)
			table.insert(number2,"D5")
			n=n+1
			table.insert(sequence,picture_order("D5"))
			skynet.error("得分为",end_point*beilv*70) 
			money=money+end_point*beilv*70
			table.insert(winmoney,end_point*beilv*70)
		elseif a>=461 and a<=6820 then
			skynet.error(i,"中奖类型EEEEE----O(∩_∩)O~~-!")
			j=j+1
			wintype.E5=wintype.E5+1
			table.insert(number1,i)
			table.insert(number2,"E5")
			n=n+1
			table.insert(sequence,picture_order("E5"))
			skynet.error("得分为",end_point*beilv*60)
			money=money+end_point*beilv*60 
			table.insert(winmoney,end_point*beilv*60)
		elseif a>=6821 and a<=7011 then
			skynet.error(i,"中奖类型AAAA----O(∩_∩)O~~-!")
			j=j+1
			wintype.A4=wintype.A4+1
			table.insert(number1,i)
			table.insert(number2,"A4")
			n=n+1
			table.insert(sequence,picture_order("A4"))
			skynet.error("得分为",end_point*beilv*30)
			money=money+end_point*beilv*30 
			table.insert(winmoney,end_point*beilv*30)
		elseif a>=7012 and a<=7851 then
			skynet.error(i,"中奖类型BBBB----O(∩_∩)O~~-!")
			j=j+1
			wintype.B4=wintype.B4+1
			table.insert(number1,i)
			table.insert(number2,"B4")
			n=n+1
			table.insert(sequence,picture_order("B4"))
			skynet.error("得分为",end_point*beilv*25)
			money=money+end_point*beilv*25 
			table.insert(winmoney,end_point*beilv*25)
		elseif a>=7852 and a<=9451 then
			skynet.error(i,"中奖类型CCCC----O(∩_∩)O~~-!")
			j=j+1
			wintype.C4=wintype.C4+1
			table.insert(number1,i)
			table.insert(number2,"C4")
			n=n+1
			table.insert(sequence,picture_order("C4"))
			skynet.error("得分为",end_point*beilv*20)
			money=money+end_point*beilv*20 
			table.insert(winmoney,end_point*beilv*20)
		elseif a>=9452 and a<=11361 then
			skynet.error(i,"中奖类型DDDD----O(∩_∩)O~~-!")
			j=j+1
			wintype.D4=wintype.D4+1
			table.insert(number1,i)
			table.insert(number2,"D4")
			n=n+1
			table.insert(sequence,picture_order("D4"))
			skynet.error("得分为",end_point*beilv*15)
			money=money+end_point*beilv*15 
			table.insert(winmoney,end_point*beilv*15)
		elseif a>=11362 and a<=34571 then
			skynet.error(i,"中奖类型EEEE----O(∩_∩)O~~-!")
			j=j+1
			wintype.E4=wintype.E4+1
			table.insert(number1,i)
			table.insert(number2,"E4")
			n=n+1
			table.insert(sequence,picture_order("E4"))
			skynet.error("得分为",end_point*beilv*10) 
			money=money+end_point*beilv*10
			table.insert(winmoney,end_point*beilv*10)
		elseif a>=34572 and a<=37511 then
			skynet.error(i,"中奖类型AAA----O(∩_∩)O~~-!") 
			j=j+1
			wintype.A3=wintype.A3+1
			table.insert(number1,i)
			table.insert(number2,"A3")
			n=n+1
			table.insert(sequence,picture_order("A3"))
			skynet.error("得分为",end_point*beilv*5)
			money=money+end_point*beilv*5 
			table.insert(winmoney,end_point*beilv*5)
		elseif a>=37512 and a<=45061 then
			skynet.error(i,"中奖类型BBB----O(∩_∩)O~~-!") 
			j=j+1
			wintype.B3=wintype.B3+1
			table.insert(number1,i)
			table.insert(number2,"B3")
			n=n+1
			table.insert(sequence,picture_order("B3"))
			skynet.error("得分为",end_point*beilv*3)
			money=money+end_point*beilv*3
			table.insert(winmoney,end_point*beilv*3) 
		elseif a>=45062 and a<=56151 then
			skynet.error(i,"中奖类型CCC----O(∩_∩)O~~-!") 
			j=j+1
			wintype.C3=wintype.C3+1
			table.insert(number1,i)
			table.insert(number2,"C3")
			n=n+1
			table.insert(sequence,picture_order("C3"))
			skynet.error("得分为",end_point*beilv*1)
			money=money+end_point*beilv*1
			table.insert(winmoney,end_point*beilv*1) 
		elseif a>=56152 and a<=67981 then
			skynet.error(i,"中奖类型DDD----O(∩_∩)O~~-!") 
			j=j+1
			wintype.D3=wintype.D3+1
			table.insert(number1,i)
			table.insert(number2,"D3")
			n=n+1
			table.insert(sequence,picture_order("D3"))
			skynet.error("得分为",end_point*beilv*0.5)
			money=money+end_point*beilv*0.5 
			table.insert(winmoney,end_point*beilv*0.5)
		elseif a>=67982 and a<=131571 then
			skynet.error(i,"中奖类型EEE----O(∩_∩)O~~-!") 
			j=j+1
			wintype.E3=wintype.E3+1
			table.insert(number1,i)
			table.insert(number2,"E3")
			n=n+1
			table.insert(sequence,picture_order("E3"))
			skynet.error("得分为",end_point*beilv*0.3)
			money=money+end_point*beilv*0.3 
			table.insert(winmoney,end_point*beilv*0.3)
		else 
			skynet.error(i,"没有中奖")
			table.insert(sequence,picture_order("NO"))
			skynet.error("得分为",end_point*beilv*0)
			money=money+end_point*beilv*0
			table.insert(winmoney,end_point*beilv*0) 
		end
------------------------简单模式-----------------------------
	elseif x==3 then 
		skynet.error("这是简单模式")
		if a>=1 and a<=10 then
			skynet.error(i,"中奖类型AAAAA----O(∩_∩)O~~-!")
			j=j+1
			wintype.A5=wintype.A5+1
			table.insert(number1,i)
			table.insert(number2,"A5")
			n=n+1
			table.insert(sequence,picture_order("A5"))
			skynet.error("得分为",end_point*beilv*100) 
			money=money+end_point*beilv*100
			table.insert(winmoney,end_point*beilv*100)
		elseif a>=11 and a<=40 then
			skynet.error(i,"中奖类型BBBBB----O(∩_∩)O~~-!")
			j=j+1
			wintype.B5=wintype.B5+1
			table.insert(number1,i)
			table.insert(number2,"B5")
			n=n+1
			table.insert(sequence,picture_order("B5"))
			skynet.error("得分为",end_point*beilv*90) 
			money=money+end_point*beilv*90
			table.insert(winmoney,end_point*beilv*90)
		elseif a>=41 and a<=90 then
			skynet.error(i,"中奖类型CCCCC----O(∩_∩)O~~-!")
			j=j+1
			wintype.C5=wintype.C5+1
			table.insert(number1,i)
			table.insert(number2,"C5")
			n=n+1
			table.insert(sequence,picture_order("C5"))
			skynet.error("得分为",end_point*beilv*80)
			money=money+end_point*beilv*80 
			table.insert(winmoney,end_point*beilv*80)
		elseif a>=91 and a<=1450 then
			skynet.error(i,"中奖类型DDDDD----O(∩_∩)O~~-!")
			j=j+1
			wintype.D5=wintype.D5+1
			table.insert(number1,i)
			table.insert(number2,"D5")
			n=n+1
			table.insert(sequence,picture_order("D5"))
			skynet.error("得分为",end_point*beilv*70)
			money=money+end_point*beilv*70 
			table.insert(winmoney,end_point*beilv*70)
		elseif a>=1451 and a<=7130 then
			skynet.error(i,"中奖类型EEEEE----O(∩_∩)O~~-!")
			j=j+1
			wintype.E5=wintype.E5+1
			table.insert(number1,i)
			table.insert(number2,"E5")
			n=n+1
			table.insert(sequence,picture_order("E5"))
			skynet.error("得分为",end_point*beilv*60)
			money=money+end_point*beilv*60 
			table.insert(winmoney,end_point*beilv*60)
		elseif a>=7131 and a<=7260 then
			skynet.error(i,"中奖类型AAAA----O(∩_∩)O~~-!")
			j=j+1
			wintype.A4=wintype.A4+1
			table.insert(number1,i)
			table.insert(number2,"A4")
			n=n+1
			table.insert(sequence,picture_order("A4"))
			skynet.error("得分为",end_point*beilv*30) 
			money=money+end_point*beilv*30
			table.insert(winmoney,end_point*beilv*30)
		elseif a>=7261 and a<=7610 then
			skynet.error(i,"中奖类型BBBB----O(∩_∩)O~~-!")
			j=j+1
			wintype.B4=wintype.B4+1
			table.insert(number1,i)
			table.insert(number2,"B4")
			n=n+1
			table.insert(sequence,picture_order("B4"))
			skynet.error("得分为",end_point*beilv*25)
			money=money+end_point*beilv*25
			table.insert(winmoney,end_point*beilv*25) 
		elseif a>=7611 and a<=8060 then
			skynet.error(i,"中奖类型CCCC----O(∩_∩)O~~-!")
			j=j+1
			wintype.C4=wintype.C4+1
			table.insert(number1,i)
			table.insert(number2,"C4")
			n=n+1
			table.insert(sequence,picture_order("C4"))
			skynet.error("得分为",end_point*beilv*20)
			money=money+end_point*beilv*20
			table.insert(winmoney,end_point*beilv*20) 
		elseif a>=8061 and a<=13970 then
			skynet.error(i,"中奖类型DDDD----O(∩_∩)O~~-!")
			j=j+1
			wintype.D4=wintype.D4+1
			table.insert(number1,i)
			table.insert(number2,"D4")
			n=n+1
			table.insert(sequence,picture_order("D4"))
			skynet.error("得分为",end_point*beilv*15)
			money=money+end_point*beilv*15 
			table.insert(winmoney,end_point*beilv*15)
		elseif a>=13971 and a<=44270 then
			skynet.error(i,"中奖类型EEEE----O(∩_∩)O~~-!")
			j=j+1
			wintype.E4=wintype.E4+1
			table.insert(number1,i)
			table.insert(number2,"E4")
			n=n+1
			table.insert(sequence,picture_order("E4"))
			skynet.error("得分为",end_point*beilv*10)
			money=money+end_point*beilv*10 
			table.insert(winmoney,end_point*beilv*10)
		elseif a>=44271 and a<=46230 then
			skynet.error(i,"中奖类型AAA----O(∩_∩)O~~-!") 
			j=j+1
			wintype.A3=wintype.A3+1
			table.insert(number1,i)
			table.insert(number2,"A3")
			n=n+1
			table.insert(sequence,picture_order("A3"))
			skynet.error("得分为",end_point*beilv*5)
			money=money+end_point*beilv*5 
			table.insert(winmoney,end_point*beilv*5)
		elseif a>=46231 and a<=49780 then
			skynet.error(i,"中奖类型BBB----O(∩_∩)O~~-!") 
			j=j+1
			wintype.B3=wintype.B3+1
			table.insert(number1,i)
			table.insert(number2,"B3")
			n=n+1
			table.insert(sequence,picture_order("B3"))
			skynet.error("得分为",end_point*beilv*3)
			money=money+end_point*beilv*3
			table.insert(winmoney,end_point*beilv*3) 
		elseif a>=49781 and a<=54070 then
			skynet.error(i,"中奖类型CCC----O(∩_∩)O~~-!") 
			j=j+1
			wintype.C3=wintype.C3+1
			table.insert(number1,i)
			table.insert(number2,"C3")
			n=n+1
			table.insert(sequence,picture_order("C3"))
			skynet.error("得分为",end_point*beilv*1) 
			money=money+end_point*beilv*1
			table.insert(winmoney,end_point*beilv*1)
		elseif a>=54071 and a<=82930 then
			skynet.error(i,"中奖类型DDD----O(∩_∩)O~~-!") 
			j=j+1
			wintype.D3=wintype.D3+1
			table.insert(number1,i)
			table.insert(number2,"D3")
			n=n+1
			table.insert(sequence,picture_order("D3"))
			skynet.error("得分为",end_point*beilv*0.5)
			money=money+end_point*beilv*0.5 
			table.insert(winmoney,end_point*beilv*0.5)
		elseif a>=82931 and a<=162480 then
			skynet.error(i,"中奖类型EEE----O(∩_∩)O~~-!") 
			j=j+1
			wintype.E3=wintype.E3+1
			table.insert(number1,i)
			table.insert(number2,"E3")
			n=n+1
			table.insert(sequence,picture_order("E3"))
			skynet.error("得分为",end_point*beilv*0.3) 
			money=money+end_point*beilv*0.3
			table.insert(winmoney,end_point*beilv*0.3)
		else 
			skynet.error(i,"没有中奖")
			table.insert(sequence,picture_order("NO"))
			skynet.error("得分为",end_point*beilv*0)
			money=money+end_point*beilv*0 
			table.insert(winmoney,end_point*beilv*0)
		end
	end
---------------------10次判断切换模式---------------------------
	gamenum=gamenum+1
	moneydb=moneydb+money
	deposit=deposit+end_point*beilv
	if gamenum%10==0 and money/deposit>=0.9 then
		x=2           
		skynet.error("2 money/depost=",money,deposit,money/deposit)
		money=0
		deposit=0
	elseif gamenum%10==0 and money/deposit<=0.8 then
		x=3
		skynet.error("3 money/depost=",money,deposit,money/deposit)
		money=0 
		deposit=0
	elseif gamenum%10==0 and money/deposit>0.8 and money/deposit<0.9 then
		x=1
		skynet.error("2 money/depost=",money,deposit,money/deposit)
		money=0
		deposit=0
	end
-----------------------	8次判断切换模式------------------------------
 --    gamenum8=gamenum8+1
	-- money8=money8+money
	-- if money8~=0 then
	-- 	gamenum8=0
	-- end
	-- if gamenum%8==0 and money8==0 then
	-- 	x=4          
	-- end
end  --for 循环end
-----------------------抽奖次数--------------------------
	historyj=historyj+j
	skynet.error("本轮抽奖次数",k)
	skynet.error("历史抽奖次数",historynum)
	skynet.error("历史中奖次数",historyj)
	skynet.error("本轮中奖次数",j)
	for key,v in pairs(wintype) do
		if v~=0  then
			skynet.error("中奖类型为",key,"中奖次数为",v) 
		end
	end
------------------最高连续中奖次数-----------------------------	 
	persentmax=1    --记录最高连续中奖次数
	if  not number1[1] then
		skynet.error("最高连续中奖次数为",0)
	else
		max=1  --最终最高连续中奖次数
		for key,v in ipairs(number1) do 
				if v+1==number1[key+1] then
					persentmax=persentmax+1

				else
						if max<persentmax then
						   max=persentmax
						end
						persentmax=1
				end
		end
		skynet.error("最高连续中奖次数为",max)
	end
----------------------------------------------------------
		for key,v in ipairs(number1) do
			skynet.error("第",v,"次中奖","中奖类型为",number2[key])
		end
---------------------最高连续不中奖次数-----------------------
	if not number1[1] then
			skynet.error("最高连续不中奖次数为0")
	else
		local max = number1[1]
		for key,v in ipairs(number1) do
			if number1[key+1]~=nil then
				 if max<number1[key+1]-v then
			 	    max=number1[key+1]-v
			 	    startnum=v
			 	    endnum=number1[key+1]
			 	 end
			end
			if max==number1[1] then
				startnum=1
				endnum=number1[1]
			end
		end
		if  max>0 then
			skynet.error("最高连续不中奖次数为",max-1,"第",startnum,"-",endnum,"次")
		end
	end
----------------------中奖最高金额---------------
	local winmax =0
	for k,v in ipairs(winmoney) do
	     if v>winmax then 
	     	winmax=v
	     end
	end      
----------------------获奖总金额------------------
    local winall =0
    for k,v in ipairs(winmoney) do
    	 winall=winall+v
    end
    local nowMONEY=MONEY+winall
    --sgoly_tool.saveStatementsToRedis()
	return send_result(fd,session,max,j,winmax,winall,nowMONEY,sequence,winmoney)
end

function CMD.calc(fd,session,end_point,beilv,k,MONEY,cost,name)
	 return gamemain(fd,session,end_point,beilv,k,MONEY,cost,name)
end
-- gamemain(1,10,10,5)
-- gamemain(1,10,10,10)
-- gamemain(1,10,10,20)
skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
	--skynet.error("this is maingame")
    -- 要注册个服务的名字，以.开头
    --skynet.register(".maingame")
end)
