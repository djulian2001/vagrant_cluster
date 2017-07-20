#!/bin/bash
UAPPNAME="$1"							# pulled from vagrant config.yaml file
SSHPASS="$2"							# pulled from vagrant config.yaml file
REMOTE_BASE_IP="$3"						# pulled from vagrant config.yaml file
REMOTE_BASE_IP=${REMOTE_BASE_IP%\%*}
REMOTE_NUMBER_OF_HOSTS="$4"				# set in the Vagrantfile
ZERO="0"

/bin/echo "INSTALL YUM REPO ....."
# enable epel
sudo yum -y install epel-release
sudo yum --enablerepo=epel -y install epel-release

/bin/echo "INSTALL BOOTSTRAP Dependencies ....."
sudo yum install -y sshpass git
sudo yum update -y

/bin/echo "CREATE RSA KEY and SETUP SSH ....."
if [ ! -f "/home/$UAPPNAME/.ssh/cluster_rsa.pub" ]; then
	if [ ! -d "/home/$UAPPNAME/.ssh" ]; then
		mkdir -p /home/$UAPPNAME/.ssh
 	fi
	ssh-keygen -b 2048 -t rsa -f "/home/$UAPPNAME/.ssh/cluster_rsa" -q -N "" -C "manage_node@$REMOTE_BASE_IP$ZERO"  && \
	/bin/echo "IdentityFile /home/$UAPPNAME/.ssh/cluster_rsa" >> "/home/$UAPPNAME/.ssh/config" && \
	chown $UAPPNAME:$UAPPNAME -R "/home/$UAPPNAME/.ssh" && \
	chmod 600 "/home/$UAPPNAME/.ssh/config"
fi


# not safe lets us an env variable
/bin/echo "RSA KEY COPY TO REMOTE NODES ....."
export SSHPASS="$SSHPASS" 
for i in $(seq 1 $REMOTE_NUMBER_OF_HOSTS); do
	REMOTE_IP="$REMOTE_BASE_IP$i" 
	cat "/home/$UAPPNAME/.ssh/cluster_rsa.pub" | sshpass -e ssh -y -o StrictHostKeyChecking=no "$UAPPNAME@$REMOTE_IP" "cat >> ~/.ssh/authorized_keys" 
	sshpass -e ssh -y "$UAPPNAME@$REMOTE_IP" "chmod 600 ~/.ssh/authorized_keys"
	/bin/echo "$REMOTE_IP"
done
