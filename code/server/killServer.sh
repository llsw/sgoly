#!/bin/bash

ps -ef | grep skynet | grep -v grep | awk '{cmd="kill " $2;print cmd;system(cmd)}'