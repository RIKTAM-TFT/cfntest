pipeline {
    
    agent any
    
    stages {
        
        stage('AWS ECR Login') {
            steps {
                sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 692851696394.dkr.ecr.us-east-1.amazonaws.com"
            }
        }
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/RIKTAM-TFT/cfntest.git']]])
            }
        }
        stage('Docker build') {
            steps {
                sh "docker build -t test1_page:latest${env.BUILD_NUMBER} ."
            }
        }
        stage('Push to ECR') {
            steps {
                sh "docker tag test1_page:latest${env.BUILD_NUMBER} 692851696394.dkr.ecr.us-east-1.amazonaws.com/test1_page:latest${env.BUILD_NUMBER}"
                sh "docker tag test1_page:latest${env.BUILD_NUMBER} 692851696394.dkr.ecr.us-east-1.amazonaws.com/test1_page:${env.BUILD_NUMBER}"
                sh "docker tag test1_page:latest${env.BUILD_NUMBER} 692851696394.dkr.ecr.us-east-1.amazonaws.com/test1_page:${env.COMMIT_ID}"
                sh "docker push 692851696394.dkr.ecr.us-east-1.amazonaws.com/test1_page:latest${env.BUILD_NUMBER}"
                sh "docker push 692851696394.dkr.ecr.us-east-1.amazonaws.com/test1_page:${env.BUILD_NUMBER}"
                sh "docker push 692851696394.dkr.ecr.us-east-1.amazonaws.com/test1_page:${env.COMMIT_ID}"
            }
        }
    }
}
