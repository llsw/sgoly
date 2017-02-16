gnome-terminal -x bash -c "cd skynet && ./skynet ../cluster_database/config/config" &
sleep 5
gnome-terminal -x bash -c "cd skynet && ./skynet ../cluster_login/config/config" &
sleep 1
gnome-terminal -x bash -c "cd skynet && ./skynet ../cluster_game/config/config" &
sleep 1
gnome-terminal -x bash -c "cd skynet && ./skynet ../cluster_gateway/config/config" &
sleep 1
gnome-terminal -x bash -c "cd skynet && ./skynet ../cluster_rank/config/config" &
sleep 1
gnome-terminal -x bash -c "/home/lyc/sgork/ngrok -config=/home/lyc/sgork/ngrok.cfg start sgoly" 
# gnome-terminal -x bash -c "./3rd/lua/lua sprj/client/sclient.lua" &
# gnome-terminal -x bash -c "./3rd/lua/lua sprj/client/sclient.lua" &
# gnome-terminal -x bash -c "./3rd/lua/lua sprj/client/sclient.lua" &
# gnome-terminal -x bash -c "./3rd/lua/lua sprj/client/sclient.lua" &
# gnome-terminal -x bash -c "./3rd/lua/lua sprj/client/sclient.lua" &
# gnome-terminal -x bash -c "./3rd/lua/lua sprj/client/sclient.lua" &