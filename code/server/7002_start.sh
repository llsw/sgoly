#!/bin/bash
cd /root/sgoly/code/server/skynet && nohup ./skynet ../cluster_database/config/config > /root/log/database.log &
sleep 5
cd /root/sgoly/code/server/skynet && nohup ./skynet ../cluster_login/config/config > /root/log/login.log &
sleep 1
cd /root/sgoly/code/server/skynet && nohup ./skynet ../cluster_game/config/config > /root/log/game.log &
sleep 1
cd /root/sgoly/code/server/skynet && nohup ./skynet ../cluster_gateway/config/config > /root/log/gateway.log &
sleep 1
cd /root/sgoly/code/server/skynet && nohup ./skynet ../cluster_rank/config/config > /root/log/rank.log &
sleep 1
