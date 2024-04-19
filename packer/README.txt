 Note: packer
 
 if you have no custom image to filter use cmd ( # mv datasource.pkr.hcl datasource.pkr.hcl-bp ) then modify variable file as per need and run start commands
 
 if you have AMI already created modify the datasource.pkr.hcl to filter or sort the required
 
 
 start commands
 
 # packer init .
 
 # packer validate .
 
 # packer build .

