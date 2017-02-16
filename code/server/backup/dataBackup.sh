#!/bin/bash
user=root # 数据库用户名
password=toor # 数据库密码
database=lua # 数据库名称
email=641570479@qq.com # 管理员邮箱地址
backup_dir=/var/sgoly_backups # 备份文件路径
log_file=$backup_dir/dataBackup.log # 日志文件路径
DATE=` date +%Y%m%d%H%M%S ` # 日期格式
backup_file=$DATE.sql.gz # 压缩文件名

#判断备份文件存储目录是否存在，否则创建该目录
if [ ! -d $backup_dir ] ;
then
	sudo mkdir -p $backup_dir
fi

cd $backup_dir

# 开始备份之前,将备份信息头写入日志文件
echo "">>$log_file
echo "">>$log_file
echo "------------------------------------------------">>$log_file
echo "backup date:"$(date +"%y-%m-%d %H:%M:%S")>>$log_file
echo "------------------------------------------------">>$log_file

mysqldump -u$user -p$password $database | gzip >$backup_file
if [[ $? == 0  ]];
then
    echo "[$backup_file] backup successful!">>$log_file
    echo "backup process done">>$log_file
else
    echo "[$backup_file] backup fail.">>$log_file
    # 备份失败后向管理员发送邮件提醒, 需要 mailutils 或类似的终端下发送邮件工具的支持
    # mail -s "database: $database backup fail." $email
fi

