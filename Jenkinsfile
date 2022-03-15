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
                        sh("aws ecs register-task-definition --region ${AWS_ECR_REGION} --family ${AWS_ECS_TASK_DEFINITION} --execution-role-arn ${AWS_ECS_EXECUTION_ROLE} --requires-compatibilities ${AWS_ECS_COMPATIBILITY} --network-mode ${AWS_ECS_NETWORK_MODE} --cpu ${AWS_ECS_CPU} --memory ${AWS_ECS_MEMORY} --container-definitions ${AWS_ECS_TASK_DEFINITION_PATH}")
                        def taskRevision = sh(script: "aws ecs describe-task-definition --task-definition ${AWS_ECS_TASK_DEFINITION} | egrep \"revision\" | tr \"/\" \" \" | awk '{print \$2}' | sed 's/\"\$//'", returnStdout: true)
                        sh("aws ecs update-service --cluster ${AWS_ECS_CLUSTER} --service ${AWS_ECS_SERVICE} --task-definition ${AWS_ECS_TASK_DEFINITION}:${taskRevision}")
                }
            }
        }
    }
}
