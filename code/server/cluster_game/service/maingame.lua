require "skynet.manager"
local socket=require "socket"
local skynet=require "skynet"
local crypt 	= require "crypt"
local cluster   = require "cluster"
local sgoly_tool = require"sgoly_tool"
local sgoly_pack =require"sgoly_pack"
require "sgoly_printf"
local CMD = {}

local _, awardTypeAndRate = _, {}
local _, normalS, simpleS, difficultyS, luckyS = _, {}, {}, {}, {}
function picture_order(picturetype)              --图片序列函数
	local letter = string.sub(picturetype,1,1)
	local num = tonumber(string.sub(picturetype,2,2))
	if num == 5  then
		printD("图片顺序为 %s",letter:rep(num))
		local sequence = letter:rep(num)
		return sequence
	elseif num==6 then
		printD("图片顺序为 %s","ABCDE")
		local sequence = "ABCDE"
		return sequence
	elseif num ==4 then
		local a = math.random(1,2)
		local b
		repeat
			b =string.char(math.random(65,70))
			until (letter~=b)
		if a==1 then
			printD("图片顺序为 %s",letter:rep(num) .. b)
			local sequence = letter:rep(num) .. b
			return sequence
		else 
			printD("图片顺序为 %s",b .. letter:rep(num))
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
				printD("图片顺序为 %s",letter:rep(num) .. b..c.."1")
				local sequence = letter:rep(num).. b..c.."1"
			    return sequence
			else
				printD("图片顺序为 %s",letter:rep(num) .. b..c)
				local sequence = letter:rep(num).. b..c
			    return sequence
		    end
		elseif a==2 then
			if letter=="F" then
				printD("图片顺序为 %s",b .. letter:rep(num)..c.."1")
				local sequence = b..letter:rep(num)..c.."1"
			    return sequence
			else
				printD("图片顺序为 %s",b .. letter:rep(num)..c)
				local sequence = b..letter:rep(num)..c
			    return sequence
			end
		elseif a==3 then
			if letter=="F" then
				printD("图片顺序为 %s",b ..c.. letter:rep(num).."1")
				local sequence = b..c..letter:rep(num).."1"
			    return sequence
			else
				printD("图片顺序为 %s",b ..c.. letter:rep(num))
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
			printD("图片顺序为 %s",a..b..c..d..e)
			local sequence = a..b..c..d..e
		    return sequence
	end
end


function send_result(fd,session,TYPE,SERIES,WCOUNT,MAXMONEY,SUNMONEY,FINMONEY,WINLIST,WMONEY,name)
	local who = "123456"
	local result={ID="4",SESSION=session,TYPE=TYPE,STATE=true,SERIES=SERIES,WCOUNT=WCOUNT,
	       MAXMONEY=MAXMONEY,SUNMONEY=SUNMONEY,FINMONEY=FINMONEY,
	       WINLIST=WINLIST,WMONEY=WMONEY}
	printD("this is maingame name=%s,session=%s,SUNMONEY=%s,WMONEY=%s",name,session,SUNMONEY,WMONEY)
    local result1_2=sgoly_pack.encode(result)
    return result1_2
end

 --     记录中奖类型
    gamenum=0              --游戏次数
    modenum=5              --模式切换次数设置
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
	autopersentmax=0       --记录自动最高连续中奖次数
	automax=0              --最终最高连续中奖次数
	-- winmoney={}         --中奖金额
--主循环判断
function gamemain(fd,session,TYPE,end_point,beilv,k,MONEY,cost,name,propid)  --主游戏函数
    printD("I am %s",name)
 	moneydb=0          --赚得金额存数据库
	depositdb=0        --消耗金额存数据库
	n=1                --number1 的索引
	bo,y=sgoly_tool.getPlayModelFromRedis(name)
    x=y[2] 
    xsave=x            --1 为普通模式 2为困难模式 3为简单模式	
    printD("x=%d,%d,%d",x,y[1],y[2])
	winmoney={}         --中奖金额       
	printD("MONEY=%s,cost=%s",MONEY,cost)
	F3num=0
	prop=1
	if propid=="1" then
		prop=2
	end
	if propid=="2" then
		x=4
	end
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
	function  reqpack(wintype,type,grade,i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney,prop)
		wintype[type]=wintype[type]+1
		table.insert(number1,i)
		if TYPE=="autostart" or TYPE=="autogo" then 
			if automax==0  then
			    automax=1
				autopersentmax=1
		    else
		    	local s = #(autonumber1)
		    	if autonumber1[s]+1==tonumber(autonum) then
		    		autopersentmax=autopersentmax+1
		    		if autopersentmax>automax then
		    			automax=autopersentmax
		    		end
		    	else 
		    		autopersentmax=1
		    	end
		    end
		    table.insert(autonumber1,autonum)
		end
		table.insert(number2,type)
		table.insert(sequence,picture_order(type))
		printD("得分为 %s",end_point*beilv*grade*prop)
		money=money+end_point*beilv*grade*prop
		table.insert(winmoney,end_point*beilv*grade*prop)
		if TYPE=="autostart" or TYPE=="autogo" then 
			table.insert(automoney,end_point*beilv*grade*prop)
			if autowinmax<end_point*beilv*grade*prop then
			   autowinmax=end_point*beilv*grade*prop
			end
			autowinall=autowinall+end_point*beilv*grade*prop
		end
    end
 math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
for i=1,k do
	a=math.random(1,1000000)
	printD("-----------------------------")
	-- --------------普通模式---------------------
	if x==1 then
		printD("这是普通模式")
		local _, hit = sgoly_tool.hitAward(1, #normalS, a, normalS)
		if awardTypeAndRate[hit][1]=="F3" then
			if TYPE=="autostart" or TYPE=="autogo" then 
				printD("%s 没有中奖", i)
				table.insert(sequence,picture_order("NO"))
				printD("得分为 %s", end_point*beilv*0)
				money=money+end_point*beilv*0
				table.insert(winmoney,end_point*beilv*0)
				if TYPE=="autostart" or TYPE=="autogo" then 
					table.insert(automoney,end_point*beilv*0)
					if autowinmax<end_point*beilv*0 then
					   autowinmax=end_point*beilv*0
					end
					autowinall=autowinall+end_point*beilv*0
				end
		    else
				printD("%s 中奖类型FFF----O(∩_∩)O~~-!", i) 
				j=j+1
				wintype.F3=wintype.F3+1
				table.insert(number1,i)
				table.insert(number2,"F3")
				table.insert(sequence,picture_order("F3"))
				printD("得分为 %s",end_point*beilv*0)
				money=money+end_point*beilv*0
				table.insert(winmoney,end_point*beilv*0)
				F3num=F3num+1
			end			
	    elseif  awardTypeAndRate[hit][1]=="NO" then
			printD("没有中奖 %s", i)
			table.insert(sequence,picture_order("NO"))
			printD("得分为 %s",end_point*beilv*0)
			money=money+end_point*beilv*0
			table.insert(winmoney,end_point*beilv*0)
			if TYPE=="autostart" or TYPE=="autogo" then 
				table.insert(automoney,end_point*beilv*0)
				if autowinmax<end_point*beilv*0 then
				   autowinmax=end_point*beilv*0
				end
				autowinall=autowinall+end_point*beilv*0
			end
		else
			printD("%s 中奖类型%s----O(∩_∩)O~~-!", i,awardTypeAndRate[hit][1])
			j=j+1
	   		 reqpack(wintype,awardTypeAndRate[hit][1],awardTypeAndRate[hit][2],i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney,prop)
		end 
---------------------困难模式-----------------------	
	elseif  x==2   then
		printD("这是困难模式")
		local _, hit = sgoly_tool.hitAward(1, #difficultyS, a, difficultyS)
		if awardTypeAndRate[hit][1]=="F3" then
			if TYPE=="autostart" or TYPE=="autogo" then 
				printD("%s 没有中奖", i)
				table.insert(sequence,picture_order("NO"))
				printD("得分为 %s", end_point*beilv*0)
				money=money+end_point*beilv*0
				table.insert(winmoney,end_point*beilv*0)
				if TYPE=="autostart" or TYPE=="autogo" then 
					table.insert(automoney,end_point*beilv*0)
					if autowinmax<end_point*beilv*0 then
					   autowinmax=end_point*beilv*0
					end
					autowinall=autowinall+end_point*beilv*0
				end
		    else
				printD("%s 中奖类型FFF----O(∩_∩)O~~-!", i) 
				j=j+1
				wintype.F3=wintype.F3+1
				table.insert(number1,i)
				table.insert(number2,"F3")
				table.insert(sequence,picture_order("F3"))
				printD("得分为 %s",end_point*beilv*0)
				money=money+end_point*beilv*0
				table.insert(winmoney,end_point*beilv*0)
				F3num=F3num+1
			end			
	    elseif  awardTypeAndRate[hit][1]=="NO" then
			printD("没有中奖 %s", i)
			table.insert(sequence,picture_order("NO"))
			printD("得分为 %s",end_point*beilv*0)
			money=money+end_point*beilv*0
			table.insert(winmoney,end_point*beilv*0)
			if TYPE=="autostart" or TYPE=="autogo" then 
				table.insert(automoney,end_point*beilv*0)
				if autowinmax<end_point*beilv*0 then
				   autowinmax=end_point*beilv*0
				end
				autowinall=autowinall+end_point*beilv*0
			end
		else
			 printD("%s 中奖类型%s----O(∩_∩)O~~-!", i,awardTypeAndRate[hit][1])
			 j=j+1
	   		 reqpack(wintype,awardTypeAndRate[hit][1],awardTypeAndRate[hit][2],i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney,prop)
		end 
------------------------简单模式-----------------------------
	elseif x==3 then 
		printD("这是简单模式")
		local _, hit = sgoly_tool.hitAward(1, #simpleS, a, simpleS)
		if awardTypeAndRate[hit][1]=="F3" then
			if TYPE=="autostart" or TYPE=="autogo" then 
				printD("%s 没有中奖", i)
				table.insert(sequence,picture_order("NO"))
				printD("得分为 %s", end_point*beilv*0)
				money=money+end_point*beilv*0
				table.insert(winmoney,end_point*beilv*0)
				if TYPE=="autostart" or TYPE=="autogo" then 
					table.insert(automoney,end_point*beilv*0)
					if autowinmax<end_point*beilv*0 then
					   autowinmax=end_point*beilv*0
					end
					autowinall=autowinall+end_point*beilv*0
				end
		    else
				printD("%s 中奖类型FFF----O(∩_∩)O~~-!", i) 
				j=j+1
				wintype.F3=wintype.F3+1
				table.insert(number1,i)
				table.insert(number2,"F3")
				table.insert(sequence,picture_order("F3"))
				printD("得分为 %s",end_point*beilv*0)
				money=money+end_point*beilv*0
				table.insert(winmoney,end_point*beilv*0)
				F3num=F3num+1
			end			
	    elseif  awardTypeAndRate[hit][1]=="NO" then
			printD("没有中奖 %s", i)
			table.insert(sequence,picture_order("NO"))
			printD("得分为 %s",end_point*beilv*0)
			money=money+end_point*beilv*0
			table.insert(winmoney,end_point*beilv*0)
			if TYPE=="autostart" or TYPE=="autogo" then 
				table.insert(automoney,end_point*beilv*0)
				if autowinmax<end_point*beilv*0 then
				   autowinmax=end_point*beilv*0
				end
				autowinall=autowinall+end_point*beilv*0
			end
		else
			 printD("%s 中奖类型%s----O(∩_∩)O~~-!", i,awardTypeAndRate[hit][1])
			 j=j+1
	   		 reqpack(wintype,awardTypeAndRate[hit][1],awardTypeAndRate[hit][2],i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney,prop)
		end 
-----------------------------幸运模式--------------
 	elseif x==4 then 
		printD("这是幸运模式")
		local _, hit = sgoly_tool.hitAward(1, #luckyS, a, luckyS)
		if awardTypeAndRate[hit][1]=="F3" then
			if TYPE=="autostart" or TYPE=="autogo" then 
				printD("%s 没有中奖", i)
				table.insert(sequence,picture_order("NO"))
				printD("得分为 %s", end_point*beilv*0)
				money=money+end_point*beilv*0
				table.insert(winmoney,end_point*beilv*0)
				if TYPE=="autostart" or TYPE=="autogo" then 
					table.insert(automoney,end_point*beilv*0)
					if autowinmax<end_point*beilv*0 then
					   autowinmax=end_point*beilv*0
					end
					autowinall=autowinall+end_point*beilv*0
				end
		    else
				printD("%s 中奖类型FFF----O(∩_∩)O~~-!", i) 
				j=j+1
				wintype.F3=wintype.F3+1
				table.insert(number1,i)
				table.insert(number2,"F3")
				table.insert(sequence,picture_order("F3"))
				printD("得分为 %s",end_point*beilv*0)
				money=money+end_point*beilv*0
				table.insert(winmoney,end_point*beilv*0)
				F3num=F3num+1
			end			
	    elseif  awardTypeAndRate[hit][1]=="NO" then
			printD("没有中奖 %s", i)
			table.insert(sequence,picture_order("NO"))
			printD("得分为 %s",end_point*beilv*0)
			money=money+end_point*beilv*0
			table.insert(winmoney,end_point*beilv*0)
			if TYPE=="autostart" or TYPE=="autogo" then 
				table.insert(automoney,end_point*beilv*0)
				if autowinmax<end_point*beilv*0 then
				   autowinmax=end_point*beilv*0
				end
				autowinall=autowinall+end_point*beilv*0
			end
		else
			 printD("%s 中奖类型%s----O(∩_∩)O~~-!", i,awardTypeAndRate[hit][1])
			 j=j+1
	   		 reqpack(wintype,awardTypeAndRate[hit][1],awardTypeAndRate[hit][2],i,wintype,number1,autonumber1,autonum,number2,sequence,end_point,beilv,winmoney,automoney,prop)
		end 
	end
---------------------10次判断切换模式---------------------------
	historynum=historynum+1
	gamenum=gamenum+1
	moneydb=moneydb+money
	deposit=deposit+end_point*beilv
	-- if historynum%10==0 and money/deposit>=0.85 then
	if gamenum==modenum and money/deposit>=0.85 then
		x=2
		sgoly_tool.saveStatementsToRedis(name,0,0,0,0,0,0,0,x,os.date("%Y-%m-%d"))           
		printD("2 money[%s]/depost[%s]=[%s] 进入困难模式",money,deposit,money/deposit)
		money=0
		deposit=0
		gamenum=0
        if modenum==5 then 
        	modenum=10
        else
        	modenum=5
        end
	-- elseif historynum%10==0 and money/deposit<=0.5 then
	elseif gamenum==modenum and money/deposit<=0.5 then
		x=3
		sgoly_tool.saveStatementsToRedis(name,0,0,0,0,0,0,0,x,os.date("%Y-%m-%d")) 
		printD("3 money[%s]/depost[%s]=%s 进入简单模式",money,deposit,money/deposit)
		money=0 
		deposit=0
		gamenum=0
        if modenum==5 then 
        	modenum=10
        else
        	modenum=5
        end
	-- elseif historynum%10==0 and money/deposit<0.85 and money/deposit>0.5 then
	elseif gamenum==modenum and money/deposit<0.85 and money/deposit>0.5 then
		sgoly_tool.saveStatementsToRedis(name,0,0,0,0,0,0,0,x,os.date("%Y-%m-%d")) 
		printD("2 money[%s]/depost[%s]=%s 进入普通模式", money,deposit,money/deposit)
		money=0
		deposit=0
		gamenum=0
        if modenum==5 then 
        	modenum=10
        else
        	modenum=5
        end
	end
end  --for 循环end
-----------------------抽奖次数--------------------------
	-- printD("I am %s",name)
	-- printD("本轮F3中奖次数%d",F3num)
	historyj=historyj+j
	-- printD("本轮抽奖次数%d",k)
	-- printD("历史抽奖次数%d",historynum)
	-- printD("历史中奖次数%d",historyj)
	-- printD("本轮中奖次数%d",j)
	printD(
		[[
		name %s
		本轮F3中奖次数 %d
		本轮抽奖次数 %d
		历史抽奖次数 %d
		历史中奖次数 %d
		本轮中奖次数 %d
		]], name, F3num, k, historynum, historyj, j)

	for key,v in pairs(wintype) do
		if v~=0  then
			printD("中奖类型为 %s,中奖次数为 %s",key,v) 
		end
	end
------------------最高连续中奖次数-----------------------------	 
	persentmax=1    --记录最高连续中奖次数
	if  not number1[1] then
		max=0
		printD("最高连续中奖次数为 0")
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
		printD("最高连续中奖次数为 %d",max)
	end
----------------------------------------------------------
		for key,v in ipairs(number1) do
			printD("第%s次中奖,中奖类型为 %s",v,number2[key])
		end
---------------------最高连续不中奖次数-----------------------
    local houmian=0
	if not number1[1] then
			printD("最高连续不中奖次数为 %s", k)
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
			printD("最高连续不中奖次数为 %d,第 %d-%d 次", max-1, startnum,endnum)
	    else
	    	printD("最高连续不中奖次数为%d,第%d-%d次",houmian,endnum+1,k)
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
        printD("I am %s",name)
		printD("自动最高连续中奖次数为 %d",automax)
		automaxsave=automax
---------------------自动中奖最高金额---------------
				--    autowinmax
	---------------------自动获奖总金额----------------
	    printD("autowinall is %s",autowinall)
	-------------------------------------------------------
	    local autozjnum = #(autonumber1)
	    autozjnumsave=autozjnum
	    printD("autozjnum=%s",autozjnum)
        local bool1,req1=sgoly_tool.saveStatementsToRedis(name,autowinall,autocost,autonum,autozjnum,automax,autowinmax,0,x,os.date("%Y-%m-%d"))
        local bool2,req2=sgoly_tool.saveMoneyToRedis(name,MONEY)
        if bool1 and bool2 then
	        local who = "123456"
		    local resultauto={ID="4",SESSION=session,TYPE=TYPE,STATE=true,AUTONUM=autonum,SERIES=automax,WCOUNT=autozjnum,
		    MAXMONEY=autowinmax,SUNMONEY=autowinall,FINMONEY=MONEY}
		    printD("resultauto %s %s %s %s %s",resultauto.AUTONUM, resultauto.SERIES, resultauto.WCOUNT, resultauto.MAXMONEY, resultauto.SUNMONEY, resultauto.FINMONEY)
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
				autopersentmax=0
				automax=0
	        end
	        return resultat1_2
        else
        	local req5={SESSION=session,ID="4",STATE=false,TYPE=TYPE,MESSAGE="存档错误"}
			local req5_1=sgoly_pack.encode(req5)
			return req5_1
		end
    end
	return send_result(fd,session,TYPE,max,j,winmax,winall,nowMONEY,sequence,winmoney,name)
end

function CMD.calc(fd,session,TYPE,end_point,beilv,k,MONEY,cost,name,propid)
    if TYPE=="autogo" then
    	local checkup=sgoly_pack.checkup(end_point,beilv,k,cost)
		printI("checkup=%s",checkup)
		if checkup==true and tonumber(cost)<=tonumber(MONEY) then
            return gamemain(fd,session,TYPE,end_point,beilv,k,MONEY,cost,name,propid)
		elseif tonumber(cost)>tonumber(MONEY) then
			local req3={SESSION=session,ID="4",STATE=false,TYPE="autogo",MESSAGE="金币不足"}
			local req3_1=sgoly_pack.encode(req3)
			return req3_1
		else
			local req4={SESSION=session,ID="4",STATE=false,TYPE="autogo",MESSAGE="无效数据"}
			local req4_1=sgoly_pack.encode(req4)
			return req4_1
		end
    elseif TYPE=="gift" then
    	return gamemain(fd,session,TYPE,end_point,beilv,k,MONEY,cost,name,propid)
    elseif TYPE=="start" or TYPE=="autostart" then 
	    local bool,reallymoney=sgoly_tool.getMoney(name)
	    local checkup=sgoly_pack.checkup(end_point,beilv,k,cost)
	    printI("reallymoney=%s,checkup=%s",reallymoney,checkup)
	    if tonumber(reallymoney)==tonumber(MONEY) and checkup==true and tonumber(cost)<=tonumber(MONEY) then
		    return gamemain(fd,session,TYPE,end_point,beilv,k,MONEY,cost,name,propid)
		elseif tonumber(cost)>tonumber(MONEY) then
			local req2={SESSION=session,ID="4",STATE=false,TYPE=TYPE,MESSAGE="金币不足"}
			local req2_1=sgoly_pack.encode(req2)
			return req2_1
		else
			local req={SESSION=session,ID="4",STATE=false,TYPE=TYPE,MESSAGE="无效数据"}
			local req1=sgoly_pack.encode(req)
			return req1
		end
	
	elseif TYPE=="autoend" then
	    return gamemain(fd,session,TYPE,end_point,beilv,k,MONEY,cost,name,propid)
	else
		local req5={SESSION=session,ID="4",STATE=false,TYPE=="autoend",MESSAGE="参数错误"}
		local req5_1=sgoly_pack.encode(req5)
		return req5_1
	end
end

function CMD.autosave(fd,name)
	printD("autosave自动最高连续中奖次数为 %d",automax)
	automaxsave=automax
---------------------自动中奖最高金额---------------
				--autowinmax
	local autozjnum = #(autonumber1)
	local autozjnumsave=autozjnum
		  printD("autozjnum=%s", autozjnum)
   	local d=os.time()-3600*24
	local c=os.date("%Y-%m-%d",d)
    local bool,req=sgoly_tool.getMoney(name)
    local money=tonumber(req)+autowinall-autocost
    printD("this is name=%s,req=%d,autowinall=%d,autocost=%d",name,req,autowinall,autocost)
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
    autopersentmax=0
    automax=0
	if bo1 and  bo2  then
		return "suss"
	else 
		return "false"
	end
end

function CMD.exit()
	skynet.exit()
end

function CMD.get()
	_, awardTypeAndRate = sgoly_tool.awardTypeAndRate()
	 _, normalS, simpleS, difficultyS ,luckyS= sgoly_tool.getSpaceFromRedis()
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
	 -- _, awardTypeAndRate = sgoly_tool.awardTypeAndRate()
	 -- _, normalS, simpleS, difficultyS = sgoly_tool.getSpaceFromRedis()
    -- 要注册个服务的名字，以.开头
    --skynet.register(".maingame")
end)
 