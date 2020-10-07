# resource "local_file" "tf_ansible_vars_file_new" {
#   content  = <<-DOC
#     # Ansible vars_file containing variable values from Terraform.
#     # Generated by Terraform mgmt configuration.
#     ---
#     mysql_db_name: ${var.db_name}
#     mysql_user: ${var.db_username}
#     mysql_user_password: ${var.db_password}
#     mysql_server_address: ${aws_db_instance.database_instance.address}
#     nginx_http_host: ${var.nginx_http_host}
#     nginx_http_conf: ${var.nginx_http_conf}
#     nginx_http_port: ${var.nginx_http_port}
#     DOC
#   filename = "../ansible/web_app_group_vars.yml"


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
      "sudo ansible --version",
      # "mkdir ~/ansible && mkdir ~/ansible/group_vars",
      # "mv /tmp/all.yml ~/ansible/group_vars/all.yml",
      # "mv /tmp/site.yml ~/ansible/site.yml",
      # "cd ansible",
      # "sudo ansible-playbook site.yml",
      "mv /tmp/ansible ~/",
      "cd ~/ansible",
      "sudo ansible-playbook site.yml --tags webapp"
      # "cd ~ && rm -Rf ./ansible",
      # "ls"

    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = ""
    host        = self.public_ip
    private_key = file(var.private_key_ec2)
    # private_key = var.aws_ec2_key
  }
  # depends_on = [
  #   local_file.tf_ansible_vars_file_new
  # ]

}


data "template_file" "init_docker_instance" {
  template = file("init_docker_inst.sh.tpl")
  vars = {
    dock_user = var.docker_user
    dock_pwd  = var.docker_pwd
  }
}

resource "null_resource" "export_rendered_template" {
  provisioner "local-exec" {
    command = "cat > test_output.json <<EOL\n${data.template_file.init_docker_instance.rendered}\nEOL"
  }
}

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
  # user_data = data.template_file.init_docker_instance.rendered
  # provisioner "file" {
  #   source      = "../ansible"
  #   destination = "/tmp"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "export DOCKER_USER=${(var.docker_user)}",
  #     "export DOCKER_PWD=${(var.docker_pwd)}",
  #     "echo $DOCKER_USER",
  #     "sudo apt-add-repository -y ppa:ansible/ansible",
  #     "sudo apt -y update",
  #     "sudo apt -y aptitude",
  #     "sudo apt -y install ansible",
  #     "sudo ansible --version",
  #     "mv /tmp/ansible ~/",
  #     "cd ~/ansible",
  #     "sudo ansible-playbook site.yml --tags docker --extra-vars '{"docker_user":"${(var.docker_user)}","docker_pwd":"${(var.docker_pwd)}"}'"
  #         ]
  # }

  # connection {
  #   type        = "ssh"
  #   user        = "ubuntu"
  #   password    = ""
  #   host        = self.public_ip
  #   private_key = file(var.private_key_ec2)
  #   # private_key = var.aws_ec2_key
  # }

  # depends_on = [
  #   local_file.tf_ansible_vars_file_new
  # ]

}


# resource "null_resource" "getting_pass" {
#   provisioner "local-exec" {
#     command = "ssh -o StrictHostKeyChecking=no -i ${var.private_key_ec2} ubuntu@${aws_instance.docker_instance.public_dns} sudo docker exec Jenkins cat /var/jenkins_home/secrets/initialAdminPassword"
#     # >> ../ansible/jenkins_init.txt"
#   }
# }
resource "local_file" "tf_ansible_vars_file_new" {
  content  = <<-DOC
    # Ansible vars_file containing variable values from Terraform.
    # Generated by Terraform mgmt configuration.
    ---
    web_app_instance: ${aws_instance.web_instance.private_dns}
    docker_instance: ${aws_instance.docker_instance.public_dns}
    DOC
  filename = "../ansible/${(var.env_name)}_instances.yml"
  depends_on = [
    aws_instance.web_instance,
    aws_instance.docker_instance
  ]
}
