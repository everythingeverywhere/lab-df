#! /bin/bash

git clone https://github.com/spring-cloud/spring-cloud-dataflow
cd spring-cloud-dataflow
git checkout main

# Choose message broker rabbitmq vs kafka
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/rabbitmq/
# to verify
kubectl get all -l app=rabbitmq


# Deploy Services, Skipper, and Data Flow

# Deploy MySQL
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/mysql

# Enable Monitoring

# Create the cluster role, binding, and service account for Prometheus
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/prometheus/prometheus-clusterroles.yaml
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/prometheus/prometheus-clusterrolebinding.yaml
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/prometheus/prometheus-serviceaccount.yaml

#deploy Prometheus RSocket Proxy
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/prometheus-proxy

# to deploy Prometheus
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/prometheus/prometheus-configmap.yaml
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/prometheus/prometheus-deployment.yaml
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/prometheus/prometheus-service.yaml


# to deploy Grafana
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/grafana/

# #to verify
kubectl get all -l app=grafana

#Create Data Flow Role Bindings and Service Account
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/server/server-roles.yaml
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/server/server-rolebinding.yaml
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/server/service-account.yaml

#To use RabbitMQ as the messaging middleware, run the following command
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/skipper/skipper-config-rabbit.yaml

#to start Skipper as the companion server for Spring Cloud Data Flow
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/skipper/skipper-deployment.yaml
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/skipper/skipper-svc.yaml

# To create the configuration map with the default settings, run the following command
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/server/server-config.yaml

#Now you need to create the server deployment
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/server/server-svc.yaml
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/server/server-deployment.yaml