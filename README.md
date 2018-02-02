# z3t3t1c_infra

## Homework 10
Q: Install ansible, create configuration and inventory files. Try using different modules.  
A: I have installed ansible and executed all the tasks within homework. No issues occured.  

Q: Task * (json inventory)  
A: I used simple python script to read [ansible/inventory.json](ansible/inventory.json) and output its contents. See [ansible/inventory.py](ansible/inventory.py) for details.
```bash
$> ansible all -m ping -i inventory.py 
appserver | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
dbserver | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```

## Homework 09
Q: Set of common tasks:  
  1. Remove main.tf, outputs.tf, terraform.tfvars, variables.tf from terraform folder.  
  2. Add new parameters in modules at your own choice.  
  3. Format configuration files using terraform fmt.  

A: All requested operations were performed. I have added parameter "prefix" to distinguish stage and prod environment. There could be more parameters used but I just avoided making them for the sake of time.  
I used different regions to start both environments simultaneously because europe-west1 has limit of 1 static IP:
```bash
* google_compute_address.app_ip: Error creating address: googleapi: Error 403: Quota 'STATIC_ADDRESSES' exceeded. Limit: 1.0 in region europe-west1., quotaExceeded

```

Q: Task * (Remote Backends)  
A: I have created gcs bucket named "terraform-state-remote-backend" and used prod and stage prefixes respectively to keep state for two environments. Refer to [terraform/prod/main.tf](terraform/prod/main.tf) and [terraform/stage/main.tf](terraform/stage/main.tf) for details.  
When trying to do terraform apply on configuration already being deployed I observed lock as following:
```bash
Error: Error loading state: writing "gs://terraform-state-remote-backend/prod/default.tflock" failed: googleapi: Error 412: Precondition Failed, conditionNotMet
Lock Info:
  ID:        8aad7906-8917-bb00-2b8c-692fc18b6307
  Path:      
  Operation: OperationTypeApply
  Who:       zetetic@sun
  Version:   0.11.1
  Created:   2018-01-31 14:03:57.574645559 +0000 UTC
  Info:
```
Q: Task * (Provisioners)  
A: I used template to update systemd unit file with env variable $DATABASE_URL. See [terraform/modules/app/main.tf](terraform/modules/app/main.tf) and [terraform/modules/app/files/puma.service.tpl](terraform/modules/app/files/puma.service.tpl) for details. To set MongoDB binding address I used remote_exec with inline option, see [terraform/modules/db/main.tf](terraform/modules/db/main.tf).

## Homework 08
Q: Set of common tasks:  
  1. Define input variable for private key.  
  2. Define input variable for setting zone.  
  3. Format all files using terraform fmt.  
  4. Provide terraform.tfvars.example.  

A: All requested tasks were performed, see [terraform/main.tf](terraform/main.tf), [terraform/variables.tf](terraform/variables.tf) and [terraform/terraform.tfvars.example](terraform/terraform.tfvars.example)  

Q: Task * (SSH keys)  
A: See [terraform/main.tf](terraform/main.tf). Problem I've found it that after 'terraform apply' all keys set via web-interface will be lost.  

Q: Task ** (Load-Balancing)  
A: Instances defined using count, see [terraform/main.tf](terraform/main.tf). Load-balancing specific resources defined within [terraform/lb-http.tf](terraform/lb-http.tf).   


## Homework 07
Q: Rework packer template so that user-defined variables will be used.  
A: Template [packer/ubuntu16.json](/packer/ubuntu16.json) is written in the way that user variables are requred to build an image. Use packer/variables.json.example as a sample.  
   
Q: Investigate another builder options for GCP.  
A: Additional options are used within template [packer/ubuntu16.json](/packer/ubuntu16.json).   
   
Q: Create backed image so that reddit application will start automatically when instance is created.  
A: Packer template for backed image is packer/immutable.json. Configuration and deployment scripts are available at [packer/scripts](packer/scripts). Systemd unit definition is located at [packer/files/puma.service](packer/files/puma.service).    

Q: Create script to start instance using the image prepared in previous step.  
A: Script is located at [config-scripts/create-reddit-vm.sh](config-scripts/create-reddit-vm.sh)   
  
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



