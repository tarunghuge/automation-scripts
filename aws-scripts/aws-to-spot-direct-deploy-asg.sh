#!/bin/bash

instance_id=
ami_name=
spot_name=

ami_id=$(aws ec2 create-image --region ap-south-1 --instance-id $instance_id --name $ami_name-"`date +"%d-%m-%Y--%H-%M"`" --output text)
echo $ami_id
state=$(aws ec2 describe-images --region ap-south-1 --image-ids $ami_id |grep "State" | cut -f2 -d":" |tr -d ',"')
echo "AMI Creation is started. Status is - $state"

while true
do
        state=$(aws ec2 describe-images --region ap-south-1 --image-ids $ami_id |grep "State" | cut -f2 -d":" |tr -d ',"')
        echo $state
        sleep 45
        if [ $state == available ];     then
                # ami update
                spotinst-cli --account prod -g $spot_name --replace-ami=$ami_id -y

                sleep 120
                # rollout
                spotinst-cli --account prod -g $spot_name --roll --batch-size=100 --grace-period=120 -y

                # define 
                #spotinst-cli --account prod -g $spot_name --min=1 --max=2 --target=1  -y
                exit
        fi
done
