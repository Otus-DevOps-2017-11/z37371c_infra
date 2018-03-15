# z3t3t1c_infra

## Homework 12
Q: Move playbooks into different roles, describe two environments, use nginx community role.  

A: I have performed all the tasks with no issues. Created separate app and db roles, created prod and stage environments and installed nginx community role.

## Homework 11
Q: Try different approaches on how to use ansible: single playbook with single play, single playbook with multiple plays, multiple playbooks. Familiarize yourself with tasks, handlers, templates and variables. Know how to use modules and cycles.  
A: I have followed the instruction and performed all requred tasks without any issues. Before proceeding with this homework I commented out terraform provisioners in order to get clean environment.

Q: Research dynamic inventory capabilities for GCP.   
A: I used gce.py to generate inventory. I met minor issues with package versions before being able to run gce.py successfully. On CentOS 7 I had to uninstall gssapi package and install python2-crypto afterwards.   

```bash
~/z37371c_infra/ansible > ansible all -m ping -i inv/
stage-reddit-db | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
stage-reddit-app | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}

```

I also reviewed dynamic inventory realizations based on terraform. All of them require addtional step - tags to be assigned to the machines.

Q: Amend Packer provisioners.  
A: I succsessfully changed provisioners with Ansible ones and used dynamic inventory to run playbook. 
<details>
  <summary>Click to see example of Packer output</summary>

```bash
 ~/z37371c_infra > /home/zetetic/bin/packer build -var-file=packer/variables.json  packer/app.json 
googlecompute output will be in this color.

==> googlecompute: Checking image does not exist...
==> googlecompute: Creating temporary SSH key for instance...
==> googlecompute: Using image: ubuntu-1604-xenial-v20180222
==> googlecompute: Creating instance...
    googlecompute: Loading zone: europe-west1-b
    googlecompute: Loading machine type: f1-micro
    googlecompute: Requesting instance creation...
    googlecompute: Waiting for creation operation to complete...
    googlecompute: Instance has been created!
==> googlecompute: Waiting for the instance to become running...
    googlecompute: IP: 35.195.46.204
==> googlecompute: Waiting for SSH to become available...
==> googlecompute: Connected to SSH!
==> googlecompute: Provisioning with Ansible...
==> googlecompute: Executing Ansible: ansible-playbook --extra-vars packer_build_name=googlecompute packer_builder_type=googlecompute -i /tmp/packer-provisioner-ansible128343860 /home/zetetic/z37371c_infra/ansible/packer_app.yml --private-key /tmp/ansible-key521614057
    googlecompute:
    googlecompute: PLAY [Install Ruby and Bundler] ************************************************
    googlecompute:
    googlecompute: TASK [Gathering Facts] *********************************************************
    googlecompute: ok: [default]
    googlecompute:
    googlecompute: TASK [Update cache] ************************************************************
    googlecompute: changed: [default]
    googlecompute:
    googlecompute: TASK [Install Ruby and Bundler] ************************************************
    googlecompute: changed: [default] => (item=[u'ruby-full', u'ruby-bundler', u'build-essential'])
    googlecompute:
    googlecompute: PLAY RECAP *********************************************************************
    googlecompute: default                    : ok=3    changed=2    unreachable=0    failed=0
    googlecompute:
==> googlecompute: Deleting instance...
    googlecompute: Instance has been deleted!
==> googlecompute: Creating image...
==> googlecompute: Deleting disk...
    googlecompute: Disk has been deleted!
Build 'googlecompute' finished.

==> Builds finished. The artifacts of successful builds are:
--> googlecompute: A disk image was created: reddit-app-base-1519830198
```
</details>

<details>
  <summary>Click to see example of Ansible output</summary>

```bash
~/z37371c_infra/ansible > ansible-playbook -i inv/ site.yml 
[DEPRECATION WARNING]: 'include' for playbook includes. You should use 'import_playbook' instead. This feature will be removed in version 2.8. Deprecation warnings can be disabled by 
setting deprecation_warnings=False in ansible.cfg.

PLAY [Configure MongoDB] *********************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [stage-reddit-db]

TASK [Change mongo config file] **************************************************************************************************************************************************************
changed: [stage-reddit-db]

RUNNING HANDLER [restart mongod] *************************************************************************************************************************************************************
changed: [stage-reddit-db]

PLAY [Configure App] *************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [stage-reddit-app]

TASK [Add unit file for Puma] ****************************************************************************************************************************************************************
changed: [stage-reddit-app]

TASK [Add config for DB connection] **********************************************************************************************************************************************************
changed: [stage-reddit-app]

TASK [enable puma] ***************************************************************************************************************************************************************************
changed: [stage-reddit-app]

RUNNING HANDLER [reload puma] ****************************************************************************************************************************************************************
changed: [stage-reddit-app]

PLAY [Deploy App] ****************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [stage-reddit-app]

TASK [Fetch the latest version of application code] ******************************************************************************************************************************************
changed: [stage-reddit-app]

TASK [bundle install] ************************************************************************************************************************************************************************
changed: [stage-reddit-app]

RUNNING HANDLER [restart puma] ***************************************************************************************************************************************************************
changed: [stage-reddit-app]

PLAY RECAP ***********************************************************************************************************************************************************************************
stage-reddit-app           : ok=9    changed=7    unreachable=0    failed=0   
stage-reddit-db            : ok=3    changed=2    unreachable=0    failed=0  
```
</details>



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



