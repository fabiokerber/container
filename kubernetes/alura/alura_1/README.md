# 1.Alura

### Kubernetes (ORQUESTRADOR DE CONTAINERS)
<br />

**Anotações**<br>
    *Escalabilidade Horizontal = incremento de servidores adicionais para aumentar capacidade. Mais máquinas trabalhando em paralelo.*<br>
    *Master = Control Plane*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;*Gerenciar cluster*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;*Manter e atualizar o estado desejado*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;*Receber e executar novos comandos*<br>
    *Node = Nodes*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;*Executar as aplicações*<br>
    *kubectl = Se comunica direto com a API via ReST*<br>
    *pod = Contêm um ou mais containers*<br>
    *Services*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;*Proveem IP's fixos para os pods. Independente do IP, os pods se comunicam via DNS.*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;*Proveem DNS para um ou mais pods.*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;*Capaz de fazer balanceamento de carga.*<br>
    *ClusterIP (Services)*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;*Serve apenas para viabilizar a comunicação INTERNA entre os diferentes pods dentro de um mesmo cluster.*
    *NodePort (Services)*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;*Serve apenas para viabilizar a comunicação EXTERNA para o Cluster(SVC).*
    *LoadBalancer (Services)*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;*Abre comunicação para o mundo externo usando o LoadBalancer do proverdor (AWS, GCP, Azure).*<br>
    *Deleção pods e serviços*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;*kubectl delete pods --all*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;*kubectl delete svc --all*<br>
<br />

**Início**<br>
*PowerShell*
```
> kubectl get nodes
```
<br />

**O primeiro pod**<br>
*PowerShell*
```
> kubectl run nginx-pod --image=nginx:latest (cria um pod de nome nginx-pod baseando-se na imagem mais recente do nginx)
> kubectl get nodes 
> kubectl get pods --watch (visualiza em tempo real)
> kubectl describe pod nginx-pod (exibe diversas informações sobre o pod nginx-pod)
> kubectl edit pod nginx-pod (edita as configurações do pod)
```
<br />

**Criando pods de maneira declarativa**<br>
*PowerShell*
```
---
Criar primeiro-pod.yaml

apiVersion: v1
kind: Pod
metadata:
  name: primeiro-pod-declarativo
spec:
  containers:
    - name: nginx-container
      image: nginx:latest
---

> kubectl apply -f primeiro-pod.yaml
> kubectl get pods

    image: nginx:latest

> kubectl apply -f primeiro-pod.yaml
> kubectl get pods --watch
```
<br />

**Iniciando o projeto**<br>
*PowerShell*
```
> kubectl delete pod nginx-pod
> kubectl delete -f primeiro-pod.yaml (deletando de forma declarativa. se baseia no metadata)

---
Criar portal-noticias.yaml

apiVersion: v1
kind: Pod
metadata:
  name: portal-noticias
spec:
  containers:
    - name: portal-noticias-container
      image: aluracursos/portal-noticias:1
---

> kubectl get pods --watch
> kubectl describe pod portal-noticias
> kubectl exec -it portal-noticias -- bash (conecta via ssh no container dentro do pod)
```
<br />

**Conhecendo services (SVC)**<br>
*PowerShell*
```
> kubectl get pods -o wide (exibe maiores informações sobre os pods em execução)
```
<br />

**Criando um Cluster IP**<br>
*PowerShell*
```
(pod-1 & portal-noticias <> ClusterIP/SVC <> pod-2)
---
Criar arquivo pod-1.yaml 

apiVersion: v1
kind: Pod
metadata:
  name: pod-1
  labels:
    app: primeiro-pod
spec:
  containers:
    - name: container-pod-1
      image: nginx:latest
      ports:
        - containerPort: 80 (requisição)
---

---
Criar arquivo pod-2.yaml 

apiVersion: v1
kind: Pod
metadata:
  name: pod-2
  labels:
    app: segundo-pod (label1. pode-se utilizar qualquer chave valor nestas labels)
    alura: cursos (label2)
spec:
  containers:
    - name: container-pod-2
      image: nginx:latest
      ports:
        - containerPort: 80 (requisição)
---

> kubectl apply -f .\pod-1.yaml
> kubectl apply -f .\pod-2.yaml
> kubectl apply -f .\portal-noticias.yaml

---
Criar arquivo svc-pod-2.yaml (Criaremos esse serviço ClusterIP para permitir comunicação entre todos os pods)

apiVersion: v1
kind: Service
metadata:
  name: svc-pod-2
spec:
  type: ClusterIP
  selector: (binding)
    app: segundo-pod (quando receber requisição deve encaminhar para o "segundo-pod")
  ports:
    - port: 80 (SVC_OUVINDO)
      targetPort: 80 (SVC_ENCAMINHAR_PARA_QUEM_ESTIVER_LISTADO_SELECTOR)
---

> kubectl apply -f .\pod-2.yaml (ira atualizar com as alterações realizadas)
> kubectl apply -f .\svc-pod-2.yaml

> kubectl get svc
> kubectl exec -it pod-1 -- bash
  # curl <IP_SVC>:80

> kubectl exec -it portal-noticias -- bash
  # curl <IP_SVC>:80 (requisição respondida apontando para o svc)
(Se deletar o pod-2 então vai parar de funcionar, pois o SVC não terá para onde encaminhar a requisitção conforme configurado)
```
<br />

**Criando um NodePort**<br>
*PowerShell*
```
(Externo <> NodePort/SVC <> pod-1)
---
Criar svc-pod-1.yaml

apiVersion: v1
kind: Service
metadata:
  name: svc-pod-1
spec:
  type: NodePort
  selector:
    app: primeiro-pod
  ports:
    - port: 80
      nodePort: 30000
---

> kubectl apply -f .\pod-1.yaml
> kubectl apply -f .\svc-pod-1.yaml
> kubectl get svc -o wide
> kubectl get pods -o wide

http://localhost:30000
```
<br />

**LoadBalancer**<br>
*PowerShell*
```
(Provider Externo <> LoadBalancer <> pod-1)
---
Criado pod-1.yaml no cluster Kubernetes da AWS

apiVersion: v1
kind: Pod
metadata:
  name: pod-1
  labels:
    app: primeiro-pod
spec:
  containers:
    - name: container-pod-1
      image: nginx:latest
      ports:
        - containerPort: 80
---

---
Criado lb.yaml no cluster Kubernetes da AWS

apiVersion: v1
kind: Service
metadata:
  name: svc-pod-1-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: primeiro-pod
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30000
---

---
Criar svc-pod-1-loadbalancer.yaml

apiVersion: v1
kind: Service
metadata:
  name: svc-pod-1-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: primeiro-pod
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30000
---

> kubectl apply -f .\pod-1.yaml
> kubectl apply -f .\svc-pod-1.yaml
> kubectl get svc -o wide
> kubectl get pods -o wide

http://localhost:30000
```
<br />

**Portal Noticias**<br>
*PowerShell*
```
---
Alterado portal-noticias.yaml

apiVersion: v1
kind: Pod
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
---

---
Criado svc-portal-noticias.yaml

apiVersion: v1
kind: Pod
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
---

> kubectl apply -f .\portal-noticias.yaml
> kubectl apply -f .\svc-portal-noticias.yaml
> kubectl get svc -o wide
> kubectl get pods -o wide

http://localhost:30000 (Externo <> svc-portal-noticias <> portal-noticias)
```
<br />

**Sistema Noticias**<br>
*PowerShell*
```
---
Criado sistema-noticias.yaml

apiVersion: v1
kind: Pod
metadata:
  name: sistema-noticias
  labels:
    app: sistema-noticias
spec:
  containers:
    - name: sistema-noticias-container
      image: aluracursos/sistema-noticias:1
      ports:
        - containerPort: 80
---

---
Criado svc-sistema-noticias.yaml

apiVersion: v1
kind: Service
metadata:
  name: svc-sistema-noticias
spec:
  type: NodePort
  selector:
    app: sistema-noticias
  ports:
    - port: 80
      nodePort: 30001
---

> kubectl apply -f .\sistema-noticias.yaml
> kubectl apply -f .\svc-sistema-noticias.yaml
> kubectl get svc -o wide --watch
> kubectl get pods -o wide --watch

http://localhost:30001 (Externo <> svc-sistema-noticias <> sistema-noticias)
```
<br />

**Banco Noticias**<br>
*PowerShell*
```
---
Criado db-noticias.yaml

apiVersion: v1
kind: Pod
metadata:
  name: db-noticias
  labels:
    app: db-noticias
spec:
  containers:
    - name: db-noticias-container
      image: aluracursos/mysql-db:1
      ports:
        - containerPort: 3306
---

---
Criado svc-db-noticias.yaml

apiVersion: v1
kind: Service
metadata:
  name: svc-db-noticias
spec:
  type: ClusterIP
  selector:
    app: db-noticias
  ports:
    - port: 3306
---

> kubectl apply -f .\db-noticias.yaml
> kubectl apply -f .\svc-db-noticias.yaml
> kubectl get svc -o wide --watch
> kubectl get pods -o wide --watch
```
<br />

**Banco Noticias - Variaveis Instalação**<br>
*PowerShell*<br>
(https://hub.docker.com/_/mysql)
```
---
Editar db-noticias.yaml

apiVersion: v1
kind: Pod
metadata:
  name: db-noticias
  labels:
    app: db-noticias
spec:
  containers:
    - name: db-noticias-container
      image: aluracursos/mysql-db:1
      ports:
        - containerPort: 3306
      env:
        - name: "MYSQL_ROOT_PASSWORD"
          env: "q1w2e3r4"
        - name: "MYSQL_DATABASE"
          env: "empresa"
        - name: "MYSQL_PASSWORD"
          env: "q1w2e3r4"
---

> kubectl delete pod db-noticias
> kubectl apply -f .\db-noticias.yaml
> kubectl get svc -o wide --watch
> kubectl get pods -o wide --watch

> kubectl exec -it db-noticias -- bash
  # mysql -u root -p
  > show databases; (já configurado na imagem)
  > use empresa; (já configurado na imagem)
  > show tables; (já configurado na imagem)
  > select * from usuario; (já configurado na imagem)

> kubectl exec -it sistema-noticias -- bash
  # cat /var/www/html/bancodedados.php (variaveis de ambiente que devem constar no arquivo de criação do pod)
```
<br />

**Criando um ConfigMap**<br>
*PowerShell*
```
---
Criar db-configmap.yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: db-configmap
data:
  MYSQL_ROOT_PASSWORD: q1w2e3r4
  MYSQL_DATABASE: empresa
  MYSQL_PASSWORD: q1w2e3r4
---

---
Editar db-noticias.yaml

apiVersion: v1
kind: Pod
metadata:
  name: db-noticias
  labels:
    app: db-noticias
spec:
  containers:
    - name: db-noticias-container
      image: aluracursos/mysql-db:1
      ports:
        - containerPort: 3306
---

> kubectl apply -f .\db-configmap.yaml
> kubectl get configmap
> kubectl describe configmap db-configmap
```
<br />

**Aplicando o ConfigMap ao projeto**<br>
*PowerShell*
```
---
Editar db-noticias.yaml

apiVersion: v1
kind: Pod
metadata:
  name: db-noticias
  labels:
    app: db-noticias
spec:
  containers:
    - name: db-noticias-container
      image: aluracursos/mysql-db:1
      ports:
        - containerPort: 3306
      envFrom:
        - configMapRef: (como este confimap possui somente as variaveis para o db-noticias.yaml, foram importas todas)
          name: db-configmap
#      env: (forma de importar somente as variaveis necessarias de um arquivo que possui outros parametros adicionais)
#        - name: MYSQL_ROOT_PASSWORD
#          valueFrom:
#            configMapKeyRef:
#              name: db-configmap
#              key: MYSQL_ROOT_PASSWORD
---


> kubectl delete pod db-noticias
> kubectl apply -f .\db-noticias.yaml

---
Criar sistema-configmap.yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: sistema-configmap
data:
  HOST_DB: svc-db-noticias:3306 (esta variavel informara o valor de HOST_DB para o sistemas-noticas.yaml. neste caso o sistema-noticias.yaml ira visualizar o DNS do SVC, que por sua vez se comunica com o db-noticias)
  USER_DB: root
  PASS_DB: q1w2e3r4
  DATABASE_DB: empresa
---

> kubectl apply -f sistema-configmap.yaml

---
Editar sistema-noticias.yaml

apiVersion: v1
kind: Pod
metadata:
  name: sistema-noticias
  labels:
    app: sistema-noticias
spec:
  containers:
    - name: sistema-noticias-container
      image: aluracursos/sistema-noticias:1
      ports:
        - containerPort: 80
      envFrom:
        - configMapRef: (como este confimap possui somente as variaveis para o db-noticias.yaml, foram importas todas)
            name: sistema-configmap
---

> kubectl delete pod sistema-noticias
> kubectl apply -f .\sistema-noticias.yaml

> kubectl exec -it portal-noticias -- bash
  # cat /var/www/html/configuracao.php

---
Criar portal-configmap.yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: portal-configmap
data:
  IP_SISTEMA: http://localhost:30001
  #IP_SISTEMA: http://<INTERNAL-IP>:30001 (Linux = kubectl get nodes -o wide)
---

> kubectl apply -f .\portal-configmap.yaml

---
Editar portal-noticias.yaml

apiVersion: v1
kind: Pod
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
---

> kubectl delete pod portal-noticias
> kubectl apply -f .\portal-noticias.yaml
```

*http://localhost:30001* (admin, admin) - Insere notícia<br>
*http://localhost:30000* - Visualiza notícia

***Resultado final:***<br> <img src="https://github.com/fabiokerber/lab/blob/main/images/211220211544.PNG">
<br />