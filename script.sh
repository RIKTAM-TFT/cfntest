test=$(aws ecs describe-task-definition --task-definition "new_task:2" --region "us-east-1")
NEW_TASK_DEFINTIION=$(echo $test | jq --arg IMAGE "$NEW_IMAGE" '.taskDefinition | .containerDefinitions[0].image = "692851696394.dkr.ecr.us-east-1.amazonaws.com/test:'${env.BUILD_NUMBER}'" | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities)')
aws ecs register-task-definition --region "us-east-1" --cli-input-json "$NEW_TASK_DEFINTIION" 
aws ecs update-service --cluster mycluster --service mysvc --task-definition new_task --region=us-east-1
