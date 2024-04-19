 
 source "amazon-ebs" "zomato-prod" {
 
    region     = var.region
    ami_name   = local.image_name
    source_ami = var.ami_id
#    source_ami = data.amazon-ami.zomato.id
    instance_type = var.instance_type
    ssh_username  = "ubuntu"
    tags       = {
                  Name    = local.image_name
                  project = var.project_name
                  env     = var.project_env
                  }
  }
  
  build {
    sources =  [ "source.amazon-ebs.zomato-prod" ]
    provisioner "shell" {
      script = "startup.sh"
      execute_command = "sudo {{.Path}}"
      }
  }
