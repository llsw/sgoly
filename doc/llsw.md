github帐号:llsw
github密码:lkgame123

--------------------------------------------------------

			获取仓库
步骤1 克隆总仓库:
git clone https://github.com/llsw/sgoly.git

步骤2 克隆子模块
git submodule update --init --recursive

---------------------------------------------------------

			修改
修改之前选择开发版分支:

git checkout dev

修改代码后提交命令:
git add .

git commit -m "修改说明"

git push origin dev
---------------------------------------------------------

			获取更新

获取最新开发版代码:
git checkout dev
git pull origin dev

---------------------------------------------------------


---------------------------------------------------------
		
			服务端说明

获取仓库，先择好开发版后记得编译skynet
运行一个节点的命令例子:
先cd进skynet目录,然后 
./skynet ../cluster_database/config/config

---------------------------------------------------------

虚拟机用户名:interface
密码:lkgame123
sudo密码:lkgame123

共享文件夹:\\192.168.80.211\interface
用户名:interface
密码:lkgame123

ssh连接命令: ssh interface@192.168.80.211

数据库帐号:interface
密码:627795061

redis密码：123456