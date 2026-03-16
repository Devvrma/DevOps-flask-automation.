#1  AWS connection setup 

 provider "aws" { 
  region = "ap-southeast-2"
} 

#2 EC2 instance detail 

resource "aws_instance" "ec2_instance" { 
ami  = "ami-04f5097609382b1bb"

instance_type = "t3.micro"   

 tags = {               
 Name = "devOpsServer"
 }
}    
