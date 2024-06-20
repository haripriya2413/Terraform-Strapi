
resource "aws_instance" "strapi" {
  ami           = var.ami  # Ubuntu 20.04 LTS AMI
  instance_type = var.instance_type
  key_name      = aws_key_pair.strapi_keypair.key_name # Replace with your key pair name
    tags = {
        Name = "Strapi-Instance"
     }

  
provisioner "remote-exec" {
    inline = [
             "sudo apt-get update -y",
             "sudo apt-get install -y nodejs npm git",
              "sudo npm install -g pm2",
              "sudo npm install -g strapi@latest",
              "sudo mkdir -p /srv/strapi",
              "sudo chown ubuntu:ubuntu /srv/strapi",
             # "cd /srv/strapi",
              "if [ ! -d /srv/strapi ]; then sudo git clone https://github.com/haripriya2413/Strapi-CICD /srv/strapi; else cd /srv/strapi && sudo git pull origin main; fi",
              "cd /srv/strapi",
             

          # Install Strapi globally
          "sudo npm install strapi@beta -g",

          # Create a new Strapi project
          "strapi new priya-project --dbclient=sqlite",

          # Navigate to the new project directory
          "cd priya-project",

          # Start the Strapi application using pm2
          "pm2 start npm --name 'strapi' -- run develop"
             
  

            
    ]
  }
   connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa")   # Replace with the path to your private key
    host        = self.public_ip
  }
 
  security_groups = [aws_security_group.strapi-sg.name]
}

 
resource "tls_private_key" "strapi_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "strapi_keypair" {
  key_name   = "strapi-keypair2"
  public_key = file("~/.ssh/id_rsa.pub") 
}

