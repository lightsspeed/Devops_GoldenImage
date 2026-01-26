#!/bin/bash
set -euo pipefail

echo "→ Installing Jenkins..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install -y fontconfig openjdk-17-jre jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "→ Waiting for Jenkins to start (this may take a minute)..."
for i in {1..60}; do
  if sudo systemctl is-active --quiet jenkins && [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    echo "→ Jenkins is ready!"
    break
  fi
  sleep 2
done

if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword > /home/ubuntu/jenkins_initial_admin_password.txt
  sudo chown ubuntu:ubuntu /home/ubuntu/jenkins_initial_admin_password.txt
  echo "→ Jenkins initial admin password saved to: /home/ubuntu/jenkins_initial_admin_password.txt"
fi
