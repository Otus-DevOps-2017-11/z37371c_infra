# z3t3t1c_infra

## Homework 07
Q: Rework packer template so that user-defined variables will be used.  
A: Template ubuntu16.json is written in the way that user variables are requred to build an image. Use packer/variables.json.example as a sample.  
   
Q: Investigate another builder options for GCP.  
A: Additional options are used within template packer/ubuntu16.json.   
   
Q: Create backed image so that reddit application will start automatically when instance is created.  
A: Packer template for backed image is packer/immutable.json. Configuration and deployment scripts are available at packer/scripts.   
Systemd unit definition is located at packer/puma.service.   
 
Q: Create script to start instance using the image prepared in previous step.  
A: Script is located at config-scripts/deploy-reddit-vm.sh   
  
## Homework 06
Q: Create bash scripts for installation of Ruby, MongoDB and deployment of the reddit-app. Commit scripts with executable permissions.  
A: Please find install_ruby.sh, install_mongodb.sh and deploy.sh respectively.

Q: Based on previous task, make one startup script and provide gcloud command to create an instance.  
A: Startup script named startup.sh. Command specified below:
```bash
gcloud compute instances create reddit-app \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --zone europe-west1-b \
  --metadata startup-script-url="https://raw.githubusercontent.com/Otus-DevOps-2017-11/z37371c_infra/Infra-2/startup.sh"
```
After instance being created, you can check startup script output as following (replace project id with your own one):
```bash
gcloud compute --project=infra-189307 \  
  instances \ 
  get-serial-port-output \ 
  reddit-app \
  --zone europe-west1-b | \
  grep startup-script
```

## Homework 05
1/
Q: One-line command to connect to internal host?
```bash
ssh -A -t appuser@35.205.38.154 ssh appuser@10.132.0.3
```

Q: Propose solution to connect to internal host using alias, e.g. "ssh internalhost" 
A: Add following lines to ~/.ssh/config then run "ssh internalhost":
```bash
Host bastion
Hostname 35.205.38.154
User appuser

Host internalhost
User appuser
ProxyCommand ssh -q bastion nc -q0 10.132.0.3 22
```
2/
Files otus_test_bastion.ovpn and setupvpn.sh are placed into repository.  

3/
Host bastion: external IP 35.205.38.154, internal IP 10.132.0.2  
Host someinternalhost: internal IP 10.132.0.3



