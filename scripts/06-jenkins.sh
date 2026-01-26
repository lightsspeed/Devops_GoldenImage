#!/bin/bash
set -euo pipefail

echo "→ Installing Jenkins..."

# Ensure required tools exist
sudo apt-get update -y
sudo apt-get install -y curl fontconfig openjdk-17-jre

# Add Jenkins GPG key if not already present
if [ ! -f /usr/share/keyrings/jenkins-keyring.asc ]; then
  echo "→ Adding Jenkins GPG key..."
  sudo curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
    | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
fi

# Add Jenkins repo if not already present
if [ ! -f /etc/apt/sources.list.d/jenkins.list ]; then
  echo "→ Adding Jenkins APT repository..."
  echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
    | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
fi

# Install Jenkins
sudo apt-get update -y
sudo apt-get install -y jenkins

# Enable & start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "→ Waiting for Jenkins to start (this may take a minute)..."

for i in {1..60}; do
  if sudo systemctl is-active --quiet jenkins && \
     [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    echo "→ Jenkins is ready!"
    break
  fi
  sleep 2
done

# Save initial admin password for ubuntu user
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
  sudo cp /var/lib/jenkins/secrets/initialAdminPassword \
    /home/ubuntu/jenkins_initial_admin_password.txt
  sudo chown ubuntu:ubuntu /home/ubuntu/jenkins_initial_admin_password.txt
  sudo chmod 600 /home/ubuntu/jenkins_initial_admin_password.txt
  echo "→ Jenkins initial admin password saved to:"
  echo "  /home/ubuntu/jenkins_initial_admin_password.txt"
else
  echo "⚠️ Jenkins initial admin password not found!"
fi
