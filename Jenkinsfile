pipeline {
    
    agent any
    
    environment {
        AWS_ECR_REGION = 'us-east-1'
        AWS_ECS_SERVICE = 'My_service'
        AWS_ECS_TASK_DEFINITION = 'new_task'
        AWS_ECS_EXECUTION_ROLE = 'arn:aws:iam::692851696394:role/ecsTaskExecutionRole'
        AWS_ECS_COMPATIBILITY = 'FARGATE'
        AWS_ECS_NETWORK_MODE = 'awsvpc'
        AWS_ECS_CPU = '256'
        AWS_ECS_MEMORY = '512'
        AWS_ECS_CLUSTER = 'Mycluster'
        AWS_ECS_TASK_DEFINITION_PATH = 'Container_definition.json'
}
    
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
                sh "docker build -t test1_page ."
            }
        }
        stage('Push to ECR') {
            steps {
                sh "docker tag test1_page:latest 692851696394.dkr.ecr.us-east-1.amazonaws.com/test1_page:latest"
                sh "docker tag test1_page:latest 692851696394.dkr.ecr.us-east-1.amazonaws.com/test1_page:${env.BUILD_NUMBER}"
                sh "docker tag test1_page:latest 692851696394.dkr.ecr.us-east-1.amazonaws.com/test1_page:${env.GIT_COMMIT}"
                sh "docker push 692851696394.dkr.ecr.us-east-1.amazonaws.com/test1_page:latest"
                sh "docker push 692851696394.dkr.ecr.us-east-1.amazonaws.com/test1_page:${env.BUILD_NUMBER}"
                sh "docker push 692851696394.dkr.ecr.us-east-1.amazonaws.com/test1_page:${env.GIT_COMMIT}"
            }
        }
        stage('Deploy to ECS') {
            steps {
                script {
                    sh ./cfntest/script.sh
                }
            }
        }
    }
}
