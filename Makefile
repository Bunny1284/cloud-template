IMAGE = test
ECR_REPO = webapp2
AWS_REGION = us-east-1
AWS_ACC_ID = 377371593537
ECR_REPO_TAG = latest
EKS_CLUSTER_NAME = doggity

# build:
# 	docker build -t $(IMAGE) .

build:
	docker buildx build --platform linux/amd64 -t $(IMAGE) .

awscreateecr-repo:
	-aws ecr create-repository --repository-name $(ECR_REPO) --region $(AWS_REGION)
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACC_ID).dkr.ecr.$(AWS_REGION).amazonaws.com
	
awspush:
	docker tag $(IMAGE):$(ECR_REPO_TAG) $(AWS_ACC_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_REPO)
	docker push $(AWS_ACC_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_REPO)
	
#local development		
run:
	docker run -v ./logs:/logs \
		-p 8000:80 \
    	--name django-test \
    	$(IMAGE) 
	
#fix it
rmc:
	- docker container stop $(docker container ls -aq)
	- docker container rm $(docker container ls -aq)

kdeploy:
	kubectl apply -f deployment.yaml

kpods:
	kubectl get pods

knodes:
	kubectl get nodes

kservice:
	kubectl apply -f service.yaml

ekscreate:
	eksctl create cluster \
	--name $(EKS_CLUSTER_NAME) \
	--version 1.26 \
	--region us-east-1 \
	--nodegroup-name linux-nodes \
	--node-type t2.micro \
	--nodes 2

