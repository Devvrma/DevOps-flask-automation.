#1  AWS connection setup 

 provider "aws" { 
  region = "ap-southeast-1"
} 

#2 EC2 instance detail 

resource "aws_instance" "ec2_instance" { 
ami  = "ami-0f58b397bc5c1f2e8"

instance_type = "t3.micro"   

 tags = {               
 Name = "devOpsServer"
 }
}    
