pipeline {           
 agent any
 environment { 
     DOCKER_IMAGE = "devverma99/flask-app:v1"
 }
 stages { 
    stage('checkout') { 
      steps { 
         checkout scm
    }
  }
  stage('Build Docker') {
   steps {
      sh "docker build -t ${DOCKER_IMAGE} ."    
      }
    }
   stage('Push to Docker Hub'){
    steps{


  withCredentials([usernamePassword(credentialsId:'docker-hub-creds', passwordVariable: 'PASS',
  usernameVariable:'USER')]){
               sh "docker login -u ${USER} -p ${PASS}"
               sh "docker push ${DOCKER_IMAGE}"
            }
          }  
        }
      stage('Terraform Deploy'){
        steps {
             sh 'Terraform init'
             sh 'terraform apply-auto-approve'
           }
         } 
       } 
     } 
