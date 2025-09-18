# Project Working Screenshots

Here are some working screenshots of the project:

## Screenshots

### Screenshot 1
![Screenshot 1](working-ss/1.png)

### Screenshot 2
![Screenshot 2](working-ss/2.png)

### Screenshot 3
![Screenshot 3](working-ss/3.png)

### Screenshot 4
![Screenshot 4](working-ss/4.png)

### Screenshot 5
![Screenshot 5](working-ss/5.png)

### Screenshot 6
![Screenshot 6](working-ss/6.png)

### Screenshot 7
![Screenshot 7](working-ss/7.png)

### Screenshot 8
![Screenshot 8](working-ss/8.png)

### Screenshot 9
![Screenshot 9](working-ss/9.png)

### Screenshot 10
![Screenshot 10](working-ss/10.png)

### Screenshot 11
![Screenshot 11](working-ss/11.png)

### Screenshot 12
![Screenshot 12](working-ss/12.png)

### Screenshot 13
![Screenshot 13](working-ss/13.png)

### Screenshot 14
![Screenshot 14](working-ss/14.png)

### Screenshot 15
![Screenshot 15](working-ss/15.png)

### Screenshot 16
![Screenshot 16](working-ss/16.png)

### Screenshot 17
![Screenshot 17](working-ss/17.png)

### Screenshot 18
![Screenshot 18](working-ss/18.png)

### Screenshot 19
![Screenshot 19](working-ss/19.png)

### Screenshot 20
![Screenshot 20](working-ss/20.png)

### Screenshot 21
![Screenshot 21](working-ss/21.png)

### Screenshot 22
![Screenshot 22](working-ss/22.png)

### Screenshot 23
![Screenshot 23](working-ss/23.png)




kubectl delete pv mysql-pv

kubectl get pvc -n ashapp

kubectl delete pvc mysql-storage-mysql-0 -n ashapp

kubectl delete pv mysql-pv




DOCKER_HUB_USERNAME

DOCKER_HUB_ACCESS_TOKEN




/
kubectl get namespace ashapp -o json > ashapp-latest.json

nano ashapp-latest.json

make like this: -
"spec": {
  "finalizers": []
}

kubectl replace --raw "/api/v1/namespaces/ashapp/finalize" -f ./ashapp-latest.json

kubectl get ns

rm ashapp-latest.json

cd backend

docker build -t ashwanth01/flask-app:latest .

docker push ashwanth01/flask-app:latest


docker build -t ashwanth01/deployer-app:latest -f deployer-dockerfile .

docker push ashwanth01/deployer-app:latest


cd history-services

docker build -t ashwanth01/history-service:latest .

docker push ashwanth01/history-service:latest


cd ../database

docker build -t ashwanth01/flask-monitor:latest .

docker push ashwanth01/flask-monitor:latest


cd ../history-service

docker build -t ashwanth01/history-service:latest .

docker push ashwanth01/history-service:latest



docker build -t ashwanth01/ashapp-backend:latest .

docker run -d --name ashapp-backend \
  -p 5000:5000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(which docker):/usr/bin/docker \
  -v $(which kubectl):/usr/bin/kubectl \
  -v $HOME/.kube:/home/appuser/.kube \
  -e KUBECONFIG=/home/appuser/.kube/config \
  --user root \
  ashwanth01/ashapp-backend:latest






docker buildx build --platform linux/amd64 -t ashwanth01/history-service:latest .







