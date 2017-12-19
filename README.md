1/ 
Q: One-line command to connect to internal host?
A: ssh -A -t appuser@35.205.38.154 ssh appuser@10.132.0.3

Q: Propose solution to connect to internal host using alias, e.g. "ssh internalhost" 
A: Add following lines to ~/.ssh/config then run "ssh internalhost":
Host bastion
Hostname 35.205.38.154
User appuser

Host internalhost
User appuser
ProxyCommand ssh -q bastion nc -q0 10.132.0.3 22

2/
Files otus_test_bastion.ovpn and setupvpn.sh are placed into repository.

3/
Host bastion: external IP 35.205.38.154, internal IP 10.132.0.2
Host someinternalhost: internal IP 10.132.0.3



