#!/bin/sh

#DATE=`/bin/date`
#OK_MIDNIGHT=`/nas/iot/time_window -golden "midnight" `
#OK_NOON=`/nas/iot/time_window -golden "noon" `
#if [ "$OK_MIDNIGHT" = "1" ]; then
#	sudo systemctl stop mumudvb
#
#	sudo /nas/iot/startup/startup_rc.sh "midnight"
#	sudo /nas/iot/bt_led/exe_bt_led
#elif [ "$OK_NOON" = "1" ]; then
#
#	sudo /nas/iot/startup/startup_rc.sh "noon"
#	sudo /nas/iot/bt_led/exe_bt_led
#else
#
#	sudo /nas/iot/startup/startup_rc.sh "\"Other time: $DATE\""
#	sudo /nas/iot/bt_led/exe_bt_led
#fi
