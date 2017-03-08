#!/bin/bash
cp ./lualib/sgoly_service_config.bak ./lualib/sgoly_service_config.lua
git pull origin dev
cp ./lualib/sgoly_service_config.bak2 ./lualib/sgoly_service_config.lua