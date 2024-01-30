# 1.Alura

### Kubernetes (ORQUESTRADOR DE CONTAINERS)
<br />

**Anotações**<br>
    *ReplicaSet = Mantém o número de pods Ready equivalente ao Desired. Caso um pod dê erro o mesmo é substituído automaticamente.*<br>
    *Deployment = Camada acima de um ReplicaSet. Quando cria um Deployment automaticamente cria-se um ReplicaSet. Permite controle de versionamento das imagens e pods.
    Mais comum é utilizado o Deployment ao invés do ReplicaSet.*<br>
    *Persistência de dados = Os dados persistem enquanto houver no mínimo um container em funcionamento no pod.*<br>
    *Volumes (hostPath) = Bindar o volume de fora para dentro do pod, assim mesmo que os containers morram e o pod também, os arquivos permanecerão intactos.*<br>
    *Storage Classes = É possível criar Volumes, Persistent Volumes, no caso, e discos dinamicamente.*<br>
    *Stateful Set = Conteúdo do pod não é perdido ao ser reciclado. Ele é voltado para aplicações a Pods que devem manter o seu estado que eles são Stateful.*<br>
    *Liveness Probe = "Prova de vida" de que uma aplicação dentro de um pod está funcionando. Quando houver um problema na aplicação o kubernetes saberá quando reciclar o container.*<br>
    *Readiness Probes = O SVC só envia novas requisições para o container somente após ele estar 100% iniciado.*<br>
    *Para utilização do HPA, se faz necessário possuir um servidor de métricas.*<br>
<br />

**Conhecendo ReplicaSets**<br>
*PowerShell*
```
https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/
---
Criar portal-noticias-replicaset.yml

apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: portal-noticias-replicaset
spec:
  template:
    metadata:
      name: portal-noticias
      labels:
        app: portal-noticias
    spec:
      containers:
        - name: portal-noticias-container
          image: aluracursos/portal-noticias:1
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: portal-configmap
  replicas: 3
  selector:
    matchLabels:
      app: portal-noticias (aqui é informado qual pod deve ser aplicado este ReplicaSet. deve ser igual ao labels mais acima)
---

> kubectl delete pods portal-noticias
> kubectl apply -f .\portal-configmap.yaml
> kubectl apply -f .\sistema-configmap.yaml
> kubectl apply -f .\sistema-noticias.yaml
> kubectl apply -f .\db-noticias.yaml
> kubectl apply -f .\portal-noticias-replicaset.yml
> kubectl get replicasets
> kubectl delete pods <NAME_pod> (irá deletar o pod, e o ReplicaSet irá recriá-lo)

```
<br />

**Conhecendo Deployments**<br>
*PowerShell*
```
---
Criar nginx-deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-eployment
spec:
  replicas: 3
  template:
    metadata:
      name: nginx-pod
      labels:
        app: nginx-pod
    spec:
      containers:
        - name: nginx-container
          image: nginx:stable
          ports:
            - containerPort: 80
  selector:
    matchLabels:
      app: nginx-pod
---

> kubectl apply -f .\nginx-deployment.yaml
> kubectl get deployments
> kubectl rollout history deployment nginx-deployment (mostra a versão atual)

---
Alterar nginx-deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-eployment
spec:
  replicas: 3
  template:
    metadata:
      name: nginx-pod
      labels:
        app: nginx-pod
    spec:
      containers:
        - name: nginx-container
          image: nginx:latest
          ports:
            - containerPort: 80
  selector:
    matchLabels:
      app: nginx-pod
---

> kubectl apply -f .\nginx-deployment.yaml --record
> kubectl rollout history deployment nginx-deployment (mostra a nova versão após ter alterado para latest)
> kubectl annotate deployment nginx-deployment kubernetes.io/change-cause="Definindo a imagem com a versão latest"
> kubectl rollout history deployment nginx-deployment
> kubectl undo deployment nginx-deployment --to-revision=1 (retorna o deployment para a versão 1 conforme o history deployment)
> kubectl apply -f 
```
<br />

**Conhecendo Deployments**<br>
*PowerShell*
```
https://kubernetes.io/docs/concepts/storage/volumes/
---
Criar nginx-deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-eployment
spec:
---

```
<br />

**Persistência de dados**<br>
*PowerShell*
```
Obs: Windows necessário desativar o WSL no Docker e adicionar em Resources > File Sharing a pasta a ser bindada

Obs: Linux acessar minikube
  cd /home
  sudo mkdir primeiro-volume

---
Criar pod-volume.yaml

apiVersion: v1
kind: Pod
metadata:
  name: pod-volume
spec:
  containers: 
    - name: nginx-container
      image: nginx:latest
      volumeMounts:
        - mountPath: /volume-dentro-do-container
          name: primeiro-volume
    - name: jenkins-container
      image: jenkins:alpine
      volumeMounts:
        - mountPath: /volume-dentro-do-container
          name: primeiro-volume
  volumes:
    - name: primeiro-volume
      hostPath:
        path: /C/Users/Fabio/Desktop/primeiro-volume
        type: Directory

Criar pod-volume.yaml (Exemplo Linux)

apiVersion: v1
kind: Pod
metadata:
  name: pod-volume
spec:
  containers: 
    - name: nginx-container
      image: nginx:latest
      volumeMounts:
        - mountPath: /volume-dentro-do-container
          name: primeiro-volume
    - name: jenkins-container
      image: jenkins:alpine
      volumeMounts:
        - mountPath: /volume-dentro-do-container
          name: primeiro-volume
  volumes:
    - name: primeiro-volume
      hostPath:
        path: /home/segundo-volume
        type: DirectoryOrCreate (neste exemplo o pod-volume cria o diretório caso não exista)
---

> kubectl apply -f .\pod-volume.yaml
> kubectl get pods
> kubectl exec -it pod-volume --container nginx-container -- bash
  # ls (exibe o volume dentro do container já montado)
  # cd volume-dentro-do-container 
  # touch arquivo.txt (irá criar arquivo dentro de C:/Users/Fabio/Desktop/primeiro-volume)

```
<br />

**Liveness Probes**<br>
*PowerShell*
```
https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/

No exemplo abaixo o container será reciclado se o retorno for menor que 200 ou maior/igual a 400.
---
Editar portal-noticias-deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: portal-noticias-deployment
spec:
  template:
    metadata:
      name: portal-noticias
      labels:
        app: portal-noticias
    spec:
      containers:
        - name: portal-noticias-container
          image: aluracursos/portal-noticias:1
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: portal-configmap
          livenessProbe:
            httpGet:
              path: / (irá verificar o endereço localhost)
              port: 80 (apesar de acessarmos o svc via 30000 a aplicação está rodando na 80 do pod)
            periodSeconds: 10 (verifica de 10 em 10 segundos o status da aplicação)
            failureThrehold: 3 (recicla o container após três falhas)
            initialDelaySeconds: 20 (define a partir de quando o livenessProbe iniciará a checagem da aplicação, neste caso somente após 20 segundos depois do container em execução)
  replicas: 3
  selector:
    matchLabels:
      app: portal-noticias
```
<br />

**Readiness Probes**<br>
*PowerShell*
```
https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/
---
Editar portal-noticias-deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: portal-noticias-deployment
spec:
  template:
    metadata:
      name: portal-noticias
      labels:
        app: portal-noticias
    spec:
      containers:
        - name: portal-noticias-container
          image: aluracursos/portal-noticias:1
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: portal-configmap
          livenessProbe:
            httpGet:
              path: /
              port: 80
            periodSeconds: 10
            failureThrehold: 3 
            initialDelaySeconds: 20
          readnessProbe: (saberá que o container está com a aplicação pronta, quando o retorno do http for satifatório após 3 segundos)
            httpGet:
              path: /
              port: 80
            periodSeconds: 10
            failureThrehold: 5
            initialDelaySeconds: 3
  replicas: 3
  selector:
    matchLabels:
      app: portal-noticias
```
<br />

**Horizontal Pod Auto Scalling**<br>
*PowerShell*
```
https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
---
Editar portal-noticias-deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: portal-noticias-deployment
spec:
  template:
    metadata:
      name: portal-noticias
      labels:
        app: portal-noticias
    spec:
      containers:
        - name: portal-noticias-container
          image: aluracursos/portal-noticias:1
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: portal-configmap
          livenessProbe:
            httpGet:
              path: / 
              port: 80
            periodSeconds: 10
            failureThrehold: 3
            initialDelaySeconds: 20
          readnessProbe:
            httpGet:
              path: /
              port: 80
            periodSeconds: 10
            failureThrehold: 5
            initialDelaySeconds: 3
          resources:
            requests:
              cpu: 10m (minimo necessário para funcionar)
  replicas: 3
  selector:
    matchLabels:
      app: portal-noticias
---

---
Criar portal-noticias-hpa.yaml

apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: portal-noticias-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1 (versão do portal-noticias-deployment.yaml)
    kind: Deployment
    name: portal-noticias-deployment
  minReplicas: 1 (número mínimo de replicas para este deployment)
  maxReplicas: 10 (número máximo de replicas para este deployment, conforme aumento de requisições)
  metrics:
    - type: Resources
      resources:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50 (se consumo médio da aplicação chegar a mais de 50% de utilização da cpu - equivalente a 5m, conforme definido 10m no portal-noticias-deployment.yaml)
---

> kubectl apply -f .\portal-noticias-deployment.yaml
> kubectl apply -f .\portal-noticias-hpa.yaml
> kubectl get hpa
```
<br />

**Utilizando HPA**<br>
*PowerShell*
```
https://github.com/kubernetes-sigs/metrics-server
https://github.com/kubernetes-sigs/metrics-server/releases (download components.yaml)
https://caelum-online-public.s3.amazonaws.com/1916-kubernetes/stress.zip (download script de stress)
https://kubernetes.io/docs/tutorials/hello-minikube/ (Linux - Extensões)
https://caelum-online-public.s3.amazonaws.com/1916-kubernetes/stress.zip (download script de stress para Linux)
---
Editar components.yaml

Incluir em args:
  - --kubelet-insecure-tls

---

> kubectl apply -f .\components.yaml
> kubectl get hpa (aguardar para que o HPA consiga definir o "TARGETS" corretamente)

Git Bash (2x) - aumentando mais execuções de stress irá aumentar o consumo e automaticamente o HPA irá criar mais replicas
  $ sh stress.sh 0.001 > out.txt


> kubectl get hpa -- watch

!!! Linux !!!

$ minikube addons list (lista todas as extensões habilitadas e desabilitadas)
$ minikube addons enable metrics-server (ativao servidor de metricas)
$ bash stress.sh 0.001 > out.txt
$ kubectl get hpa -- watch
```
<br />