
#!/bin/bash

echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config
systemctl restart sshd.service

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt-get install terraform -y apache2 

sudo tee /etc/apache2/sites-available/mario.abhishekkrishna.site.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName mario.abhishekkrishna.site
    
    ProxyPass / http://localhost:82/
    ProxyPassReverse / http://localhost:82/

    ErrorLog \${APACHE_LOG_DIR}/mario.abhishekkrishna.site_error.log
    CustomLog \${APACHE_LOG_DIR}/mario.abhishekkrishna.site_access.log combined
</VirtualHost>
EOF
sudo a2ensite mario.abhishekkrishna.site.conf
sudo systemctl restart apache2

 apt install apt-transport-https ca-certificates curl software-properties-commonr -y
apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt install docker-ce docker -y
docker pull kaminskypavel/mario
docker run -itd -p 82:8080 kaminskypavel/mario

