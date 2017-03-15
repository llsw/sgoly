#!/bin/bash
cp ./lualib/sgoly_service_config.bak ./lualib/sgoly_service_config.lua
git pull origin dev
cp ./lualib/sgoly_service_config.bak2 ./lualib/sgoly_service_config.lua
echo -e "serverclose\n" | nc 127.0.0.1 18002
echo -e "auth lkgame123\nsave\n" | redis-cli
./killServer.sh
./7002_start.sh