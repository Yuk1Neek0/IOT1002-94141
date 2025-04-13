#!/bin/bash

# 1. Get a list of users in the IT group
IT_GROUP="IT"  # Define the group name for IT users
IT_USERS=$(getent group "$IT_GROUP" | cut -d: -f4 | tr ',' ' ')  # Retrieve users in the IT group

# 2. Loop through each IT user and create iptables rules to allow HTTPS (port 443)
for USER in $IT_USERS; do
  echo "Allowing HTTPS access for user: $USER"
  sudo iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner "$USER" -j ACCEPT
done

# 3. Create a rule to allow the local web server (192.168.2.3)
echo "Allowing access to the local web server (192.168.2.3)"
sudo iptables -A OUTPUT -p tcp --dport 443 -d 192.168.2.3 -j ACCEPT

# 4. Add rules to block specific ports (8003 and 1979)
echo "Blocking access to ports 8003 and 1979"
sudo iptables -t filter -A OUTPUT -p tcp --dport 8003 -j DROP
sudo iptables -t filter -A OUTPUT -p tcp --dport 1979 -j DROP

# 5. Show the message with the number of IT users granted access
IT_USER_COUNT=$(echo "$IT_USERS" | wc -w)
echo "$IT_USER_COUNT users were granted internet access."

# 6. End of the script
exit 0