# microgram-fe

Frontend service for the [microgram](https://github.com/oswaldoferreira/microgram) project. 

### Development

Run locally:

```
docker build --build-arg mode=dev -t microgram-fe .
docker run -p 4200:80 microgram-fe:latest
```

### Kubernetes example

The `deployment.yml`. The infrastructure bit creation is up to the platform being used (e.g. AWS EKS):

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: microgram-fe
spec:
  replicas: 1
  selector:
    matchLabels:
      app: microgram-fe
  template:
    metadata:
      labels:
        app: microgram-fe
    spec:
      containers:
        - name: microgram-fe-app
          image: olsfer/microgram-fe:latest
          imagePullPolicy: Always
          ports:
            - name: web
              containerPort: 8080
              protocol: TCP
```

The `service.yml` with a simple load balancer. The infrastructure bit creation is up to the platform being used (e.g. AWS ELB).

```yml
apiVersion: v1
kind: Service
metadata:
  name: microgram-fe-svc
spec:
  type: LoadBalancer
  selector:
    app: microgram-fe
  ports:
    - protocol: TCP
      port: 80
```

Apply both to the Kubernetes cluster:

```
kubectl apply -f deployment.yml
kubectl apply -f load_balancer.yml

› kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
microgram-fe-5f6fc7b9cf-qtz5n     1/1     Running   0          17m
```
