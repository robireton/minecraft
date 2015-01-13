#!/bin/sh
if [ -e ~/Minecraft/servers/$1/minecraft_server.jar ]; then
	cd ~/Minecraft/servers/$1
	java -Xms2G -Xmx6G -jar minecraft_server.jar nogui
fi
