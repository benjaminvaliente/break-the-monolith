task_arn=$(aws ecs list-tasks --cluster $1 --service-name $2 --query 'taskArns[0]' --output text --profile default)
task_details=$(aws ecs describe-tasks --cluster $1 --task ${task_arn} --query 'tasks[0].attachments[0].details' --profile default)
service_ip=$(echo $task_details | jq -r -c '.[] | select(.name=="privateIPv4Address").value')
echo -n $service_ip > $2.ip