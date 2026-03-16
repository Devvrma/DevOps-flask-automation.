#1  AWS connection setup 

 provider "aws" { 
  region = "ap-south-1"
} 

#2 EC2 instance detail 

resource "aws_instance" "ec2_instance" { 
ami  = "ami-0a14f53a6fe4dfcd1"

instance_type = "t3.micro"   

 tags = {               
 Name = "devOpsServer"
 }
}    
