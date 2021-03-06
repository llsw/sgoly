require "skynet.manager"
local socket=require "socket"
local skynet=require "skynet"
local crypt 	= require "crypt"
local cluster   = require "cluster"
local sgoly_tool = require"sgoly_tool"
local sgoly_pack =require"sgoly_pack"
require "sgoly_printf"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
local CMD = {}
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))

function picture_order(picturetype)              --图片序列函数
	local letter = string.sub(picturetype,1,1)
	local num = tonumber(string.sub(picturetype,2,2))
	if num == 5  then
		skynet.error("图片顺序为",letter:rep(num))
		local sequence = letter:rep(num)
		return sequence
	elseif num==6 then
		skynet.error("图片顺序为","ABCDE")
		local sequence = "ABCDE"
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
			if letter=="F" then
				skynet.error("图片顺序为",letter:rep(num) .. b..c.."1")
				local sequence = letter:rep(num).. b..c.."1"
			    return sequence
			else
				skynet.error("图片顺序为",letter:rep(num) .. b..c)
				local sequence = letter:rep(num).. b..c
			    return sequence
		    end
		elseif a==2 then
			if letter=="F" then
				skynet.error("图片顺序为",b .. letter:rep(num)..c.."1")
				local sequence = b..letter:rep(num)..c.."1"
			    return sequence
			else
				skynet.error("图片顺序为",b .. letter:rep(num)..c)
				local sequence = b..letter:rep(num)..c
			    return sequence
			end
		elseif a==3 then
			if letter=="F" then
				skynet.error("图片顺序为",b ..c.. letter:rep(num).."1")
				local sequence = b..c..letter:rep(num).."1"
			    return sequence
			else
				skynet.error("图片顺序为",b ..c.. letter:rep(num))
				local sequence = b..c..letter:rep(num)
			    return sequence
			end
		end
	else
		local a,b,c,d,e
		repeat
		 a = string.char(math.random(65,70))
		 b = string.char(math.random(65,70))
		 c = string.char(math.random(65,70))
		 d = string.char(math.random(65,70))
		 e = string.char(math.random(65,70))
		until((a~=b and b~=c) and (b~=c and c~=d) and (c~=d and d~=e) and (a~=65 and b~=66 and c~=67 and d~=68 and e~=69))
			skynet.error("图片顺序为",a..b..c..d..e)
			local sequence = a..b..c..d..e
		    return sequence
	end
end


function send_result(fd,session,TYPE,SERIES,WCOUNT,MAXMONEY,SUNMONEY,FINMONEY,WINLIST,WMONEY,name)
	local who = "123456"
	local result={ID="4",SESSION=session,TYPE=TYPE,STATE=true,SERIES=SERIES,WCOUNT=WCOUNT,
	       MAXMONEY=MAXMONEY,SUNMONEY=SUNMONEY,FINMONEY=FINMONEY,
	       WINLIST=WINLIST,WMONEY=WMONEY}
	printI("this is maingame name=%s,session=%s,SUNMONEY=%s,WMONEY=%s",name,session,SUNMONEY,WMONEY)
    local result1=cjson.encode(result)
    local result1_1=crypt.aesencode(result1,who,"")
    local result1_2 = crypt.base64encode(result1_1)
    return result1_2
end

 --     记录中奖类型
 	money=0                --赚的金额
	deposit=0              --消耗金额
	historyj=0             --历史中奖次数
 --    x = 1               --1 为普通模式 2为困难模式 3为简单模式	
	historynum=0           --历史抽奖次数
	autonum=0              --自动抽奖次数
	automoney={}           --自动中奖金额
	autonumber1={}         --自动第几次中奖
	autocost=0             --自动消耗金钱
	autowinall =0          --自动中奖总金额
	autowinmax =0          --自动中奖最高金额
	autozjnumsave=0        --自动中奖次数存数据库
	automaxsave=0		   --自动最高连续中奖次数
	xsave=1                --游戏模式存数据库
	-- winmoney={}        --中奖金额
--主循环判断
function gamemain(fd,session,TYPE,end_point,beilv,k,MONEY,cost,name) 
    printI("I am %s",name)
    gamenum=0          --游戏次数
 	moneydb=0          --赚得金额存数据库
	depositdb=0        --消耗金额存数据库
	n=1                --number1 的索引
	bo,y=sgoly_tool.getPlayModelFromRedis(name)
    x=y[2] 
    xsave=x            --1 为普通模式 2为困难模式 3为简单模式	
    printI("x=%d,%d,%d",x,y[1],y[2])
    skynet.error(type(x),type(y[2]))
	winmoney={}         --中奖金额       
	printI("MONEY=%s,cost=%s",MONEY,cost)
	--historynum=historynum+k
	if TYPE=="autostart" or TYPE=="autogo" then 
		autonum=autonum+k
		autocost=autocost+end_point*beilv
	end

    local j=0           --记录本轮中奖总次数
	local number1={}    --第几次中奖
	local number2={}	--第几次中的什么奖
	local wintype={A5=0,B5=0,C5=0,D5=0,E5=0,A4=0,B4=0,C4=0,D4=0,E4=0,A3=0,B3=0,C3=0,D3=0,E3=0,A6=0,F3=0}
	local sequence = {}	
	function  reqpack(wintype,type,grade,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
			wintype[type]=wintype[type]+1
			table.insert(number1,i)
			if TYPE=="autostart" or TYPE=="autogo" then 
				table.insert(autonumber1,autonum)
			end
			table.insert(number2,type)
			table.insert(sequence,picture_order(type))
			skynet.error("得分为",end_point*beilv*grade)
			money=money+end_point*beilv*grade
			table.insert(winmoney,end_point*beilv*grade)
			if TYPE=="autostart" or TYPE=="autogo" then 
				table.insert(automoney,end_point*beilv*grade)
				autowinall=autowinall+end_point*beilv*grade
			end
    end
for i=1,k do
	a=math.random(1,1000000)
	skynet.error("-----------------------------")
	-- --------------普通模式---------------------

	if x==1 then
		skynet.error("这是普通模式")
		if a>=1 and a<=4 then
			skynet.error(i,"中奖类型AAAAA----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"A5",500,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=5 and a<=34 then
			skynet.error(i,"中奖类型BBBBB----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"B5",300,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=35 and a<=254 then
			skynet.error(i,"中奖类型CCCCC----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"C5",200,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=255 and a<=704 then
			skynet.error(i,"中奖类型DDDDD----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"D5",100,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=705 and a<=7174 then
			skynet.error(i,"中奖类型EEEEE----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"E5",50,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=7175 and a<=7254 then
			skynet.error(i,"中奖类型AAAA----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"A4",30,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=7255 and a<=7704 then
			skynet.error(i,"中奖类型BBBB----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"B4",25,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=7705 and a<=9564 then
			skynet.error(i,"中奖类型CCCC----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"C4",20,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=9565 and a<=12664 then
			skynet.error(i,"中奖类型DDDD----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"D4",15,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=12665 and a<=39854 then
			skynet.error(i,"中奖类型EEEE----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"E4",10,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=39855 and a<=41274 then
			skynet.error(i,"中奖类型AAA----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"A3",5,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=41274 and a<=45224 then
			skynet.error(i,"中奖类型BBB----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"B3",3,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=45225 and a<=57534 then
			skynet.error(i,"中奖类型CCC----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"C3",2,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=57535 and a<=76744 then
			skynet.error(i,"中奖类型DDD----O(∩_∩)O~~-!")
			j=j+1 
			reqpack(wintype,"D3",1,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=76745 and a<=148224 then
			skynet.error(i,"中奖类型EEE----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"E3",0.5,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=148225 and a<=148234 then
			skynet.error(i,"中奖类型ABCDE----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"A6",1000,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=148235 and a<=158234 then
			if TYPE=="autostart" or TYPE=="autogo" then 
				skynet.error(i,"没有中奖")
				table.insert(sequence,picture_order("NO"))
				skynet.error("得分为",end_point*beilv*0)
				money=money+end_point*beilv*0
				table.insert(winmoney,end_point*beilv*0)
				if TYPE=="autostart" or TYPE=="autogo" then 
					table.insert(automoney,end_point*beilv*0)
					autowinall=autowinall+end_point*beilv*0
				end
		    else
				skynet.error(i,"中奖类型FFF----O(∩_∩)O~~-!") 
				j=j+1
				wintype.F3=wintype.F3+1
				table.insert(number1,i)
				table.insert(number2,"F3")
				table.insert(sequence,picture_order("F3"))
				skynet.error("得分为",end_point*beilv*0)
				money=money+end_point*beilv*0
				table.insert(winmoney,end_point*beilv*0)
			end
	    else 
			skynet.error(i,"没有中奖")
			table.insert(sequence,picture_order("NO"))
			skynet.error("得分为",end_point*beilv*0)
			money=money+end_point*beilv*0
			table.insert(winmoney,end_point*beilv*0)
			if TYPE=="autostart" or TYPE=="autogo" then 
				table.insert(automoney,end_point*beilv*0)
				autowinall=autowinall+end_point*beilv*0
			end
		end
---------------------困难模式-----------------------	

	elseif  x==2   then
		skynet.error("这是困难模式")
		if a>=1 and a<=30 then
			skynet.error(i,"中奖类型AAAAA----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"A5",500,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=31 and a<=80 then
			skynet.error(i,"中奖类型BBBBB----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"b5",300,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=81 and a<=230 then
			skynet.error(i,"中奖类型CCCCC----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"C5",200,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=231 and a<=460 then
			skynet.error(i,"中奖类型DDDDD----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"D5",100,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=461 and a<=6820 then
			skynet.error(i,"中奖类型EEEEE----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"E5",50,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=6821 and a<=7011 then
			skynet.error(i,"中奖类型AAAA----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"A4",30,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=7012 and a<=7851 then
			skynet.error(i,"中奖类型BBBB----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"B4",500,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=7852 and a<=9451 then
			skynet.error(i,"中奖类型CCCC----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"C4",20,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=9452 and a<=11361 then
			skynet.error(i,"中奖类型DDDD----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"D4",15,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=11362 and a<=34571 then
			skynet.error(i,"中奖类型EEEE----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"E4",10,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=34572 and a<=37511 then
			skynet.error(i,"中奖类型AAA----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"A3",5,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=37512 and a<=45061 then
			skynet.error(i,"中奖类型BBB----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"B3",3,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=45062 and a<=56151 then
			skynet.error(i,"中奖类型CCC----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"C3",2,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=56152 and a<=67981 then
			skynet.error(i,"中奖类型DDD----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"D3",1,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=67982 and a<=131571 then
			skynet.error(i,"中奖类型EEE----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"E3",0.5,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=131572 and a<=131581 then
			skynet.error(i,"中奖类型ABCDE----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"A6",1000,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=131582 and a<=141581 then
			if TYPE=="autostart" or TYPE=="autogo" then 
				skynet.error(i,"没有中奖")
				table.insert(sequence,picture_order("NO"))
				skynet.error("得分为",end_point*beilv*0)
				money=money+end_point*beilv*0 
				table.insert(winmoney,end_point*beilv*0)
				if TYPE=="autostart" or TYPE=="autogo" then 
					table.insert(automoney,end_point*beilv*0)
					autowinall=autowinall+end_point*beilv*0
				end
		    else
				skynet.error(i,"中奖类型FFF----O(∩_∩)O~~-!") 
				j=j+1
				wintype.F3=wintype.F3+1
				table.insert(number1,i)
				table.insert(number2,"F3")
				table.insert(sequence,picture_order("F3"))
				skynet.error("得分为",end_point*beilv*0)
				money=money+end_point*beilv*0
				table.insert(winmoney,end_point*beilv*0)
			end
		else 
			skynet.error(i,"没有中奖")
			table.insert(sequence,picture_order("NO"))
			skynet.error("得分为",end_point*beilv*0)
			money=money+end_point*beilv*0
			table.insert(winmoney,end_point*beilv*0)
			if TYPE=="autostart" or TYPE=="autogo" then 
				table.insert(automoney,end_point*beilv*0)
				autowinall=autowinall+end_point*beilv*0
			end
		end
------------------------简单模式-----------------------------
	elseif x==3 then 
		skynet.error("这是简单模式")
		if a>=1 and a<=10 then
			skynet.error(i,"中奖类型AAAAA----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"A5",500,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=11 and a<=40 then
			skynet.error(i,"中奖类型BBBBB----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"B5",300,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=41 and a<=90 then
			skynet.error(i,"中奖类型CCCCC----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"C5",200,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=91 and a<=1450 then
			skynet.error(i,"中奖类型DDDDD----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"D5",100,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=1451 and a<=7130 then
			skynet.error(i,"中奖类型EEEEE----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"E5",50,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=7131 and a<=7260 then
			skynet.error(i,"中奖类型AAAA----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"A4",30,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=7261 and a<=7610 then
			skynet.error(i,"中奖类型BBBB----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"B4",25,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=7611 and a<=8060 then
			skynet.error(i,"中奖类型CCCC----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"C4",20,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=8061 and a<=13970 then
			skynet.error(i,"中奖类型DDDD----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"D4",15,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=13971 and a<=44270 then
			skynet.error(i,"中奖类型EEEE----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"E4",10,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=44271 and a<=46230 then
			skynet.error(i,"中奖类型AAA----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"A3",5,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=46231 and a<=49780 then
			skynet.error(i,"中奖类型BBB----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"B3",3,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=49781 and a<=54070 then
			skynet.error(i,"中奖类型CCC----O(∩_∩)O~~-!")
			j=j+1
			reqpack(wintype,"C3",2,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney) 
		elseif a>=54071 and a<=82930 then
			skynet.error(i,"中奖类型DDD----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"D3",1,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=82931 and a<=162480 then
			skynet.error(i,"中奖类型EEE----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"E3",0.5,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=162481 and a<=162490 then
			skynet.error(i,"中奖类型ABCDE----O(∩_∩)O~~-!") 
			j=j+1
			reqpack(wintype,"A6",1000,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney)
		elseif a>=162491 and a<=172490 then
			if TYPE=="autostart" or TYPE=="autogo" then 
				skynet.error(i,"没有中奖")
				table.insert(sequence,picture_order("NO"))
				skynet.error("得分为",end_point*beilv*0)
				money=money+end_point*beilv*0 
				table.insert(winmoney,end_point*beilv*0)
				if TYPE=="autostart" or TYPE=="autogo" then 
					table.insert(automoney,end_point*beilv*0)
					autowinall=autowinall+end_point*beilv*0
				end
		    else
				skynet.error(i,"中奖类型FFF----O(∩_∩)O~~-!") 
				j=j+1
				wintype.F3=wintype.F3+1
				table.insert(number1,i)
				table.insert(number2,"F3")
				table.insert(sequence,picture_order("F3"))
				skynet.error("得分为",end_point*beilv*0)
				money=money+end_point*beilv*0
				table.insert(winmoney,end_point*beilv*0)
			end
		else 
			skynet.error(i,"没有中奖")
			table.insert(sequence,picture_order("NO"))
			skynet.error("得分为",end_point*beilv*0)
			money=money+end_point*beilv*0 
			table.insert(winmoney,end_point*beilv*0)
			if TYPE=="autostart" or TYPE=="autogo" then 
				table.insert(automoney,end_point*beilv*0)
				autowinall=autowinall+end_point*beilv*0
			end
		end
	end
---------------------10次判断切换模式---------------------------
	historynum=historynum+1
	gamenum=gamenum+1
	moneydb=moneydb+money
	deposit=deposit+end_point*beilv
	if historynum%10==0 and money/deposit>=0.9 then
		x=2
		sgoly_tool.saveStatementsToRedis(name,0,0,0,0,0,0,0,x,os.date("%Y-%m-%d"))           
		skynet.error("2 money/depost=",money,deposit,money/deposit,"进入困难模式")
		money=0
		deposit=0
	elseif historynum%10==0 and money/deposit<=0.75 then
		x=3
		sgoly_tool.saveStatementsToRedis(name,0,0,0,0,0,0,0,x,os.date("%Y-%m-%d")) 
		skynet.error("3 money/depost=",money,deposit,money/deposit,"进入简单模式")
		money=0 
		deposit=0
	elseif historynum%10==0 and money/deposit>0.9 and money/deposit<0.75 then
		x=1
		sgoly_tool.saveStatementsToRedis(name,0,0,0,0,0,0,0,x,os.date("%Y-%m-%d")) 
		skynet.error("2 money/depost=",money,deposit,money/deposit,"进入普通模式")
		money=0
		deposit=0
	end
end  --for 循环end
-----------------------抽奖次数--------------------------
	historyj=historyj+j
	printI("本轮抽奖次数%d",k)
	printI("历史抽奖次数%d",historynum)
	printI("历史中奖次数%d",historyj)
	printI("本轮中奖次数%d",j)
	for key,v in pairs(wintype) do
		if v~=0  then
			skynet.error("中奖类型为%d,中奖次数为%s",key,v) 
		end
	end
------------------最高连续中奖次数-----------------------------	 
	persentmax=1    --记录最高连续中奖次数
	if  not number1[1] then
		max=0
		skynet.error("最高连续中奖次数为0")
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
		skynet.error("最高连续中奖次数为%d",max)
	end

----------------------------------------------------------
		for key,v in ipairs(number1) do
			skynet.error("第%d次中奖,中奖类型为%s",v,number2[key])
		end
---------------------最高连续不中奖次数-----------------------
    local houmian=0
	if not number1[1] then
			skynet.error("最高连续不中奖次数为k")
	else
		local max = number1[1]
		for key,v in ipairs(number1) do
			if number1[key+1]~=nil then
				 if max<number1[key+1]-v then
			 	    max=number1[key+1]-v
			 	    startnum=v
			 	    endnum=number1[key+1]
			 	 end
			else 
                houmian=k-v
			end
			if max==number1[1] then
				startnum=1
				endnum=number1[1]
			end
		end
		if  max>0 and max>houmian then
			skynet.error("最高连续不中奖次数为%d,第%d-%d次",max-1,startnum,endnum)
	    else
	    	printI("最高连续不中奖次数为%d,第%d-%d次",houmian,endnum+1,k)
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

    local nowMONEY=tonumber(MONEY)-tonumber(cost)+winall
    if k~="1" and k~="0" then
       sgoly_tool.saveStatementsToRedis(name,winall,cost,k,j,max,winmax,0,x,os.date("%Y-%m-%d"))
       sgoly_tool.saveMoneyToRedis(name,nowMONEY)
   elseif TYPE=="autoend"  then
    -------------------自动最高连续中奖次数-----------------------------
		autopersentmax=1    --记录自动最高连续中奖次数
			if  not autonumber1[1] then
				automax=0
				skynet.error("自动最高连续中奖次数为0")
			else
				automax=1  --最终最高连续中奖次数
				for key,v in ipairs(autonumber1) do 
					skynet.error("autonumber1",key,v)
					if v+1==autonumber1[key+1] then
						autopersentmax=autopersentmax+1

					else
							if automax<autopersentmax then
							   automax=autopersentmax
							end
							autopersentmax=1
					end
				end
				skynet.error("自动最高连续中奖次数为%d",automax)
				automaxsave=automax
			end
	    ---------------------自动中奖最高金额---------------
				for k,v in ipairs(automoney) do
					-- print("automoney",k,v)
				     if v>autowinmax then 
				     	autowinmax=v
				     end
				end
	---------------------自动获奖总金额----------------
			    printI("autowinall is %s",autowinall)
	-------------------------------------------------------
		   local autozjnum = #(autonumber1)
		   autozjnumsave=autozjnum
		   skynet.error("autozjnum=",autozjnum)
	       local bool1,req1=sgoly_tool.saveStatementsToRedis(name,autowinall,autocost,autonum,autozjnum,automax,autowinmax,0,x,os.date("%Y-%m-%d"))
	       local bool2,req2=sgoly_tool.saveMoneyToRedis(name,MONEY)
	       if bool1 and bool2 then
		        local who = "123456"
			    local resultauto={ID="4",SESSION=session,TYPE=TYPE,STATE=true,AUTONUM=autonum,SERIES=automax,WCOUNT=autozjnum,
			    MAXMONEY=autowinmax,SUNMONEY=autowinall,FINMONEY=MONEY}
			    skynet.error("resultauto",resultauto.AUTONUM,resultauto.SERIES,resultauto.WCOUNT,resultauto.MAXMONEY,resultauto.SUNMONEY,resultauto.FINMONEY)
		        local resultat1_2=sgoly_pack.encode(resultauto)
	            if k=="0" and TYPE=="autoend" then
					    	autonum=0
					    	autocost=0
					    	automoney={}
					    	autonumber1={}
					    	autowinall =0 
							autowinmax =0
							autozjnumsave=0
							automaxsave=0
							xsave=1
		        end
		        return resultat1_2
            else
            	local req5={SESSION=session,ID="4",STATE=false,MESSAGE="存档错误"}
				local req5_1=sgoly_pack.encode(req5)
				return req5_1
			end
    end
	return send_result(fd,session,TYPE,max,j,winmax,winall,nowMONEY,sequence,winmoney,name)
end

function CMD.calc(fd,session,TYPE,end_point,beilv,k,MONEY,cost,name)
    if TYPE=="autogo" then
    	local checkup=sgoly_pack.checkup(end_point,beilv,k,cost)
		print("checkup",checkup)
		if checkup==true and tonumber(cost)<=tonumber(MONEY) then
            return gamemain(fd,session,TYPE,end_point,beilv,k,MONEY,cost,name)
		elseif tonumber(cost)>tonumber(MONEY) then
			local req3={SESSION=session,ID="4",STATE=false,MESSAGE="金币不足"}
			local req3_1=sgoly_pack.encode(req3)
			return req3_1
		else
			local req4={SESSION=session,ID="4",STATE=false,MESSAGE="无效数据"}
			local req4_1=sgoly_pack.encode(req4)
			return req4_1
		end
    elseif TYPE=="gift" then
    	return gamemain(fd,session,TYPE,end_point,beilv,k,MONEY,cost,name)
    elseif TYPE=="start" or TYPE=="autostart" then 
	    local bool,reallymoney=sgoly_tool.getMoney(name)
	    local checkup=sgoly_pack.checkup(end_point,beilv,k,cost)
	    print("reallymoney",reallymoney,"checkup",checkup)
	    if tonumber(reallymoney)==tonumber(MONEY) and checkup==true and tonumber(cost)<=tonumber(MONEY) then
		    return gamemain(fd,session,TYPE,end_point,beilv,k,MONEY,cost,name)
		elseif tonumber(cost)>tonumber(MONEY) then
			local req2={SESSION=session,ID="4",STATE=false,MESSAGE="金币不足"}
			local req2_1=sgoly_pack.encode(req2)
			return req2_1
		else
			local req={SESSION=session,ID="4",STATE=false,MESSAGE="无效数据"}
			local req1=sgoly_pack.encode(req)
			return req1
		end
	
	elseif TYPE=="autoend" then
	    return gamemain(fd,session,TYPE,end_point,beilv,k,MONEY,cost,name)
	else
		local req5={SESSION=session,ID="4",STATE=false,MESSAGE="参数错误"}
		local req5_1=sgoly_pack.encode(req5)
		return req5_1
	end
end

function CMD.autosave(fd,name)
		autopersentmax=1    --记录自动最高连续中奖次数
			if  not autonumber1[1] then
				automax=0
				skynet.error("autosave自动最高连续中奖次数为0")
			else
				automax=1  --最终最高连续中奖次数
				for key,v in ipairs(autonumber1) do 
					skynet.error("autonumber1",key,v)
					if v+1==autonumber1[key+1] then
						autopersentmax=autopersentmax+1

					else
							if automax<autopersentmax then
							   automax=autopersentmax
							end
							autopersentmax=1
					end
				end
				skynet.error("autosave自动最高连续中奖次数为%d",automax)
				automaxsave=automax
			end
	    ---------------------自动中奖最高金额---------------
				for k,v in ipairs(automoney) do
				     if v>autowinmax then 
				     	autowinmax=v
				     end
				end
	local autozjnum = #(autonumber1)
	local autozjnumsave=autozjnum
		  skynet.error("autozjnum=",autozjnum)
   	local c=os.date("%Y-%m-")..(tonumber(os.date("%d"))-1)
    local bool,req=sgoly_tool.getMoney(name)
    local money=tonumber(req)+autowinall-autocost
    printI("this is name=%s,req=%d,autowinall=%d,autocost=%d",name,req,autowinall,autocost)
    local bo1=sgoly_tool.saveStatementsToRedis(name,autowinall,autocost,autonum,autozjnumsave,automaxsave,autowinmax,0,xsave,os.date("%Y-%m-%d"))	   
    local bo2=sgoly_tool.saveMoneyToRedis(name,money)
    autonum=0
    autocost=0
    automoney={}
    autonumber1={}
    autowinall =0 
    autowinmax =0
    autozjnumsave=0
    automaxsave=0
    xsave=1
	if bo1 and  bo2  then
		return "suss"
	else 
		return "false"
	end
end


skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
    -- 要注册个服务的名字，以.开头
    --skynet.register(".maingame")
end)
 