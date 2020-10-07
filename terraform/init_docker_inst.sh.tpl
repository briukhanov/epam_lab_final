#! /bin/bash
export DOCKER_USER=${dock_user}
export DOCKER_PWD=${dock_pwd}
echo $DOCKER_USER
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt -y update
sudo apt -y aptitude
sudo apt -y install ansible
sudo ansible --version
cd ~ && git clone https://github.com/briukhanov/epam_lab_final.git
cd ~/ansible
sudo ansible-playbook site.yml --tags docker --extra-vars '{"docker_user":"${dock_user}","docker_pwd":"${dock_pwd}"}'
