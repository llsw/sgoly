gnome-terminal --geometry 70x33+47--10 -x bash -c "cd skynet && ./skynet ../cluster_database/config/config" &
sleep 5

gnome-terminal --geometry 70x33+47--10 -x bash -c "cd skynet && ./skynet ../cluster_login/config/config" &
sleep 1

gnome-terminal --geometry 70x33+47--10 -x bash -c "cd skynet && ./skynet ../cluster_rank/config/config" &
sleep 1

gnome-terminal --geometry 70x33+47--10 -x bash -c "cd skynet && ./skynet ../cluster_game/config/config" &
sleep 1

gnome-terminal --geometry 70x33+47--10 -x bash -c "cd skynet && ./skynet ../cluster_gateway/config/config" &
sleep 1

gnome-terminal --geometry 70x33+47--10 -x bash -c "/home/interface/ngrok/iosuzy_ngrok/linux/ngrok -config=/home/interface/ngrok/iosuzy_ngrok/linux/ngrok.cfg start sgoly2" &
sleep 2
