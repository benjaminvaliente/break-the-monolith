#!/bin/bash
set -e #Stop on fail

# ENV VARIABLES
# export AWS_PROFILE='personal'
HELLO_DOCKERFILE='hello.Dockerfile'
HELLO_IMAGE_NAME='hello'
USER_DOCKERFILE='user.Dockerfile'
USER_IMAGE_NAME='user'

# AWS CREDENTIALS
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text) # get the aws accountId.
REGION=$(aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]')
echo Preparing and uploading docker container
echo 'AWS Account:' $AWS_ACCOUNT_ID 'Region:' $REGION

# AWS ECS
echo "Login to AWS ECR service..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

echo "Start docker build..."
docker build --platform=linux/amd64 -t $HELLO_IMAGE_NAME -f $HELLO_DOCKERFILE .
docker build --platform=linux/amd64 -t $USER_IMAGE_NAME -f $USER_DOCKERFILE .

# TAGGING AND PUSHING IMAGES TO ECR
echo "Tagging docker image..."
docker tag "$HELLO_IMAGE_NAME:latest" "$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$HELLO_IMAGE_NAME:latest"
docker tag "$USER_IMAGE_NAME:latest" "$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$USER_IMAGE_NAME:latest"

echo "Pushing image to AWS ECR service..."
docker push "$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$HELLO_IMAGE_NAME:latest"
docker push "$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$USER_IMAGE_NAME:latest"