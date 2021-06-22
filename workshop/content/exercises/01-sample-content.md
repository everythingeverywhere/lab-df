This is an example page for exercises to be done for the workshop. You would remove this page, replace it with your own and then adjust the `workshop.yaml` and `modules.yaml` file to list your pages instead.

In this example the pages which make up the core of the workshop content are placed in a sub directory. This is only done as a suggestion. You can place all pages at the same directory level if you wish.

Included below are some tests and examples of page formatting using Markdown.

#### Download the Spring Cloud Data Flow source code

```execute-1
git clone https://github.com/spring-cloud/spring-cloud-dataflow
cd spring-cloud-dataflow
git checkout main
```

```execute-2
# Choose message broker rabbitmq vs kafka
kubectl create -f ~/spring-cloud-dataflow/src/kubernetes/rabbitmq/
# to verify
kubectl get all -l app=rabbitmq


# Deploy Services, Skipper, and Data Flow

# Deploy MySQL
kubectl create -f ~/spring-cloud-dataflow/src/kubernetes/mysql

#Create Data Flow Role Bindings and Service Account
kubectl create -f ~/spring-cloud-dataflow/src/kubernetes/server/server-roles.yaml
kubectl create -f ~/spring-cloud-dataflow/src/kubernetes/server/server-rolebinding.yaml
kubectl create -f ~/spring-cloud-dataflow/src/kubernetes/server/service-account.yaml

#To use RabbitMQ as the messaging middleware, run the following command
kubectl create -f ~/spring-cloud-dataflow/src/kubernetes/skipper/skipper-config-rabbit.yaml
```
--skipper

Select text to change
```editor:select-matching-text
file: ~/spring-cloud-dataflow/src/kubernetes/skipper/skipper-svc.yaml
text: "LoadBalancer"
```

```editor:replace-text-selection
file: ~/spring-cloud-dataflow/src/kubernetes/skipper/skipper-svc.yaml
text: ClusterIP
```

```execute-2
kubectl apply -f ~/spring-cloud-dataflow/src/kubernetes/skipper/skipper-svc.yaml
kubectl create -f ~/spring-cloud-dataflow/src/kubernetes/skipper/skipper-deployment.yaml
```

Click below to create your `ingress.yaml`.
```editor:append-lines-to-file
file: ~/ingress-skipper.yaml
text: |
      apiVersion: networking.k8s.io/v1
      kind: Ingress
      metadata:
        name: skipper
        labels:
          app: skipper
      spec:
        rules:
        - host: skipper-{{ session_namespace }}.{{ ingress_domain }}
          http:
            paths:
            - path: "/"
              pathType: Prefix
              backend:
                service:
                  name: skipper
                  port: 
                    number: 80
```

Now, apply the `ingress.yaml`.
```execute-2
kubectl apply -f ~/ingress-skipper.yaml
```

---scdf

Select text to change
```editor:select-matching-text
file: ~/spring-cloud-dataflow/src/kubernetes/server/server-svc.yaml
text: "LoadBalancer"
```

```editor:replace-text-selection
file: ~/spring-cloud-dataflow/src/kubernetes/server/server-svc.yaml
text: ClusterIP
```

Click below to create your `ingress.yaml`.
```editor:append-lines-to-file
file: ~/ingress-scdf-server.yaml
text: |
      apiVersion: networking.k8s.io/v1
      kind: Ingress
      metadata:
        name: scdf-server
        labels:
          app: scdf-server
      spec:
        rules:
        - host: scdf-server-{{ session_namespace }}.{{ ingress_domain }}
          http:
            paths:
            - path: "/"
              pathType: Prefix
              backend:
                service:
                  name: scdf-server
                  port: 
                    number: 80
```

Now, apply the `ingress.yaml`.
```execute-2
kubectl apply -f ~/ingress-scdf-server.yaml
```

```execute-2
# To create the configuration map with the default settings, run the following command
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/server/server-config.yaml

#Now you need to create the server deployment
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/server/server-svc.yaml
kubectl create -f ./spring-cloud-dataflow/src/kubernetes/server/server-deployment.yaml
```