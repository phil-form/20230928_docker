###########################################################################
# Basic
###########################################################################

# Kubernetes is a container orchestration tool developed by Google
# it helps you manage application composed of hundred or thousands of containers 
# it helps you manage it in different environement (cloud, physical or virtual machine or hybrid)

# the rise of microservices increased the usage of containers, as microservices are interconnected services
# that need to work together and containers are perfect tools to deploy and manage such architecture.

# the rise of these technologies created applications containing a lot of containers.
# Managing all these containers is very tidious, trying to do it with scripts can be very hard or even impossible
# And so this is where orchestrator are useful as they help us manage all these containers.

# Kubernetes guaranty certain features : 
#   - high availability -> no downtime
#   - scalability -> high performance (load fast and hight response rate from application)
#   - disaster recovery -> backup and restore state

###########################################################################
# COMPONENTS
###########################################################################

# PODS

# a pod is the smallest unit of a k8s, it is basically a layer on top of a container running on a node
# pods are meant to run only one container at a time (you can run multiple container in a pod but most o the time we don't)

# each pod has its own ip address, and they can comunicate with each other using that IP address
# But if a problem occur on the database and that container is shutdown and restart then its IP address will change
# Also if we have multiple instance of a same container, each will have a different IP address.
# this is problematic and can lead to problem as the IP address are unique per pod. So if the DB pod die and is reloaded
# then its IP address change and the application can no longer use that IP to communicate with the DB container

# NODE 1
# ---------------
# |             |
# | ----------  |
# | |  App   |  |
# | |        |  | IP (unique per pod)
# | |Containr|  |  | 
# | |        |  |  |
# | ----------  |  |
# |             |  | Can communicate with ips
# |             |  |
# | ----------  |  |
# | |  DB    |  |  |
# | |        |  |  |
# | |Containr|  | IP (unique per pod)
# | |        |  |
# | ----------  |
# |             |
# ---------------

# SERVICE

# the service will resolve the problem above, the service will be use to link one pod to an other
# when we use service they will contact that service name, and kubernetes will manage with its loadbalancer
# to send the request to the most available pod.

# the life cycle of a service and a pod is not connected, and the service act like a permanent IP address,
# or a domain name for multiple pods with a loadbalancer sending the requests to the most available one.

# so the service has two main functionalities :
#   - permanent Ip address
#   - load balancer (to balance the requests to all the pods connected to the service
#       so that one pod wont be at 100% cpu and the others at 0%, so it will always try
#       to contact the less busy pod)

# You can have internal and external service :
#   - internal service can only be accessed inside the kubernetes network
#   - external service can be accessed outside the kubernetes network

# the external service can be contacted using : 
# http://service-ip-address:service-port
# example : http://124.54.12.3:8080

# there are two problem here, first it's an HTTP protocol and not an HTTPS
# and second it is not very practical to use the IP address to communicate with the service
# so we can use ingress to solve those problems (next part)

# NODE 1
# ---------------
# |             |
# | ----------  |
# | |  App   |  |
# | |        |  | SERVICE app-service (external)
# | |Containr|  |  | 
# | |        |  |  |
# | ----------  |  |
# |             |  | Can communicate with ips
# |             |  |
# | ----------  |  |
# | |  DB    |  |  |
# | |        |  |  |
# | |Containr|  | SERVICE db-service (internal)
# | |        |  |
# | ----------  |
# |             |
# ---------------

# NODE 2
# ---------------
# |             |
# | ----------  |
# | |  App   |  |
# | |        |  | SERVICE app-service (external)
# | |Containr|  |  | 
# | |        |  |  |
# | ----------  |  |
# |             |  | Can communicate with ips
# |             |  |
# | ----------  |  |
# | |  DB    |  |  |
# | |        |  |  |
# | |Containr|  | SERVICE db-service (internal)
# | |        |  |
# | ----------  |
# |             |
# ---------------

# INGRESS

# so here to communicate with the service, it first goes to the ingress
# and the ingress does the forwarding to the service.

# NODE 1          INGRESS (entry point)
# ---------------  |
# |             |  |
# | ----------  |  |
# | |  App   |  |  |
# | |        |  | SERVICE app-service (external)
# | |Containr|  |  | 
# | |        |  |  |
# | ----------  |  |
# |             |  | Can communicate with ips
# |             |  |
# | ----------  |  |
# | |  DB    |  |  |
# | |        |  |  |
# | |Containr|  | SERVICE db-service (internal)
# | |        |  |
# | ----------  |
# |             |
# ---------------

# CONFIG MAP

# the config map is use to configure variable that can be shared throughout the kubernetes components
# for example, we can configure the basic environment variables in the config map so that those 
# environment variables are shared with all the containers. So basically config map are use to centralize
# the configuration variables for the application

# so inside of the config map you'll find for example the database url or the urls of other services, ...
# but you should not use any password/username inside the config map !

# SECRETS

# the database and password are meant to be stored in a secret, this is like a config map,
# but inside a secret all the values must be encoded using base64.
# so this component will store credentials

# VOLUMES

# volumes are meant for datastorage, with a basic setup without using volumes
# if the database crash or restart, every data is lost.

# volumes are meant to persist the datas.

# volumes can attach either a physical storage (a hard drive, a partition, a network drive) or a cloud
# storage to the kubernetes network. So this is like a external hard drive plugged into k8s.

# pay attention that k8s is not meant to manage data persistance, so it is up to you to manage it !

# DEPLOYMENT

# the idea of k8s is hight availability, so if a node or a pod is down, the application should still
# be reached by the users. The deployment component will tell k8s the configuration we want for our pods
# so we can have multiple nodes running the same application, and if one is down, then the other is 
# still available. So into the deployment we will tell how many copy of that application we want.
# and k8s will try to always have that number of copies (replicat or clone) of the same application running.

# But here we might run into an other problem, what if we have two database that try to write on the same
# volume at the same time ? This is where Stateful Set is used.

# so inside a deployment component, we declare a blueprint for a pod, and we then say how many replica we want
# of that pod. So we will always use deployment to create our pods. So that we can tell k8s how many replica we
# want and he will manage to always have the same number of replica running.

# we can also scale up and down the number of replica we need easily with deployments.

# So in practice we mostly work with deployment as they are a abstraction layer over the pods themselves.

# STATEFUL SET

# As I said, in the deployment, we still have a problem, if two database try to write at the same time 
# or read/write at the same time, we have an integrity problem as this will cause data inconsistencies;
# which is the exact opposite of what we want with a database.

# This is where the stateful set is very usefull, as it will manage the access to the storage of each 
# pod link to the stateful app. If two statefull pod tries to access the data at the same time, one will
# wait for the other to have finish its transaction before being able to access the datas. So everything
# is syncronized with a stateful set, other than that a stateful set works the same way as a deployment
# component.

# So database should always use stateful set instead of deployment components.

# !!! it is more difficult and tedious to work with stateful set !!!
# so it is sometime practice to work with databse outside of the k8s cluster.

###########
# SUMMARY #
###########

# abstraction of containers -> pod
# communication -> service
# route and traffic into cluster -> ingress
# external config -> config map & secret
# data persistance -> volumes
# pod blueprints with replicating mecanism -> deployment & stateful set

###########################################################################
# ARCHITECTURE
###########################################################################

# there are two type of nodes in k8s, a master node and a slave node.

# each node has multiple pods running on it
# 3 processes must be installed on every node :
#   - container runtime (eg : docker) 
#   - kubelet interacts with both the container and the node
#      kubelet is resposible to start the pods & it assign resources (CPU & RAM & storage) from the node to that pod
#   - Kubeproxy is responsible to forward the requests, this one will try to load balance the request throughout the 
#       k8s cluster, but it is far more complicated than forwarding it to the less active pod, as it will also check
#       if a pod of that type exist on the same note than the contacting service, and will contact that one if it is not
#       too busy, that way it will avoid any network overhead of sending the request to an other node.
# worker nodes do the work.

# So now how do we interact with the cluster ? and hos we do :
#   - schedule the pods ?
#   - monitor them ?
#   - re-schedule/restart pods ?
#   - join a new node ?

# that is the job of the master node.

# there can be multiple master node (and in production there should always be a least two master node)
# a master node is composed of multiple process : 
#   - api server, the api server is like a cluster gateway that we use to communicate with the cluster with
#       either an UI or a command line such as kubectl
#   - scheduler : the scheduler will check which node is the most available to schedule the pods depending 
#       on the availability of the worker nodes. It will also restart the pods if needed.
#       the important part is that the scheduler only decides on which node the new pod should be scheduled!
#       So the scheduler will send a request to the most available node to create the new pod using kubelet.
#   - controller manager : to manage/restart the pods themselves if one dies. So the controller manager
#       will detect the state changes of a pod, so if a pod dies it will detect that those pods died, then 
#       it will send a request to the scheduler to reschedule those dead pods.
#   - etcd : it is a key/value store of a cluster state, you can think of it as the brain of a cluster
#       so every changes inside a node (creation or deletion of pods) is stored inside the key/value store etcd
#       every other process above depends on this etcd, for example, the scheduler will depends on etcd to know 
#       the resources availability of each nodes, or the controller manager will depend on etcd to know that 
#       the cluster state changed (a pod died, ...); and finaly, the api server will get the informations about
#       the cluster from etcd (so the cluster health, ...).
#       !!! the data of the application is NOT stored inside ETCD !!!

# so if you need to create a new master/node server you'll need to do the following steps :
#   - get a new bare server
#   - install all the master or worker node process required
#   - add it to the cluster
# that way, you can infinitly increase the power of your k8s cluster as you can scale up and down your cluster with new nodes
# & master if you need more resources.

# API SERVER 

# the api server will receive the request, and validate them, if they are valid, they will be forwarded to other processes
# to create the pod or schedule it, ... It is good security wise as we only have one entrypoint into the cluster.

# MASTER NODE 1
# ---------------
# |             |
# | ----------  |
# | |  Api   |  |
# | | server |  |
# | ----------  |
# | ----------- |
# | |scheduler| |
# | ----------- |
# | ------------|
# | |controller||
# | |manager   ||
# | ------------|
# | ----------- |
# | |  etcd   | |
# | ----------- |
# |             |
# ---------------

# NODE 1
# ---------------
# |             |
# | ----------  |
# | |  App   |  |
# | |        |  |
# | |Containr|  |
# | |        |  |
# | ----------  |
# |             |
# |             |
# | ----------  |
# | |  DB    |  |
# | |        |  |
# | |Containr|  |
# | |        |  |
# | ----------  |
# |             |
# ---------------

###########################################################################
# MINIKUBE AND KUBECTL
###########################################################################

# MINIKUBE

# on a real production cluster you'll have multiple master & node and these will form the k8s cluster
# but when you're configuring k8s you don't especially want to have to create all those nodes and to setup
# multiple virtual or physical machine to do your configuration & tests.

# so basically minikube create a machine where the master & the node processes run on the same machine.
# so that node will have a pre-installed docker container runtime.

# the way it work is that it will create a virtual box on your machine and it will runs the node inside that virtual box.

# !!! minikube REQUIRE virtualization enable on the machine and will require an hypervisor !!!
# Minikube comes with docker installed.

# start minikube
minikube start --driver docker

# get the ip of the cluster
minikube ip

# get status
minikube status

# KUBECTL

# kubectl is the command line interface (CLI) to interact with a k8s cluster.
# so kubectl is the command that we use to create pods and other k8s components.

# help 
kubectl --help

# you can also have help for each sub cmd
kubectl get --help

# get version
kubectl version

# get the help on the create command
kubectl create --help

# create a deployment -> create a pod. This create the most basic pod
# the podname contains:
# nginx-depl-REPLICASETID-PODID
# creating with the command line is very tedious, so we use config files in yaml or json instead
kubectl create deployment nginx-depl --image=nginx

# edit a deployment (usually we will use a config file directly) the editor is vim
kubectl edit deployment nginx-depl

# recover all active kubernetes nodes
kubectl get node

# list pods
kubectl get pod

# get deployment
kubectl get deployment

# get a deployment in yaml here we will see the status
kubectl get deployment deployment-name -o yaml

# get all elements (don't show configmaps and secret)
kubectl get all

# get configMaps
kubectl get configmap

# get secrets
kubectl get secret

# get more information on a component. 
# If the status command does not work, the describe will give more info.
# the end points are the out ip address/port
kubectl describe service webapp-service
kubectl describe pod mongo-deployment-85d45f7888-bg7hf

# get logs (pod name)
kubectl logs mongo-deployment-85d45f7888-bg7hf

# get log with streaming
kubectl logs mongo-deployment-85d45f7888-bg7hf -f

# get more more information on nodes (like their ip address)
kubectl get node -o wide

# apply a kubernet config file 
# if you execute a apply command with an already existing deployment, it'll reconfigure it.
# pay attention to the dependency order, if a deployment require a secret or an other deployment
# you must apply that secret or deployment first.
kubectl apply -f mongo-config.yml
kubectl apply -f mongo-secret.yml
kubectl apply -f mongo.yml
kubectl apply -f webapp.yml

# get an interactive terminal into a pod
kubectl exec -it mongo-deployment-85d45f7888-bg7hf -- bin/bash

# delete pod, if you delete a deployment it'll delete its pods and replicasets
kubectl delete dployment nginx-depl

#then check with, both the pod and its replica sets should be destroyed
kubectl get pod
kubectl get replicaset

# get all the contexts 
kubectl config get-contexts

# change current context
kubectl config user-context CONTEXT_NAME

###########################################################################
# YAML CONFIGURATION
###########################################################################

# deployment config file example : https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
# stateful set config file example : https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/
# service config file example : https://kubernetes.io/docs/concepts/services-networking/service/
# ingress config file example : https://kubernetes.io/docs/concepts/services-networking/ingress/
# config map config file example : https://kubernetes.io/docs/concepts/configuration/configmap/
# secret config file example : https://kubernetes.io/docs/concepts/configuration/secret/
# using volume : https://kubernetes.io/docs/concepts/storage/volumes/
# persistent volume : https://kubernetes.io/docs/concepts/storage/persistent-volumes/

# check the config file into this folder.

###########################################################################
# EXERCICE -> look at 02_Exercice project
###########################################################################

# deploy a mongo db and mongo-express containers with k8s
# using secret & config correctly 

###########################################################################
# NAMESPACE & COMPONENTS ORGANIZATION
###########################################################################

# a namespace is a way to organize your resources into multiple namespaces inside a cluster
# so a namespace could be seen as a virtual cluster inside a cluster

# by default k8s will give your default namespaces :
#   - default -> your resources if you don't create new namespace
#   - kube-node-lease -> hold the information about the "heartbeat" of nodes
#   - kube-public -> publicly accessible datas it contains a config map with publicly available cluster information
#   - kube-system -> is meant for kubernetes internal component you should NOT create anything in that namespace
#   - kubernetes-dashboard -> specific to minikube

# to show the namespaces
kubectl get namespace

# to get the info in kube-public
kubectl cluster-info

# to create a namespace
kubectl create namespace namespace-name

# you can also create namespace directly in config files
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: name-configmap
#   namespace: new-namespace
# data:
#     your-data: datas

# you can also create a namespace with a config file

# WHEN SHOULD YOU USE NAMESPACES

# if you have a complex application with a lot of elements it is better to regroup them by namespace
# to make it easier to manage. This will keep the default namespace clean.

# so you could have a database namespace, then a monitoring namespace for the monitoring pods.

# if you have multiple teams you can have two different applications that has the same name.
# in that case namespaces will be a way to be certain not to override the other team application.

# you could also use namespace to get a separation between the staging and a development namespace

# you could use it in a Blue/Green deployment, so with two different version of the application
# the previous version (blue) and the newer version (green); and these namespaces might need to use the
# same resources. In that case it will be easy to manage the two namespaces instead of two separated 
# k8s clusters.

# you can also limit access to resources, so that one team cannot access
# and/or modify the resources of an other team

# you can also limit the physical resources (CPU,RAM, Storage) per namespace

# !! you can't access resources from an other namespace 
# so you would need to create two config map or secret with the same values per namespace

# !! You can share services between namespaces
# to access a service from an other namespace 
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: name-configmap
#   namespace: new-namespace
# data:
#     database-url: db-url.namespace

# !! some component cannot be created inside a namespace such as volumes.
# to list those components :
kubectl api-resources --namespace=false

# list all the resources that are bound to a namespace :
kubectl api-resources --namespace=true

# if you have multiple components with the same name but in different namespace you can get them
# using the following command line
# so for each component type you can specify the namespace with "-n" option
kubectl get configmap -n my-namespace

# so if you execute this command
kubectl get configmap

# this is equal to that command
kubectl get configmap -n default

# you can create a component in a specific name space using 
kubectl apply -f configfile.yml --namespace=your-namespace

# you can also do it inside the config file itself : 
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: name-configmap
#   namespace: new-namespace 
# data:
#     database-url: db-url.namespace

# it is better to always set the namespaces inside the configfile 

# if you need to change an active namespace for kubectl you can use the command "kubens"
# there is no way with kubectl to change its default active namespace (which is the default ns)

# to list the namespaces
kubens 

# to change the active namespace
kubens your-namespace

###########################################################################
# K8s INGRESS
###########################################################################

# with external service, you get a connection to your application, but it is not secured with https
# and it uses the IP address. So it is not using any domain name.

# The ingress will help use change that, by creating a domain name and a secure connection.

# here is an example of a external service config file : 
# apiVersion: v1
# kind: Service
# metadata:
#   name: mongo-express-service
# spec:
#   # type: ClusterIp # default type => internal
#   type: LoadBalancer # create external service
#   selector:
#     app: mongo-express # THIS ONE IS LINK TO THE DEPLOYMENT LABEL
#   ports:
#     - protocol: TCP
#       port: 8081 # internal port 
#       targetPort: 8081 # target port of the pod
#       nodePort: 30000 # must be between 30000 -> 32767
#                       # this is the external port for that service

# and here is an ingress example :
# apiVersion: networking.k8s.io/v1
# kind: Ingress
# metadata:
#   name: app-ingress
# spec:
#   rules:
#   - host: myapp.com
#     http: # -> means that the incoming request is forwarded to the internal service
#       paths:
#       - path: /
#         pathType: Exact  
#         backend:
#           service:
#             name: app-internal-service
#             port: 
#               number: 8080 # port on that service 

# so here when the user enter myapp.com in the browser it is redirected to the ip
# of app-internal-service at the port 8080. ! this still use HTTP and not HTTPS !

# if you only create the ingress component that wont be enought for ingress rounting to work, 
# you also need an ingress controller.

# so first you have to install the ingress controller, this ingress controller will 
# evaluate & process the ingress rules.

# so the ingress controller will check all the rules defined into ingress in your kubernetes cluster
# and then process and redirect in function of those rules. So the ingress controller is the entry point
# of your cluster.

# there are a lot of ingress controller the list is available here : https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/

# !!! if you're using cloud to host your cluster, then you'll certainly have a load balancer on top of your cluster,
# that load balancer will be the first entry point and will be outside of your k8s cluster, so that load balancer
# will then redirect the requests to your ingress controller.

# the huge advantage is that you don't have to deal with the load balancer yourself.

# if you're doing it on bare metal then you'll need to configure that entry point.
# here is a link that show you how to do it : https://kubernetes.github.io/ingress-nginx/deploy/baremetal/
# you can use a proxy server for example that will act as an entry point to your cluster.
# We would tend to do that and avoid exposing one of the k8s nodes to the outside world with a public ip.
# if we use the proxy, then that proxy is the entry point and the k8s cluster is secured behind that.

# here is the setup with minikube
# enable the ingress controller
minikube addons enable ingress

# if you now do a get pod on the kube-system you'll see that the ingress controller was installed.
kubectl get pod -n kube-system

# now we will use the minikube dashboard and create an ingress for it :
# create the kubernetes-dashboard
minikube dashboard

# create the ingress
kubectl apply -f dashboard-ingress.yml

# check the ingress
kubectl get ingress -n kubernetes-dashboard

# NAME                CLASS    HOSTS                ADDRESS        PORTS   AGE
# dashboard-ingress   <none>   kube.dashboard.com   192.168.49.2   80      104s

# now we need to define the mapping into our host file (linux)
sudo vim /etc/hosts

# and we need to add the following line at the end :
# 192.168.49.2    kube.dashboard.com

# and at the end we need to define the mapping 

# we can also map multiple services to multiple paths :
# apiVersion: networking.k8s.io/v1
# kind: Ingress
# metadata:
#   name: dashboard-ingress
#   namespace: kubernetes-dashboard
#   annotations:
#     kubernetes.io/ingress.class: "nginx"
#     nginx.ingress.kubernetes.io/rewrite-target: /
# spec:
#   rules:
#   - host: dashboard.com
#     http:
#       paths: # dashboard.com/service1/controler/method/id
#       - path: /service1
#         pathType: Exact  
#         backend:
#           service:
#             name: kubernetes-dashboard
#             port: 
#               number: 80
#       - path: /service2
#         pathType: Exact  
#         backend:
#           service:
#             name: mongo-dashboard
#             port: 
#               number: 80

# or multiple subdomains :
# apiVersion: networking.k8s.io/v1
# kind: Ingress
# metadata:
#   name: dashboard-ingress
#   namespace: kubernetes-dashboard
#   annotations:
#     kubernetes.io/ingress.class: "nginx"
#     nginx.ingress.kubernetes.io/rewrite-target: /
# spec:
#   rules:
#   - host: api.app.com
#     http:
#       paths:
#       - path: /
#         pathType: Exact  
#         backend:
#           service:
#             name: kubernetes-dashboard
#             port: 
#               number: 80
#   - host: client.app.com
#     http:
#       - path: /
#         pathType: Exact  
#         backend:
#           service:
#             name: mongo-dashboard
#             port: 
#               number: 80

# myapp.com/api/controller/method/id

# configure TLS certificate
# apiVersion: networking.k8s.io/v1
# kind: Ingress
# metadata:
#   name: dashboard-ingress
#   namespace: kubernetes-dashboard
#   annotations:
#     kubernetes.io/ingress.class: "nginx"
#     nginx.ingress.kubernetes.io/rewrite-target: /
# spec:
#   tls:
#   - hosts:
#     - api.app.com
#     secretName: myapp-secret-tls
#   rules:
#   - host: api.app.com
#     http:
#       paths:
#       - path: /service1
#         pathType: Exact  
#         backend:
#           service:
#             name: kubernetes-dashboard
#             port: 
#               number: 80

# with the following secret config :
# apiVersion: v1
# kind: Secret
# metadata:
#   name: myapp-secret-tls
#   namespace: default
# data:
#   tls.crt: base64EncodedCertificate
#   tls.key: base64EncodedKey

###########################################################################
# HELM PACKAGE MANAGER
###########################################################################

# ! Helm tend to changes a lot from version to version !

# What is Helm ?

# Helm is a package manager for K8s.
# It is a convinient way of packaging yaml files and distributing them
# in public and private repositories.

# eg : you've deployed a new cluster and want to add an Elastic Stack for logging 
# To do that you'll need a couple of components : 
#   - a stateful set 
#   - a config map
#   - a secret
#   - k8s user with permission
#   - services

# if you create all these files seperately, it'll take a lot of time.
# As this stack is pretty standard, it would be convinient to find something that can
# make it easier to setup.

# this is where Helm comes into play it'll bundle a couple of yaml files together
# and create what's called a Helm charts.

# What are Helm Charts ?

# A Helm charts is a bundle of yaml files. You can create your own Helm Charts with Helm.
# You can then push these helm charts to repositories 
# And download and use existing charts.

# So you'll find a lot of applications in helm charts repositories such as stateful database app,
# monitoring app, ... That way it is very easy to reuse that configuration.

# you can search a helm charts using the command line :
helm search keyword

# or on helm hub (Artifact Hub now)
# https://artifacthub.io/

# You can obviously have public and private repositories
# as companies might not be willing to share their charts outside of the organization

# Templating Engine

# if you've an application with a microservice architecture, and you need to deploy all
# these micro services to your k8s cluster, and the deployment & services of these microservice
# are pretty much the same other than the version and the image.

# With Helm you can define a common blueprint for all the services, with placeholders for the 
# dynamic values that are to be replaced. This would be a template file.

# Here is how a template file looks like :
# template.yml
# apiVersion: apps/v1
# kind: Deployment

# metadata:
#   name: {{ .Values.name }}
# spec:
#   containers:
#   - name: {{ .Values.container.name }}
#     image: {{ .Values.container. image }}
#     port: {{ .Values.container.port }}

# here the syntax {{ .Values... }} means that we will take that value from an external configuration
# and that external configuration comes from an additional yaml file called values :
# values.yml

# name: app
# container:
#     name: app-container
#     image: app-image
#     port: 1980

# You can also pass values by the command line using the "--set" option
# So using this technique, instead of having multiple yaml files for each micro service,
# we will have one template file for every service, and we can replace the template values 
# dynamically. So this is very useful for Continuous Delivery Continuous Integration.
# That way you can use these template files into your pipeline and replace the values on the fly.


# An other usecase of helm is when you need to deploy the same application across different k8s clusters/environments.
# So for example we would like to deploy an application in 3 clusters :
#   - development
#   - staging
#   - production

# instead of deploying the separate yml files in each cluster you can package them up to make you own helm charts
# and use these charts to deploy your application on these 3 clusters.

# Helm chart Structure

# chartName/    -> name of the chart
#   chart.yml   -> a file that contains the meta data about the charts
#   values.yml  -> the place where the values are configured for the template files
#                  this file will contain the default values.
#   charts/     -> chart dependencies (if this chart depends on other these dep will be stored here)
#   templates/  -> this is where we will store our templates.
#   ...         -> readme/licence/...

# So when we want to install a new helm charts using :
helm install chartname
# the templates files will be filled with the values from the values.yml

# how to override the values ?
# 1 when we execute helm install we can pass the values like this :
helm install --values=my-value-file.yml chartname

# 2 you can also use --set option
helm install --set val=newValue chartname


# Release management

# the version 2 and 3 work differently 

# in verion 2, you'll have a client (helm cli) and a server (called a tiller)
# That server must be a k8s cluster, and that tiller will then create the components
# from the yaml files sent by the client.

# each time you deploy a chart, the tiller will store its configurations files.
# So you'll have an history of all the confgurations 

# Now to deploy the charts
# this will create new components
helm install chartname

# if you want to upgrade components
helm upgrade chartname

# if this fails you can rollback that deployment
helm rollback chartname

# the problem with the tiller is that it has too much power inside the k8s cluster, as it is 
# able to create, update, and remove components. So this is why in version 3 they removed the tiller
# and they replace it with a helm binary.

###########################################################################
# PERSISTING DATA AND VOLUMES
###########################################################################

# By default k8s does not do any data persistance, so if a database pod is restarted
# all its datas will be lost. Its up to you to manage backup.

# To solve that problem you'll need a storage that does not depends on a pod lifecycle.

# A problem is that if a pod crash, we don't know on which node the new replica will be created.
# So the storage must be accessible to all nodes. 
# You Also need a storage that survive even if the whole cluster crashes.

# An other usecase for storage is if one of your application needs to read/write files,
# you'll then need a storage to store all those files and let all the applications access that directory.

# Persistent Volume

# A persistent volume is a k8s component meant to store datas.
# You create it using a Yaml file (here is an example with an NFS storage)

# apiVersion: v1
# kind: PersistentVolume
# metadata:
#   name: foo-pv
# spec:
#   capacity:
#     storage: 5Gi # how much GiB we want
#   volumeMode: Filesystem
#   accessModes:
#     - ReadWriteOnce # read/write or readOnly mode
#   persistentVolumeReclaimPolicy: Recycle
#   storageClassName: slow
#   mountOptions:
#     - hard
#     - nfsvers=4.0
#   nfs:    # storage parameter
#     path: /path/to/fir/on/nfs/srv
#     server: nfs-server-ip

# an other example using google cloud as a storage

# apiVersion: v1
# kind: PersistentVolume
# metadata:
#   name: foo-pv
# spec:
#   capacity:
#     storage: 500Gi
#   accessModes:
#   - ReadWriteOnce
#   gcePersistentDisk:
#     pdName: cld-data-disk
#     fsType: xfs

# For a local storage

# apiVersion: v1
# kind: PersistentVolume
# metadata:
#   name: foo-pv
# spec:
#   capacity:
#     storage: 500Gi
#   volumeMode: Filesystem
#   accessModes:
#   - ReadWriteOnce
#   persistentVolumeReclaimPolicy: Delete
#   storageClassName: local-storage
#   local:
#     path: /path/to/mount/dir
#   nodeAffinity:
#     required:
#       nodeSelectorTerms:
#       - matchExpressions:
#         - key: kubernetes.io/hostname
#           operator: In
#           values:
#           - exmpl-node

# A persistent volume must use a storage like a physical disk, an nfs server or cloud storage.
# The problem here is who makes that drive available to the cluster ? 
# K8s does not care about the storage itself, the persistent volume is an interface to that storage
# and it is up to you to get that storage available and back it up, ...

# So a storage is like an external plugin to your k8s cluster.

# You can have multiple storage in a k8s cluster. Where an application can use one or multiple storages.

# !!!! Persistent Volumes are not namespaced so they can't be assigned to a namespace they're available to 
# the whole cluster.

# Local or Remote ?

# A local volume is tied to a specific node, and does not survives in cluster crashes.
# So for database persistance you should ALWAYS use remote storage (nfs/or cloud)

# K8s Admin & User

# there are usually two type of users in a k8s cluster. The administrator, that setup and maintains the cluster
# And the user, that deploys applications in the cluster.

# So the administrator is usually a system administrator or a devops engineer.
# and the user are usually the developers & devops teams.

# The admin will assure that the storage is there and connected, and the developper will need to claim the volume
# With an other component (Persistent Volume Claim)

# Persistent Volume Claim

# here is an example of a yml config for a Persistent Volume Claim

# apiVersion: v1
# kind: PersistentVolumeClaim
# metadata:
#   name: foo-pvc
# spec:
#   storageClassName: manual
#   volumeMode: Filesystem
#   accessModes:
#     - ReadWriteOnce   # mode rw/r only, ...
#   resources:
#     requests:
#       storage: 20Gi # capacity claimed

# you will also need to declare that PVC inside the pod configuration :

# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: app
# spec:
#   selector:
#     matchLabels:
#       app: app
#   template:
#     metadata:
#       labels:
#         app: app
#     spec:
#       containers:
#         - name: app
#           image: backend-img
#           volumeMounts:
#             - mountPath: "/var/www/html/tmp"
#               name: app-volume
#       volumes:
#         - name: app-volume
#           persistentVolumeClaim:
#             claimName: foo-pvc

# the way it works is that what ever Persistent Volume matches that claim will be used as storage.
# !!! the claims must exist in the same namespace as the pod using it !!!

# Once the claim get a matching volume, that volume will be mounted into the pod. And then that
# volume can be mounted to the container inside the pod.


# The advantages to using a persistent volume and a persistent volume claim is that the user don't
# need to care about the volume itself, he just declare that he needs a volume of said size.
# The administrator then create the corresponding volume that are required by the application.
# So the user does not need to care where that storage is, only that it needs to exist.
# All of this simplify the life for developers.


# !!! ConfigMap & Secrets are two volumes but they're not created using a PV and PVC,
# but by their own components and managed by k8s itself.

# here is an example of a pod created with multiple volumes of different types.
# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: elastic
# spec:
#   selector:
#     matchLabels:
#       app: elastic
#   template:
#     metadata:
#       labels:
#         app: elastic
#     spec:
#       containers:
#       - image: elastic:latest
#         name: elastic-container
#         ports:
#         - containerPort: 9200
#         volumeMounts:
#         # list of mounted volumes
#         - name: es-persistent-storage
#           mountPath: /var/lib/data
#         - name: es-secret-dir
#           mountPath: /var/lib/secret
#         - name: es-config-dir
#           mountPath: /var/lib/config
#       volumes:
#       # persistent volume claim
#       - name: es-persistent-storage
#         persistentVolumeClaim:
#           claimName: es-pv-claim
#       # secret volume
#       - name: es-secret-dir
#         secret:
#           secretName: es-secret 
#       # config map volume
#       - name: es-config-dir
#         configMap:
#           name: es-config-map

# for a secret and a config map 
# apiVersion: v1
# kind: Secret
# metadata:
#   name: my-secret
# type: Opaque
# data:
#   username: dXNlcm5hbWU=  # base64-encoded username
#   password: cGFzc3dvcmQ=  # base64-encoded password

# if we mount this secret into the /var/lib/secret
# you'll find two files in that directory :
#   - username -> containing its value
#   - password -> containing the password value
# !!! keep in mind that it is up to your application to decode the base64 encoding.

# Storage Class

# The storage class will create volumes dynamically when a pvc demands a volume.
# this avoid the sys admin to have to create n new volumes each time they deploy n new applications.
# As for every configuration with k8s we use a yaml file :

# apiVersion: storage.k8s.io/v1
# kind: StorageClass
# metadata:
#   name: app-storage-class
# provisioner: kubernetes.io/aws-ebs # the provisioner is a k8s which provisioner to use
                                     # for a specific storage platform
                                     # it is in two part kubernetes.io -> prefix (internal provisioner)
                                     # aws-ebs -> external provisioner. You will find these in the documentation
                                     # of that specific provisioner (here aws -> amazon)
                                     # it is like a plugin driver for a storage
# parameters:
#   type: io1 #  type of EBS volume optimized for high I/O performance.
#   iopsPerGB: "10" # Input/Output Operations Per Second
#   fsType: ext4

# apiVersion: v1
# kind: PersistentVolumeClaim
# metadata:
#   name: foo-pvc
# spec:
#   storageClassName: app-storage-class # reference to the storage class 
#   volumeMode: Filesystem
#   accessModes:
#     - ReadWriteOnce   # mode rw/r only, ...
#   resources:
#     requests:
#       storage: 20Gi # capacity claimed

###########################################################################
# DEPLOYING STATFUL APP
###########################################################################

# a stateful set is a component use for a stateful application, for example a database.
# A stateful application is an application that store data to keep track of its state.

# stateless application don't record state and each request depends only on the informations 
# that comes with it. (for example a backend server is a stateless application, but the database it
# uses is a stateful application).

# stateless are deployed using deployment components.
# stateful application are deployed with stateful set components.
# with a stateful set component you can replicate a stateful application.
# You can configure storage with both.

# if we can connect storage to both what is the difference ? 

# STATELESS

# a stateless pod are identical and interchangeable, they are created in random order and random hashes (app-f3c526e)
# one service load balance those pods, and if one or multiple pods needs to be deleted, it will randomly select one
# pod to be deleted.

# STATEFUL

# a stateful pod cannot be created/deleted at the same time and cannot be randomly addressed.
# the reason is that the replica of a stateful pod are not identical.

# POD IDENTITY

# it maintains a sticky identity for each pods, 
# So these pods are created from the same specification but are not interchangeable.
# The identifier is persisted across any re-scheduling.

# why do the pods needs their own identity ?

# For example each database pod will be use to read and write data.
# But the problem is that if there are two pods of the same database, each might read/write
# at the same time, and you'll then end up with data inconsistency.

# So there is a mecanism that allows only one pod to write data at a time.
# The pod that is allowed to update the data is called the master pod, the other are worker pod.
# Even if they use the same data, they do not have access to the same physical storage !
# Each pod have their replica of the storage. 
# So each pod must have the same data as the other ones and to achieve that we use continuous synchronization
# of the data.
# So once the master has update its data, all the worker will synchronize their data with the master data.

# When we create a new replica of a stateful pod, it will first clone the storage from the previous pod
# Once it has up to date data, it will start continuous synchronization.

# So technically you could use only data inside the pods, as it is replicated, but that would mean that if
# the cluster crashes, then you'll lose all the datas. So it is a pretty bad idea.
# So it is important to use persistent data storage.

# So something important is that if a pod dies, k8s will take care that the persistent volume will be reattached 
# to the newly created pod that reaplace it, and that that pod has the same state and id as the one that crashed.
# So for these reattachment to work it is important to use a remote storage, as if you use a local storage and the
# node crashes, then you won't be able to reattach the storage to the pod.

# contrary to deployment that gets random hashes as identifier, stateful set pods get a fix ordered name :
# {statefulset name}-{ordinal} the ordinal starts from 0 and each pod will increase its value by 1.
# With stateful set pods, the next pod won't be created while the previous one is not up and running.

# deletion works in reverese order, so the last pod is deleted first and the last pod to be deleted will be 
# the master pod (id 0). As for creation, when a deletion is done it will wait that the pod is correctly 
# deleted before deleting the next one.

# Stateful pods will also have individual DNS name for each pods, contrary to the deployment pods.
# {podname}.{governing service domain}

# so a stateful set have a preditable pod name and a fixed individual dns
# that way, the ip address will change, but the name and enpoint will stay the same.
# that is the meaning of a sticky identity, so that guaranty that the pod retain its state and role
# even after a crash.

# All of that add a lot of complexity to the pod creation, k8s will help you on part of it but you still
# have much to do by yourself such as :
#   - configuring the cloning and data synchronization
#   - make the remote storage available.
#   - managing back-up

# The fact is that stateful application are not perfect for containerized environment.

###########################################################################
# SERVICES 
###########################################################################

# WIth k8s each pod has its own ip address, but as the pods are ephemeral, that means that
# each time a pod is destroyed and a new one is created, which happened frequently, then it
# lose its ip address and a new one is assigned to the new pod.
# The ip addresses will be assign to the pod from a pool assigned to the node, so each node
# has a range of ip address that he can assign inside the cluster.
# SO for example you can have an IP address 10.0.1.N in the first node and an ip address of 
# 10.0.2.N in the second node.

# So that would mean that you would need to adjust the ip address each time a pod is recreated.

# With a service that assure that you'll have a static IP address for each pod connected through that service.
# So we will use the service as its ip address will never change.

# The service has also a load balancing feature. So it will check which pod the request should be forwarded 
# depending on the workload of each pod.

# When creating a service, k8s will create a endpoint object, and that object will keep track of the pods
# that are members (or endpoint) of that service. The endpoint linked to a service will have the same
# name as the service.
kubectl get endpoints

# A service can have multiple ports open and redirect each port to a specific port on its endpoints.

# example of multi port service :
# apiVersion: v1
# kind: Service
# metadata:
#   name: mongo-service
# spec:
#   selector:
#     app: mongo
#   ports:
#     - name: mongo # !! if you've multiple ports, you need to name them !
#     - protocol: TCP
#       port: 27017 # service port 
#       targetPort: 27017 # pod port. ! it has to match the application container port.
#     - name: exporter
#     - protocol: TCP
#       port: 9216
#       targetPort: 9216


# ClusterIP

# Service default type.
# each service type will have a static IP address, and a port defined for the communication.
# a service identify its connected pods via a selector attribute.
# you can have multiple selectors, and the service is connected to the pods that matches all
# the selector not just one.

# apiVersion: v1
# kind: Service
# metadata:
#   name: mongo-service
# spec:
#   selector:
#     app: mongo
#   ports:
#     - protocol: TCP
#       port: 27017 # service port 
#       targetPort: 27017 # pod port. ! it has to match the application container port.


# Headless

# Headless service help if you want to communicate with 1 specific pod directly
# or if one pod want to talk directly to an other pod
# The Cluster IP service, will randomly select which pod it will send to request to,
# so you might end up communicating with the wrong pod.
# We use that when we want to communicate with a stateful application,
# as stateful application are not identical and only the master is allowed to write to
# the database.

# If the clusterIp is set to None, then the DNS server will
# return the IP address of the pod instead of his own. So we can use a DNS lookup to find the pods
# that are member of that service. And so we can use that to select a specific pod to connect to or
# to send a request to all the pods.

# apiVersion: v1
# kind: Service
# metadata:
#   name: mongo-service
# spec:
#   clusterIp: None # to create a headless service.
#   selector:
#     app: mongo
#   ports:
#     - protocol: TCP
#       port: 27017 # service port 
#       targetPort: 27017 # pod port. ! it has to match the application container port.

# We will tend to always have a clusterIp and a headless service side by side.
# So in the case of a stateful pods, the ClusterIP service will be use for the communication from and to
# stateless application, and headless service will be use for the communication between the master and 
# its worker, eg for data synchronization.


# Service TYPES

# there are three types of service : 
#   - ClusterIP (default) -> for internal service 
#   - NodePort -> external
#   - LoadBalancer -> external

# NodePort

# a node port service will create a static port accessible on each node of a cluster.
# So contrary to the clusterIP service, that is only accessible inside the cluster,
# the NodePort is accessible from outside of the cluster.

# apiVersion: v1
# kind: Service
# metadata:
#   name: webapp-service
# spec:
#   # type: ClusterIp # default type => internal
#   type: NodePort # create external service
#   selector:
#     app: webapp # THIS ONE IS LINK TO THE DEPLOYMENT LABEL
#   ports:
#     - protocol: TCP
#       port: 3000 # internal port 
#       targetPort: 3000 # target port of the pod
#       nodePort: 30000 # must be between 30000 -> 32767
#                       # this is the external port for that service

# so to access a service from outside, we will need to contact the ip address of the service at the node port 
# it will then forward it to one of the pod replica.
# That type of service exposure is unsafe and not very efficient as you're opening the port to directly talk
# to the node so an external client has access directly to the worker node.

# LoadBalancer

# with a loadBalancer service type, the service (and not the nodes) become accessible externally.
# So this service still opens a node port but it is not accessible externally but only through 
# the load balancer. So now the entry point is the load balancer and not a node.
# So the LoadBalancer service is an extension to the Nodeport which is an extension to the ClusterIp type.
# !!! You'll not use Nodeport in production, you'll either use a loadBalancer type or an ingress.

# apiVersion: v1
# kind: Service
# metadata:
#   name: mongo-express-service
# spec:
#   # type: ClusterIp # default type => internal
#   type: LoadBalancer # create external service
#   selector:
#     app: mongo-express # THIS ONE IS LINK TO THE DEPLOYMENT LABEL
#   ports:
#     - protocol: TCP
#       port: 8081 # internal port 
#       targetPort: 8081 # target port of the pod
#       nodePort: 30000 # must be between 30000 -> 32767
#                       # this is the external port for that service