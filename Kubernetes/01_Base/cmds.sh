######################################
# MINICUBE
######################################

# start minikube
minikube start --driver docker

# get the ip of the cluster
minikube ip

# assign an external ip address to a service, this will also open the browser
minikube service service-name

######################################
# KUBECTL
######################################

# help 
kubectl --help

# you can also have help for each sub cmd
kubectl get --help

# recover all active kubernetes nodes
kubectl get node

# list pods
kubectl get pod

# get all elements (don't show configmaps and secret)
kubectl get all

# get configMaps
kubectl get configmap

# get secrets
kubectl get secret

# get more information on a component
kubectl describe service webapp-service
kubectl describe pod mongo-deployment-85d45f7888-bg7hf

# get logs (pod name)
kubectl logs mongo-deployment-85d45f7888-bg7hf

# get log with streaming
kubectl logs mongo-deployment-85d45f7888-bg7hf -f

# get more more information on nodes (like their ip address)
kubectl get node -o wide

# apply a kubernet config file
kubectl apply -f mongo-config.yml
kubectl apply -f mongo-secret.yml
kubectl apply -f mongo.yml
kubectl apply -f webapp.yml

######################################
# OTHER
######################################

# require base64 encoding of app (for secret)
echo -n app | base64

