### XanLean CS:GO Jailbreak startup script; Benjamín Morozov 2020 ###
for (( ; ; ))
do
   ./srcds_run -console -game csgo -usercon -nobreakpad +hostport 27015 -maxplayers_override 23 +game_type 3 +game_mode 0 +map jb_obama_v5_beta +sv_setsteamaccount 5873EEE53830331AF837C0ED73A87B3B -tickrate 128 -autoupdate -steam_dir ~/.steam/steamcmd -steamcmd_script autoupdate.txt
   sleep 1
   if (disaster-condition)
   then
	break       	   #Abandon the loop.
   fi
done

: ' ### XanLean CS:GO Jailbreak startup script; Benjamín Morozov 2020 ###
for (( ; ; ))
do
   ./srcds_run -console -game csgo -usercon -nobreakpad +ip 89.203.250.27 +hostport 27015 -maxplayers_override 23 +game_type 3 +game_mode 0 +map jb_obama_v5_beta +sv_setsteamaccount 48273C2708530D8EDB2F3CB8D2F33986 -tickrate 128
   sleep 1
   if (disaster-condition)
   then
	break       	   #Abandon the loop.
   fi
done '
