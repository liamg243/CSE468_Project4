#CLEAR PREEXISTING RULES
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP
######

#ENABLES CLIENT TO ACCESS SERVER HOSTED WEBSITE FROM 192.168.0.100
sudo iptables -A INPUT -i enp0s3 -p tcp -j ACCEPT
sudo iptables -A INPUT -i enp0s8 -p tcp -j ACCEPT

sudo iptables -A FORWARD -i enp0s3 -o enp0s8 -p tcp --dport 80 -j ACCEPT
sudo iptables -A FORWARD -i enp0s3 -o enp0s8 -p tcp -j ACCEPT
sudo iptables -A FORWARD -i enp0s8 -o enp0s3 -p tcp -j ACCEPT

sudo iptables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 80 -j DNAT --to-destination 10.0.0.10
sudo iptables -t nat -A POSTROUTING -o enp0s8 -p tcp --dport 80 -d 10.0.0.10 -j SNAT --to-source 10.0.0.100
######

#ENABLES CLIENT TO PING SERVER AND SERVER TO PING CLIENT AND SERVER TO PING GATEWAY
sudo iptables -A INPUT -i enp0s3 -p icmp -j ACCEPT
sudo iptables -A INPUT -i enp0s8 -p icmp -j ACCEPT

sudo iptables -A FORWARD -i enp0s3 -o enp0s8 -p icmp -j ACCEPT
sudo iptables -A FORWARD -i enp0s8 -o enp0s3 -p icmp -j ACCEPT

sudo iptables -t nat -A PREROUTING -i enp0s3 -p icmp -j DNAT --to-destination 10.0.0.10
sudo iptables -t nat -A POSTROUTING -o enp0s8 -p icmp -d 10.0.0.10 -j SNAT --to-source 10.0.0.100

sudo iptables -A OUTPUT -o enp0s8 -p icmp -j ACCEPT
sudo iptables -A OUTPUT -o enp0s3 -p icmp -j ACCEPT
######

#ALLOWS CLIENT AND SERVER TO CONNECT TO INTERNET AND PING 8.8.8.8
sudo iptables -A INPUT -i enp0s9 -p icmp -j ACCEPT

sudo iptables -A FORWARD -i enp0s3 -o enp0s9 -p icmp -j ACCEPT
sudo iptables -A FORWARD -i enp0s8 -o enp0s9 -p icmp -j ACCEPT

sudo iptables -t nat -A POSTROUTING -o enp0s9 -p icmp -j MASQUERADE

sudo iptables -A OUTPUT -o enp0s9 -p icmp -j ACCEPT
#######

#ENABLES CLIENT TO SSH INTO SERVER FROM 192.168.0.100
sudo iptables -A FORWARD -i enp0s3 -o enp0s8 -p tcp --dport 22 -j ACCEPT

sudo iptables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 22 -j DNAT --to-destination 10.0.0.10
sudo iptables -t nat -A POSTROUTING -o enp0s8 -p tcp --dport 22 -d 10.0.0.10 -j SNAT --to-source 10.0.0.100
######

#ENABLES CLIENT TO FTP INTO SERVER FROM 192.168.0.100
sudo iptables -A FORWARD -i enp0s3 -o enp0s8 -p tcp --dport 21 -j ACCEPT

sudo iptables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 21 -j DNAT --to-destination 10.0.0.10
sudo iptables -t nat -A POSTROUTING -o enp0s8 -p tcp --dport 21 -d 10.0.0.10 -j SNAT --to-source 10.0.0.100
######
