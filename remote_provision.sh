#!/bin/bash

yum update -y

# Change the bass ssh config file...
# config file:	/etc/ssh/sshd_config
# option:  		PasswordAuthentication from no to yes;
#PasswordAuthentication yes
#PasswordAuthentication no
# restart service 
# TARGET_KEY="PasswordAuthentication"
# REPLACEMENT_VALUE="yes"
# CONFIG_FILE="/etc/ssh/sshd_config"
# TEST_CONFIG_SET="$TARGET_KEY $REPLACEMENT_VALUE"

# if [ ! "$(sudo grep '^$TEST_CONFIG_SET"' $CONFIG_FILE | grep -v grep)" ] ; then
# 	sed --copy --in-place "s/\(^${TARGET_KEY}\).*/${REPLACEMENT_VALUE}/" "${CONFIG_FILE}"
# 	service sshd restart
# fi


TARGET_KEY="PasswordAuthentication no"
REPLACE_WITH="PasswordAuthentication yes"
CONFIG_FILE="/etc/ssh/sshd_config"

if [ ! $(/usr/bin/grep "^${REPLACE_WITH}" "${CONFIG_FILE}") ]; then
	sed --copy --in-place "s/\(^${TARGET_KEY}\).*/${REPLACE_WITH}/" "${CONFIG_FILE}" 
	service sshd restart
fi
