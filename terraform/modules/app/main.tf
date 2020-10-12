# Instance for Application
resource "aws_instance" "web_instance" {
  ami                    = lookup(var.ec2_images, var.aws_region)
  instance_type          = var.web_instance_type
  key_name               = var.instance_access_private_key
  vpc_security_group_ids = [var.sec_grp_id]
  subnet_id              = var.pub_subnet_id
  tags = {
    Name = "${(var.cluster_name)}_${(var.env_name)}_web_instance"
  }
  volume_tags = {
    Name = "${(var.cluster_name)}_${(var.env_name)}_web_instance_volume"
  }
  provisioner "file" {
    source      = "../ansible"
    destination = "/tmp"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-add-repository -y ppa:ansible/ansible",
      "sudo apt -y update",
      "sudo apt -y aptitude",
      "sudo apt -y install ansible",
      "mv /tmp/ansible ~/",
      "cd ~/ansible",
      "sudo ansible-playbook site.yml --tags docker --extra-vars \"docker_user=${(var.docker_user)} docker_pwd=${(var.docker_pwd)} env_name=${(var.env_name)} public_ip=${(self.public_ip)}\""
    ]
    # Use "webapp" as a tags for instal Tomcat, Postgrsql, and Buil dependencies for web_app_instance
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = ""
    host        = self.public_ip
    private_key = file(var.private_key_ec2)
  }
}

# Instance for Jenkins
resource "aws_instance" "docker_instance" {
  ami                    = lookup(var.ec2_images, var.aws_region)
  instance_type          = var.docker_instance_type
  key_name               = var.instance_access_private_key
  vpc_security_group_ids = [var.sec_grp_id]
  subnet_id              = var.pub_subnet_id
  tags = {
    Name = "${(var.cluster_name)}_${(var.env_name)}_docker_instance"
  }
  volume_tags = {
    Name = "${(var.cluster_name)}_${(var.env_name)}_docker_instance_volume"
  }
  provisioner "file" {
    source      = "../ansible"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-add-repository -y ppa:ansible/ansible",
      "sudo apt -y update",
      "sudo apt -y aptitude",
      "sudo apt -y install ansible",
      "mv /tmp/ansible ~/",
      "cd ~/ansible",
      "sudo ansible-playbook site.yml --tags docker --extra-vars \"docker_user=${(var.docker_user)} docker_pwd=${(var.docker_pwd)} env_name=${(var.env_name)} public_ip=${(self.public_ip)}\""
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = ""
    host        = self.public_ip
    private_key = file(var.private_key_ec2)
  }

}

# Generating file with instance addresses (only for information)

resource "local_file" "tf_ansible_vars_file_new" {
  content  = <<-DOC
    # Ansible vars_file containing variable values from Terraform.
    # Generated by Terraform mgmt configuration.
    ---
    web_app_instance: ${aws_instance.web_instance.private_dns}
    docker_instance: ${aws_instance.docker_instance.public_dns}
    DOC
  filename = "../ansible/${(var.env_name)}_instances_generated.yml"
  depends_on = [
    aws_instance.web_instance,
    aws_instance.docker_instance
  ]
}

data "template_file" "init_jenkins" {
  template = file("jenkins-set.groovy.tpl")
  vars = {
    jenkins_dns ="\'http://${(aws_instance.docker_instance.public_dns)}:8080\'"
  }
  depends_on = [
    aws_instance.docker_instance
  ]
}

resource "null_resource" "export_rendered_template" {
  provisioner "local-exec" {
    command = "cat > jenkins-set.groovy <<EOL\n${data.template_file.init_jenkins}\nEOL"
  }
}

# resource "null_resource" "getting_pass" {
#   provisioner "local-exec" {
#     command = "ssh -o StrictHostKeyChecking=no -i ${var.private_key_ec2} ubuntu@${aws_instance.docker_instance.public_dns} sudo docker exec Jenkins cat /var/jenkins_home/secrets/initialAdminPassword"
#     # >> ../ansible/jenkins_init.txt"
#   }
# }
