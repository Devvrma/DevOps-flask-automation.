#1  AWS connection setup 

 provider "aws" { 
  region = "ap-southeast-2"
} 

#2 EC2 instance detail 

resource "aws_instance" "ec2_instance" { 
ami  = "ami-001099f666b6ef86d"  

instance_type = "t3.micro"   

 tags ={
 Name = "devOpsServer"
 }
}    
