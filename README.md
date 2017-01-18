# sgoly
---------------------------------------------------------  
##获取仓库  
1.克隆总仓库:
```Bash  
git clone https://github.com/llsw/sgoly.git
```

2.克隆子模块
```Bash
cd sgoly  
git submodule update --init --recursive  
```

##修改  
1.修改之前选择开发版分支:
```Bash  
git checkout dev
```  
2.修改代码后提交命令:
```Bash  
git add file_name
git commit -m "修改说明"  
git push origin dev  
```
##获取更新  
###获取最新开发版代码:
```Bash  
git checkout dev  
git pull origin dev  
```
##服务端说明  
获取仓库，先择好开发版后记得编译skynet  
###运行一个节点的命令例子:  
```Bash
cd code/server/skynet
./skynet ../cluster_database/config/config  
```
##note  
我虚拟机的IP192.168.100.243  