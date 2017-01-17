require "skynet.manager"
local socket=require "socket"
local skynet=require "skynet"
local crypt 	= require "crypt"
local cluster   = require "cluster"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
local CMD = {}
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))

function picture_order(picturetype)                       --图片序列函数
	local letter = string.sub(picturetype,1,1)
	local num = tonumber(string.sub(picturetype,2,2))
	if num == 5  then
		print("图片顺序为",letter:rep(num))
		local sequence = letter:rep(num)
		return sequence
	elseif num ==4 then
		local a = math.random(1,2)
		local b
		repeat
			b =string.char(math.random(65,70))
			until (letter~=b)
		if a==1 then
			print("图片顺序为",letter:rep(num) .. b)
			local sequence = letter:rep(num) .. b
			return sequence
		else 
			print("图片顺序为",b .. letter:rep(num))
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
			print("图片顺序为",letter:rep(num) .. b..c)
			local sequence = letter:rep(num).. b..c
		    return sequence
		elseif a==2 then
			print("图片顺序为",b .. letter:rep(num)..c)
			local sequence = b..letter:rep(num)..c
		    return sequence
		elseif a==3 then
			print("图片顺序为",b ..c.. letter:rep(num))
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
			print("图片顺序为",a..b..c..d..e)
			local sequence = a..b..c..d..e
		    return sequence
	end
end

function send_result(fd,SERIES,WCOUNT,MAXMONEY,SUNMONEY,FINMONEY,WINLIST)
	local who = "123456"
	local result={ID="4",STATE=true,SERIES=SERIES,WCOUNT=WCOUNT,
	       MAXMONEY=MAXMONEY,SUNMONEY=SUNMONEY,FINMONEY=FINMONEY,WINLIST=WINLIST}
    local result1=cjson.encode(result)
    local result1_1=crypt.aesencode(result1,who,"")
    local result1_2 = crypt.base64encode(result1_1)
    socket.write(fd,result1_2.."\n")
end

	--记录中奖类型

 	gamenum=0          --游戏次数
 	money=0            --赚的金额
	deposit=0          --押金
	historyj=0         --历史中奖次数
	n=1                --number1 的索引
    x = 1              --1 为普通模式 2为困难模式 3为简单模式	
	historynum=0       --历史抽奖次数
	winmoney={}        --中奖金额
--主循环判断
function gamemain(fd,end_point,beilv,k)                         --end_point底分    beilv 倍率   k 次数
	historynum=historynum+k
	local j=0           --记录本轮中奖总次数
	local number1={}    --第几次中奖
	local number2={}	--第几次中的什么奖
	local wintype={A5=0,B5=0,C5=0,D5=0,E5=0,A4=0,B4=0,C4=0,D4=0,E4=0,A3=0,B3=0,C3=0,D3=0,E3=0}
	local sequence = {}	
for i=1,k do
	a=math.random(1,1000000)
	print("-----------------------------")
	-- --------------普通模式---------------------

	if x==1 then
		print("这是普通模式")
		if a>=1 and a<=4 then
			print(i,"中奖类型AAAAA----O(∩_∩)O~~-!")
			j=j+1
			wintype.A5=wintype.A5+1
			table.insert(number1,i)
			table.insert(number2,"A5")
			n=n+1
			table.insert(sequence,picture_order("A5"))
			print("得分为",end_point*beilv*100)
			money=money+end_point*beilv*100
		elseif a>=5 and a<=34 then
			print(i,"中奖类型BBBBB----O(∩_∩)O~~-!")
			j=j+1
			wintype.B5=wintype.B5+1
			table.insert(number1,i)
			table.insert(number2,"B5")
			n=n+1
			table.insert(sequence,picture_order("B5"))
			print("得分为",end_point*beilv*90) 
			money=money+end_point*beilv*90
		elseif a>=35 and a<=254 then
			print(i,"中奖类型CCCCC----O(∩_∩)O~~-!")
			j=j+1
			wintype.C5=wintype.C5+1
			table.insert(number1,i)
			table.insert(number2,"C5")
			n=n+1
			table.insert(sequence,picture_order("C5"))
			print("得分为",end_point*beilv*80) 
			money=money+end_point*beilv*80
		elseif a>=255 and a<=704 then
			print(i,"中奖类型DDDDD----O(∩_∩)O~~-!")
			j=j+1
			wintype.D5=wintype.D5+1
			table.insert(number1,i)
			table.insert(number2,"D5")
			n=n+1
			table.insert(sequence,picture_order("D5"))
			print("得分为",end_point*beilv*70) 
			money=money+end_point*beilv*70
		elseif a>=705 and a<=7174 then
			print(i,"中奖类型EEEEE----O(∩_∩)O~~-!")
			j=j+1
			wintype.E5=wintype.E5+1
			table.insert(number1,i)
			table.insert(number2,"E5")
			n=n+1
			table.insert(sequence,picture_order("E5"))
			print("得分为",end_point*beilv*60) 
			money=money+end_point*beilv*100
		elseif a>=7175 and a<=7254 then
			print(i,"中奖类型AAAA----O(∩_∩)O~~-!")
			j=j+1
			wintype.A4=wintype.A4+1
			table.insert(number1,i)
			table.insert(number2,"A4")
			n=n+1
			table.insert(sequence,picture_order("A4"))
			print("得分为",end_point*beilv*30) 
			money=money+end_point*beilv*30
		elseif a>=7255 and a<=7704 then
			print(i,"中奖类型BBBB----O(∩_∩)O~~-!")
			j=j+1
			wintype.B4=wintype.B4+1
			table.insert(number1,i)
			table.insert(number2,"B4")
			n=n+1
			table.insert(sequence,picture_order("B4"))
			print("得分为",end_point*beilv*25) 
			money=money+end_point*beilv*25
		elseif a>=7705 and a<=9564 then
			print(i,"中奖类型CCCC----O(∩_∩)O~~-!")
			j=j+1
			wintype.C4=wintype.C4+1
			table.insert(number1,i)
			table.insert(number2,"C4")
			n=n+1
			table.insert(sequence,picture_order("C4"))
			print("得分为",end_point*beilv*20) 
			money=money+end_point*beilv*20
		elseif a>=9565 and a<=12664 then
			print(i,"中奖类型DDDD----O(∩_∩)O~~-!")
			j=j+1
			wintype.D4=wintype.D4+1
			table.insert(number1,i)
			table.insert(number2,"D4")
			n=n+1
			table.insert(sequence,picture_order("D4"))
			print("得分为",end_point*beilv*15) 
			money=money+end_point*beilv*15
		elseif a>=12665 and a<=39854 then
			print(i,"中奖类型EEEE----O(∩_∩)O~~-!")
			j=j+1
			wintype.E4=wintype.E4+1
			table.insert(number1,i)
			table.insert(number2,"E4")
			n=n+1
			table.insert(sequence,picture_order("E4"))
			print("得分为",end_point*beilv*10) 
			money=money+end_point*beilv*10
		elseif a>=39855 and a<=41274 then
			print(i,"中奖类型AAA----O(∩_∩)O~~-!") 
			j=j+1
			wintype.A3=wintype.A3+1
			table.insert(number1,i)
			table.insert(number2,"A3")
			n=n+1
			table.insert(sequence,picture_order("A3"))
			print("得分为",end_point*beilv*5) 
			money=money+end_point*beilv*5
		elseif a>=41274 and a<=45224 then
			print(i,"中奖类型BBB----O(∩_∩)O~~-!") 
			j=j+1
			wintype.B3=wintype.B3+1
			table.insert(number1,i)
			table.insert(number2,"B3")
			n=n+1
			table.insert(sequence,picture_order("B3"))
			print("得分为",end_point*beilv*3) 
			money=money+end_point*beilv*3
		elseif a>=45225 and a<=57534 then
			print(i,"中奖类型CCC----O(∩_∩)O~~-!") 
			j=j+1
			wintype.C3=wintype.C3+1
			table.insert(number1,i)
			table.insert(number2,"C3")
			n=n+1
			table.insert(sequence,picture_order("C3"))
			print("得分为",end_point*beilv*1)
			money=money+end_point*beilv*1 
		elseif a>=57535 and a<=76744 then
			print(i,"中奖类型DDD----O(∩_∩)O~~-!") 
			j=j+1
			wintype.D3=wintype.D3+1
			table.insert(number1,i)
			table.insert(number2,"D3")
			n=n+1
			table.insert(sequence,picture_order("D3"))
			print("得分为",end_point*beilv*0.5)
			money=money+end_point*beilv*0.5 
		elseif a>=76745 and a<=148224 then
			print(i,"中奖类型EEE----O(∩_∩)O~~-!") 
			j=j+1
			wintype.E3=wintype.E3+1
			table.insert(number1,i)
			table.insert(number2,"E3")
			n=n+1
			table.insert(sequence,picture_order("E3"))
			print("得分为",end_point*beilv*0.3)
			money=money+end_point*beilv*0.3 
		else 
			print(i,"没有中奖")
			table.insert(sequence,picture_order("NO"))
			print("得分为",end_point*beilv*0) 
			money=money+end_point*beilv*0
		end

---------------------困难模式-----------------------	

	elseif  x==2   then
		print("这是困难模式")
		if a>=1 and a<=30 then
			print(i,"中奖类型AAAAA----O(∩_∩)O~~-!")
			j=j+1
			wintype.A5=wintype.A5+1
			table.insert(number1,i)
			table.insert(number2,"A5")
			n=n+1
			table.insert(sequence,picture_order("A5"))
			print("得分为",end_point*beilv*100)
			money=money+end_point*beilv*100 
		elseif a>=31 and a<=80 then
			print(i,"中奖类型BBBBB----O(∩_∩)O~~-!")
			j=j+1
			wintype.B5=wintype.B5+1
			table.insert(number1,i)
			table.insert(number2,"B5")
			n=n+1
			table.insert(sequence,picture_order("B5"))
			print("得分为",end_point*beilv*90)
			money=money+end_point*beilv*90 
		elseif a>=81 and a<=150 then
			print(i,"中奖类型CCCCC----O(∩_∩)O~~-!")
			j=j+1
			wintype.C5=wintype.C5+1
			table.insert(number1,i)
			table.insert(number2,"C5")
			n=n+1
			table.insert(sequence,picture_order("C5"))
			print("得分为",end_point*beilv*80)
			money=money+end_point*beilv*80 
		elseif a>=151 and a<=381 then
			print(i,"中奖类型DDDDD----O(∩_∩)O~~-!")
			j=j+1
			wintype.D5=wintype.D5+1
			table.insert(number1,i)
			table.insert(number2,"D5")
			n=n+1
			table.insert(sequence,picture_order("D5"))
			print("得分为",end_point*beilv*70) 
			money=money+end_point*beilv*70
		elseif a>=382 and a<=6741 then
			print(i,"中奖类型EEEEE----O(∩_∩)O~~-!")
			j=j+1
			wintype.E5=wintype.E5+1
			table.insert(number1,i)
			table.insert(number2,"E5")
			n=n+1
			table.insert(sequence,picture_order("E5"))
			print("得分为",end_point*beilv*60)
			money=money+end_point*beilv*60 
		elseif a>=6742 and a<=7011 then
			print(i,"中奖类型AAAA----O(∩_∩)O~~-!")
			j=j+1
			wintype.A4=wintype.A4+1
			table.insert(number1,i)
			table.insert(number2,"A4")
			n=n+1
			table.insert(sequence,picture_order("A4"))
			print("得分为",end_point*beilv*30)
			money=money+end_point*beilv*30 
		elseif a>=7012 and a<=7851 then
			print(i,"中奖类型BBBB----O(∩_∩)O~~-!")
			j=j+1
			wintype.B4=wintype.B4+1
			table.insert(number1,i)
			table.insert(number2,"B4")
			n=n+1
			table.insert(sequence,picture_order("B4"))
			print("得分为",end_point*beilv*25)
			money=money+end_point*beilv*25 
		elseif a>=7852 and a<=9451 then
			print(i,"中奖类型CCCC----O(∩_∩)O~~-!")
			j=j+1
			wintype.C4=wintype.C4+1
			table.insert(number1,i)
			table.insert(number2,"C4")
			n=n+1
			table.insert(sequence,picture_order("C4"))
			print("得分为",end_point*beilv*20)
			money=money+end_point*beilv*20 
		elseif a>=9452 and a<=11361 then
			print(i,"中奖类型DDDD----O(∩_∩)O~~-!")
			j=j+1
			wintype.D4=wintype.D4+1
			table.insert(number1,i)
			table.insert(number2,"D4")
			n=n+1
			table.insert(sequence,picture_order("D4"))
			print("得分为",end_point*beilv*15)
			money=money+end_point*beilv*15 
		elseif a>=11362 and a<=39854 then
			print(i,"中奖类型EEEE----O(∩_∩)O~~-!")
			j=j+1
			wintype.E4=wintype.E4+1
			table.insert(number1,i)
			table.insert(number2,"E4")
			n=n+1
			table.insert(sequence,picture_order("E4"))
			print("得分为",end_point*beilv*10) 
			money=money+end_point*beilv*10
		elseif a>=39855 and a<=34571 then
			print(i,"中奖类型AAA----O(∩_∩)O~~-!") 
			j=j+1
			wintype.A3=wintype.A3+1
			table.insert(number1,i)
			table.insert(number2,"A3")
			n=n+1
			table.insert(sequence,picture_order("A3"))
			print("得分为",end_point*beilv*5)
			money=money+end_point*beilv*5 
		elseif a>=34572 and a<=45224 then
			print(i,"中奖类型BBB----O(∩_∩)O~~-!") 
			j=j+1
			wintype.B3=wintype.B3+1
			table.insert(number1,i)
			table.insert(number2,"B3")
			n=n+1
			table.insert(sequence,picture_order("B3"))
			print("得分为",end_point*beilv*3)
			money=money+end_point*beilv*3 
		elseif a>=45225 and a<=37511 then
			print(i,"中奖类型CCC----O(∩_∩)O~~-!") 
			j=j+1
			wintype.C3=wintype.C3+1
			table.insert(number1,i)
			table.insert(number2,"C3")
			n=n+1
			table.insert(sequence,picture_order("C3"))
			print("得分为",end_point*beilv*1)
			money=money+end_point*beilv*1 
		elseif a>=37512 and a<=45061 then
			print(i,"中奖类型DDD----O(∩_∩)O~~-!") 
			j=j+1
			wintype.D3=wintype.D3+1
			table.insert(number1,i)
			table.insert(number2,"D3")
			n=n+1
			table.insert(sequence,picture_order("D3"))
			print("得分为",end_point*beilv*0.5)
			money=money+end_point*beilv*0.5 
		elseif a>=45062 and a<=56151 then
			print(i,"中奖类型EEE----O(∩_∩)O~~-!") 
			j=j+1
			wintype.E3=wintype.E3+1
			table.insert(number1,i)
			table.insert(number2,"E3")
			n=n+1
			table.insert(sequence,picture_order("E3"))
			print("得分为",end_point*beilv*0.3)
			money=money+end_point*beilv*0.3 
		else 
			print(i,"没有中奖")
			table.insert(sequence,picture_order("NO"))
			print("得分为",end_point*beilv*0)
			money=money+end_point*beilv*0 
		end
------------------------简单模式-----------------------------
	elseif x==3 then 
		print("这是简单模式")
		if a>=1 and a<=20 then
			print(i,"中奖类型AAAAA----O(∩_∩)O~~-!")
			j=j+1
			wintype.A5=wintype.A5+1
			table.insert(number1,i)
			table.insert(number2,"A5")
			n=n+1
			table.insert(sequence,picture_order("A5"))
			print("得分为",end_point*beilv*300) 
			money=money+end_point*beilv*300
		elseif a>=21 and a<=40 then
			print(i,"中奖类型BBBBB----O(∩_∩)O~~-!")
			j=j+1
			wintype.B5=wintype.B5+1
			table.insert(number1,i)
			table.insert(number2,"B5")
			n=n+1
			table.insert(sequence,picture_order("B5"))
			print("得分为",end_point*beilv*250) 
			money=money+end_point*beilv*250
		elseif a>=41 and a<=70 then
			print(i,"中奖类型CCCCC----O(∩_∩)O~~-!")
			j=j+1
			wintype.C5=wintype.C5+1
			table.insert(number1,i)
			table.insert(number2,"C5")
			n=n+1
			table.insert(sequence,picture_order("C5"))
			print("得分为",end_point*beilv*200)
			money=money+end_point*beilv*200 
		elseif a>=71 and a<=1160 then
			print(i,"中奖类型DDDDD----O(∩_∩)O~~-!")
			j=j+1
			wintype.D5=wintype.D5+1
			table.insert(number1,i)
			table.insert(number2,"D5")
			n=n+1
			table.insert(sequence,picture_order("D5"))
			print("得分为",end_point*beilv*150)
			money=money+end_point*beilv*150 
		elseif a>=1161 and a<=7220 then
			print(i,"中奖类型EEEEE----O(∩_∩)O~~-!")
			j=j+1
			wintype.E5=wintype.E5+1
			table.insert(number1,i)
			table.insert(number2,"E5")
			n=n+1
			table.insert(sequence,picture_order("E5"))
			print("得分为",end_point*beilv*100)
			money=money+end_point*beilv*100 
		elseif a>=7221 and a<=7530 then
			print(i,"中奖类型AAAA----O(∩_∩)O~~-!")
			j=j+1
			wintype.A4=wintype.A4+1
			table.insert(number1,i)
			table.insert(number2,"A4")
			n=n+1
			table.insert(sequence,picture_order("A4"))
			print("得分为",end_point*beilv*300) 
			money=money+end_point*beilv*300
		elseif a>=7531 and a<=7840 then
			print(i,"中奖类型BBBB----O(∩_∩)O~~-!")
			j=j+1
			wintype.B4=wintype.B4+1
			table.insert(number1,i)
			table.insert(number2,"B4")
			n=n+1
			table.insert(sequence,picture_order("B4"))
			print("得分为",end_point*beilv*40)
			money=money+end_point*beilv*40 
		elseif a>=7841 and a<=8080 then
			print(i,"中奖类型CCCC----O(∩_∩)O~~-!")
			j=j+1
			wintype.C4=wintype.C4+1
			table.insert(number1,i)
			table.insert(number2,"C4")
			n=n+1
			table.insert(sequence,picture_order("C4"))
			print("得分为",end_point*beilv*20)
			money=money+end_point*beilv*20 
		elseif a>=8081 and a<=13630 then
			print(i,"中奖类型DDDD----O(∩_∩)O~~-!")
			j=j+1
			wintype.D4=wintype.D4+1
			table.insert(number1,i)
			table.insert(number2,"D4")
			n=n+1
			table.insert(sequence,picture_order("D4"))
			print("得分为",end_point*beilv*10)
			money=money+end_point*beilv*10 
		elseif a>=13631 and a<=44440 then
			print(i,"中奖类型EEEE----O(∩_∩)O~~-!")
			j=j+1
			wintype.E4=wintype.E4+1
			table.insert(number1,i)
			table.insert(number2,"E4")
			n=n+1
			table.insert(sequence,picture_order("E4"))
			print("得分为",end_point*beilv*10)
			money=money+end_point*beilv*10 
		elseif a>=44441 and a<=48100 then
			print(i,"中奖类型AAA----O(∩_∩)O~~-!") 
			j=j+1
			wintype.A3=wintype.A3+1
			table.insert(number1,i)
			table.insert(number2,"A3")
			n=n+1
			table.insert(sequence,picture_order("A3"))
			print("得分为",end_point*beilv*5)
			money=money+end_point*beilv*5 
		elseif a>=48101 and a<=51540 then
			print(i,"中奖类型BBB----O(∩_∩)O~~-!") 
			j=j+1
			wintype.B3=wintype.B3+1
			table.insert(number1,i)
			table.insert(number2,"B3")
			n=n+1
			table.insert(sequence,picture_order("B3"))
			print("得分为",end_point*beilv*3)
			money=money+end_point*beilv*3 
		elseif a>=51541 and a<=54570 then
			print(i,"中奖类型CCC----O(∩_∩)O~~-!") 
			j=j+1
			wintype.C3=wintype.C3+1
			table.insert(number1,i)
			table.insert(number2,"C3")
			n=n+1
			table.insert(sequence,picture_order("C3"))
			print("得分为",end_point*beilv*1) 
			money=money+end_point*beilv*1
		elseif a>=54571 and a<=82020 then
			print(i,"中奖类型DDD----O(∩_∩)O~~-!") 
			j=j+1
			wintype.D3=wintype.D3+1
			table.insert(number1,i)
			table.insert(number2,"D3")
			n=n+1
			table.insert(sequence,picture_order("D3"))
			print("得分为",end_point*beilv*0.5)
			money=money+end_point*beilv*0.5 
		elseif a>=82021 and a<=161210 then
			print(i,"中奖类型EEE----O(∩_∩)O~~-!") 
			j=j+1
			wintype.E3=wintype.E3+1
			table.insert(number1,i)
			table.insert(number2,"E3")
			n=n+1
			table.insert(sequence,picture_order("E3"))
			print("得分为",end_point*beilv*0.3) 
			money=money+end_point*beilv*0.3
		else 
			print(i,"没有中奖")
			table.insert(sequence,picture_order("NO"))
			print("得分为",end_point*beilv*0)
			money=money+end_point*beilv*0 
		end
	end
	gamenum=gamenum+1
	deposit=deposit+end_point*beilv
	if gamenum%10==0 and money/deposit>=0.9 then
		x=2
		print("2 money/depost=",money,deposit,money/deposit)
		money=0
		deposit=0
	elseif gamenum%10==0 and money/deposit<=0.8 then
		x=3
		print("3 money/depost=",money,deposit,money/deposit)
		money=0
		deposit=0
	elseif gamenum%10==0 and money/deposit>0.8 and money/deposit<0.9 then
		x=1
		print("2 money/depost=",money,deposit,money/deposit)
		money=0
		deposit=0
	end
end
	historyj=historyj+j
	print("本轮抽奖次数",k)
	print("历史抽奖次数",historynum)
	print("历史中奖次数",historyj)
	print("本轮中奖次数",j)
	for key,v in pairs(wintype) do
		if v~=0  then
			print("中奖类型为",key,"中奖次数为",v) 
		end
	end
	 
	persentmax=1    --记录最高连续中奖次数
	if  not number1[1] then
		print("最高连续中奖次数为",0)
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

		print("最高连续中奖次数为",max)
	end

		for key,v in ipairs(number1) do
			print("第",v,"次中奖","中奖类型为",number2[key])
		end
	if not number1[1] then
			print("最高连续不中奖次数为0")
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
			print("最高连续不中奖次数为",max-1,"第",startnum,"-",endnum,"次")
		end
	end
	send_result(fd,max,j,1,1,50000,sequence)
end

function CMD.calc(fd,end_point,beilv,k)
	 gamemain(fd,end_point,beilv,k)
end
-- gamemain(1,10,10,5)
-- gamemain(1,10,10,10)
-- gamemain(1,10,10,20)
skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
	--print("this is maingame")
    -- 要注册个服务的名字，以.开头
    skynet.register(".maingame")
end)
