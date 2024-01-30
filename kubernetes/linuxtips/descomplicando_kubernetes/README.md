# Kubernetes

## Links
https://github.com/badtuxx/CertifiedContainersExpert<br>
https://github.com/badtuxx/CertifiedContainersExpert/tree/main/DescomplicandoKubernetes<br>
https://kind.sigs.k8s.io/docs/user/quick-start/<br>
https://k8s-examples.container-solutions.com/examples/Deployment/Deployment.html<br>
https://stackoverflow.com/questions/33887194/how-to-set-multiple-commands-in-one-yaml-file-with-kubernetes<br>
https://github.com/techiescamp/vagrant-kubeadm-kubernetes/tree/main<br>
https://www.weave.works/docs/net/latest/kubernetes/kube-addon/<br>
https://github.com/kubernetes/kube-state-metrics<br>

**extra**<br>
https://stackoverflow.com/questions/34501165/turning-a-bash-script-into-a-busybox-script<br>
https://github.com/k8tz/k8tz<br>
https://kubeops.net/blog/time-synchronization-in-kubernetes<br>
https://www.mirantis.com/cloud-native-concepts/getting-started-with-kubernetes/what-are-kubernetes-secrets/<br>
https://nikhils-devops.medium.com/helm-chart-for-kubernetes-cronjob-a694b47479a<br>

<details>
<summary><h2>DAY-1 (Pods)</h2></summary>
Container = isolamento de processos<br>
<br>

**kernel namespace:**<br>
isolamento<br>
usuario<br>
ponto de montagem<br>
processos<br>

**kernel cgroup:**<br>
isolamento de recursos<br>

**container engine: (docker, podman, cri-o)**<br>
execução do container<br>
health<br>
ponto de montagem<br>
não conversa diretamente com o kernel<br>

**container runtime:**<br>
comunica diretamente com o kernel<br>
executa o container<br>
garante o isolamento (cgroup & namespace)<br>

- containerd > high level
- gVisor > sandbox
- runc > low level

**OCI - Consórcio de várias empresas para padronização em criação de k8s e etc**<br>
https://opencontainers.org/<br>
- Desenvolveram o runc<br>

**Control Plane**<br>
*ETCD* > Guarda informações<br>
*kube API Server* > Gerencia toda o cluster, comunica com outros controllers e somente ele grava dados no ETCD<br>
*kube Controller Manager* > Gerencia e checa todos os outros controllers<br>
*kube Scheduler* > Controller que gerencia onde serão feitos os deploys, qual melhor node para receber os deploys/pods<br>
<kbd>
    <img src="https://github.com/fabiokerber/Kubernetes/blob/main/img/290520231142.png">
</kbd>

**Workers**<br>
*kubelet* > Agent que roda em cada nó e passa as fitas para o API Server<br>
*kube Proxy* > Responsável por gerir a comunicação de tudo no nó para o ambiente externo<br>
<kbd>
    <img src="https://github.com/fabiokerber/Kubernetes/blob/main/img/290520231143.png">
</kbd>

**Ports**<br>
<kbd>
    <img src="https://github.com/fabiokerber/Kubernetes/blob/main/img/290520231144.png">
</kbd>

*Pod* > Menor unidade de um cluster k8s. Um pod pode conter um ou mais containers dentro dele e o pod funciona como um “isolamento” para os containers<br>
*Deployment* > Controller que armazena os dados do deploy a quantidade de réplicas em cada nó, limits, etc<br>
Ao criar/alterar um deployment, é criado um Replica Set<br>
*Replica Set* > Controller que gerencia a aplicação conforme o que foi descrito no Deployment. Se comunica com os nós e garante que está tudo de acordo com o Deployment<br>
*Service* > Controller que expõe portas dos serviços que estão a rodar nos pods para o ambiente externo (Cluster IP, LoadBalancer, NodePort)<br>

**General**<br>
```
# vagrant up k8s_srv
# apt install -y jq
```

**Kubectl**<br>
```
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# chmod +x kubectl && mv kubectl /usr/local/bin/
# echo "alias k=kubectl" >> ~/.bashrc
# . ~/.bashrc
```

**Kubectl AutoComplete**<br>
```
# apt install -y bash-completion
# echo "source /etc/profile.d/bash_completion.sh" >> $HOME/.bashrc
# kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
# source /etc/profile.d/bash_completion.sh
```

**Kind (local cluster single node)**<br>
```
# curl -fsSL https://get.docker.com | bash
# [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.19.0/kind-linux-amd64
# chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind
# kind create cluster
# kind delete cluster
```

**Kind (local cluster multi node)**<br>
```
# vi cluster.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker

# kind create cluster --config cluster.yaml --name giropops
# kind delete cluster --name giropops
```

**Pod**<br>
```
# kubectl run --image nginx --port 80 giropops
# kubectl expose pods giropops -- type NodePort
# kubectl get svc
# kubectl exec -it giropops -- bash
# kubectl exec -it giropops -- cat /proc/1/cmdline
# kubectl exec -it giropops -- ls /proc
# kubectl run --image nginx --port 80 giropops --dry-run=client (apenas validação)
# kubectl run --image nginx --port 80 giropops --dry-run=client -o yaml > pod.yaml (validação + output para yaml)
```

**Challenge**<br>
```
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# chmod +x kubectl && mv kubectl /usr/local/bin/
# [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.19.0/kind-linux-amd64
# chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind

# kind create cluster --config meu-primeiro-cluster.yaml
# kubectl apply -f meu-primeiro-pod.yaml
```
</details>

<details>
<summary><h2>DAY-2 (Volume, Resources)</h2></summary>

**Pod**<br>
```
# kubectl describe pods giropops
# kubectl run strigus --image nginx --port 80
# kubectl -it run girus --image alpine
# kubectl attach girus -c girus -i -t (somente onde há processo TTY para conectar)
# kubectl exec -ti strigus -- bash
```

**Basic YAML Explanation**<br>
```
apiVersion: v1 #v1 = stable. Sempre checar antes do deploy
kind: Pod
metadata:
  labels:
    run: webserver
    service: webserver #qualquer coisa. Muito útil para aplicar filtros e fazer uma melhor gestão do ambiente
  name: webserver
spec: #setup
  containers:
  - image: nginx
    name: nginx
    resources: {}
  - image: httpd
    name: apache
    resources: {}
  - image: busybox
    name: busybox
    args: #comandos no container após fazer o deploy
    - sleep
    - "600"
    resources: {}
  dnsPolicy: ClusterFirst #DNS primeiro resolve internamente no cluster
  restartPolicy: Always
```

**Multi Container**<br>
```
# kubectl run webserver --image nginx --dry-run=client -o yaml > pod.yaml
# kubectl apply -f pod.yaml
# kubectl delete -f pod.yaml && kubectl create -f pod.yaml (necessário quando adicionando/removendo containers dentro do pod)
# kubectl get pods -w (watch)
```

**Troubleshooting**<br>
```
# kubectl describe pods webserver (all info)
# kubectl logs webserver -c apache (somente logs)
# kubectl logs webserver --all-containers=true
```

**Limits YAML Explanation**<br>
```
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: giropops
  name: giropops
spec:
  containers:
  - image: ubuntu
    name: ubuntu
    args: #remember! necessário para manter o container em execução, porque a imagem não possui nenhum processo em execução quando feito o deploy por default!
    - sleep
    - "1800"
    resources:
      requests: #garantido
        cpu: "0.3" #30% de utilização por core
        memory: "64Mi"
      limits:
        cpu: "0.5" #nunca ira execer 50% de utilização por core
        memory: "128Mi"
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

```
# kubectl describe giropops
# kubectl exec -it giropops -- bash
```

*Volume* > Forma de adicionar um ponto de montagem ao pod que ficará disponível para os containers dentro deste pod<br>
*EmptyDir* > Diretório vazio que persiste caso o pod seja reinicializado, mas perde-se caso o mesmo seja deletado ou se o pod for movido para outro nó<br>

**EmptyDir YAML Explanation**<br>
```
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: giropops
  name: giropops
spec:
  containers:
  - image: nginx
    name: webserver
    resources:
      requests:
        cpu: "0.5"
        memory: "64Mi"
      limits:
        cpu: "1"
        memory: "128Mi"
    volumeMount:
    - mountPath: /giropops #localização da pasta no host
      name: primeiro-emptydir #declarar o ponto de montagem do volume
  volumes:
  - name: primeiro-emptydir
    emptyDir: #tipo de volume
      sizeLimit: "256Mi" #limite do volume
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

</details>

<details>
<summary><h2>DAY-3 (Deployment, Strategy)</h2></summary>

**Deployment YAML Explanation**<br>

*Deployment* > Garantir a quantidade de réplicas, saúde e que os pods estejam espalhadados entre os nós (alta disponibilidade)<br>
Permite também estratégia de atualização (update de versão da aplicação por exemplo)<br>

```
## DEPLOYMENT SETUP
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-deployment
  name: nginx-deployment
  namespace: giropops
spec:
  replicas: 3
  selector:
    matchLabels: #quais pods serão geridos por este deployment
      app: nginx-deployment
## POD'S SETUP
  template:
    metadata:
      labels:
        app: nginx-deployment #como definido acima - "matchLabels"
    spec:
      containers:
      - image: nginx
        name: nginx
        resources:
          requests:
            cpu: "0.3"
            memory: "64Mi"
          limits:
            cpu: "0.5"
            memory: "256Mi"
```

*Strategy*: <br>
1 - Rolling Update - default > 25% indisponibilidade & 25% pods adicionais (não há downtime na aplicação)<br>
2 - Recreate - aplica as alterações em todo o deploy de uma vez só (talvez interessante quando há um grande update)<br>

**Strategy: RollingUpdate YAML Explanation**
```
## DEPLOYMENT SETUP
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-deployment
  name: nginx-deployment
  namespace: giropops
spec:
  replicas: 10
  selector:
    matchLabels:
      app: nginx-deployment
  strategy:
    type: RollingUpdate #atualização segura dos pods: 1 em 1, 2 em 2, ...
    rollingUpdate:
      maxSurge: 1/"10%" #adiciona um pod a mais durante o update conforme definido em "replicas"
      maxUnavailable: 2/"20%" #atualiza de 2 em 2
## POD'S SETUP
  template:
    metadata:
      labels:
        app: nginx-deployment
    spec:
      containers:
      - image: nginx:1.15.0
        name: nginx
        resources:
          requests:
            cpu: "0.3"
            memory: "64Mi"
          limits:
            cpu: "0.5"
            memory: "256Mi"
```

**Strategy: Recreate YAML Explanation**
```
## DEPLOYMENT SETUP
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-deployment
  name: nginx-deployment
  namespace: giropops
spec:
  replicas: 10
  selector:
    matchLabels:
      app: nginx-deployment
  strategy:
    type: Recreate
## POD'S SETUP
  template:
    metadata:
      labels:
        app: nginx-deployment
    spec:
      containers:
      - image: nginx:1.15.0
        name: nginx
        resources:
          requests:
            cpu: "0.3"
            memory: "64Mi"
          limits:
            cpu: "0.5"
            memory: "256Mi"
```

**Rollback & Rollout & Scale**
```
# kubectl apply -f deployment-rollback-rollout.yaml
# kubectl apply -f deployment-rolling-update.yaml
# kubectl rollout undo deployment -n giropops nginx-deployment (rollout para o replicaset anterior/imagem anterior)
# kubectl rollout history deployment nginx-deployment
# kubectl rollout undo deployment -n giropops nginx-deployment --to-revision 2

# kubectl rollout pause deployment -n giropops nginx-deployment (ambiente crítico de produção, pode-se manter em pause, faz o deploy e depois resume quando for o melhor momento)
# kubectl rollout resume deployment -n giropops nginx-deployment
# kubectl rollout restart deployment -n giropops nginx-deployment (cuidado! recria todos os pods)

# kubectl rollout status deployment -n giropops nginx-deployment
# kubectl rollout history deployment nginx-deployment -n giropops
# kubectl rollout history deployment nginx-deployment -n giropops --revision 2

# kubectl scale deployment -n giropops --replicas 3 nginx-deployment
```

**Commands**
```
# kubectl get deployments
# kubectl get deployments -o yaml
# kubectl describe deployment nginx-deployment
# kubectl get pods -l app=nginx-deployment
# kubectl get replicaset
# kubectl create deployment --image=nginx --replicas=3 nginx-deployment --dry-client=client -o yaml > new-deployment.yaml
# kubectl create namespace giropops
```

</details>

<details>
<summary><h2>DAY-4 (ReplicaSet, DaemonSet, Probes)</h2></summary>

*ReplicaSet*: A principal função do ReplicaSet é garantir que as réplicas dos seus pods estão no número desejado (conforme configurado no Deployment)<br>
Ao alterar o Deployment, por exemplo, atualizar imagem de um container, é criado um novo ReplicaSet, migrado os pods para o novo e então desativado o ReplicaSet anterior<br>

```
# kubectl get replicasets
# kubectl describe replicaset
```

*DaemonSet*: Garante que ao menos uma réplica de um pod estará em execução em cada um dos nós<br>
Exemplo: kube-proxy, prometheus node exporter, monitoramento, segurança, ...<br>
Ao adicionar um novo nó, os DaemonSets existentes farão o deploy dos pods necessários no novo nó<br>

**DaemonSet YAML Explanation**
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: node-exporter-daemonset
  name: node-exporter-daemonset
spec:
  selector:
    matchLabels:
      app: node-exporter-daemonset
  template:
    metadata:
      labels:
        app: node-exporter-daemonset
    spec:
      hostNetwork: true #habilita o uso da rede do host, necessário para forçar o uso da rede do nó e não a rede dos containers como é padrão
      containers:
      - name: node-exporter
        image: prom/node-exporter:latest
        ports:
        - containerPort: 9100
          hostPort: 9100
        volumeMounts:
        - name: proc #local que deve ser exposto para permitir o monitoramento
          mountPath: /host/proc #onde será montado no container
          readOnly: true #garante que não será alterado nada nesta unidade do host
        - name: sys
          mountPath: /host/sys
          readOnly: true
      volumes: #definição dos volumes
      - name: proc
        hostPath: #monta um volume do host local dentro do container
          path: /proc
      - name: sys
        hostPath: #monta um volume do host local dentro do container
          path: /sys
```

*Probes*: Garante que os serviços dos containers estejam saudáveis por meio de três possíveis verificações:<br>
1 - *livenessProbe*: Monitora se o serviço está íntegro<br>
2 - *readinessProbe*: Garante que o deploy foi feito com sucesso para garantir requisições externas<br>
O Pod que apresentou problemas é "movido" para fora do Deployment até que esteja OK para retornar ao Deployment
3 - *startupProbe*: Realiza um único teste após o start do container para garantir que inicializado corretamente<br>
E com o resultado destas checagens podem haver ações a serem tomadas dependendo do que foi configurado<br>
Cada container deve ter seu próprio Probe<br>
Para o *liveness* e *readiness* é importante avaliar os parâmetros disponíveis para checagem, exemplo httpGet, tcpSocket, ...<br>

**LivenessProbe (tcpSocket) YAML Explanation**
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-deployment
  name: nginx-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-deployment
  strategy: {}
  template:
    metadata:
      labels:
        app: nginx-deployment
    spec:
      containers:
      - image: nginx:1.19.1
        name: nginx
        resources:
          requests:
            cpu: "0.3"
            memory: "64Mi"
          limits:
            cpu: "0.5"
            memory: "256Mi"
## PROBE SETUP
        livenessProbe:
          tcpSocket: #checagem de porta
            port: 80
          initialDelaySeconds: 10 #aguarda um tempo até que faça o teste de checagem
          periodSeconds: 10 #a cada 10 segundos executa a checagem
          timeoutSeconds: 5 #considera um problema após 5 segundos de timeout na checagem
          failureThreshold: 3 #após 3 falhas de checagem o container é reinicializado
```
```
livenessProbe:
  tcpSocket:
    port: 81
```

*Warning  Unhealthy  75s (x9 over 2m35s)  kubelet            Liveness probe failed: dial tcp 10.244.2.2:81: connect: connection refused*<br>

**LivenessProbe (httpGet) YAML Explanation**
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-deployment
  name: nginx-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-deployment
  strategy: {}
  template:
    metadata:
      labels:
        app: nginx-deployment
    spec:
      containers:
      - image: nginx:1.19.1
        name: nginx
        resources:
          requests:
            cpu: "0.3"
            memory: "64Mi"
          limits:
            cpu: "0.5"
            memory: "256Mi"
## PROBE SETUP
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
```
```
livenessProbe:
  httpGet:
    path: /giropops
    port: 80
```

*Warning  Unhealthy  8s (x7 over 68s)   kubelet            Liveness probe failed: HTTP probe failed with statuscode: 404*<br>

**ReadinessProbe (exec) YAML Explanation**
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-deployment
  name: nginx-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-deployment
  strategy: {}
  template:
    metadata:
      labels:
        app: nginx-deployment
    spec:
      containers:
      - image: nginx:1.19.1
        name: nginx
        resources:
          requests:
            cpu: "0.3"
            memory: "64Mi"
          limits:
            cpu: "0.5"
            memory: "256Mi"
## PROBE SETUP
        readinessProbe:
          exec:
            command:
            - curl
            - -f
            - http://localhost:80
          initialDelaySeconds: 10
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
          successThreshold: 1 #quantas vezes é considerado sucesso na checagem
```
```
readinessProbe:
  exec:
    command:
    - curl
    - -f
    - http://localhot:80
```

*Warning  Unhealthy  2s (x10 over 82s)  kubelet            Readiness probe failed: curl: (6) Could not resolve host: localhot*<br>

**StartupProbe (tcpSocket) YAML Explanation**
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-deployment
  name: nginx-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-deployment
  strategy: {}
  template:
    metadata:
      labels:
        app: nginx-deployment
    spec:
      containers:
      - image: nginx:1.19.1
        name: nginx
        resources:
          requests:
            cpu: "0.3"
            memory: "64Mi"
          limits:
            cpu: "0.5"
            memory: "256Mi"
## PROBE SETUP
        startupProbe:
          tcpSocket:
            port: 80
          timeoutSeconds: 5
          failureThreshold: 3
          successThreshold: 1
```
```
startupProbe:
  tcpSocket:
    port: 81
```

*Warning  Unhealthy  6s (x3 over 26s)  kubelet            Startup probe failed: dial tcp 10.244.3.3:81: connect: connection refused*<br>
*Normal   Killing    6s                kubelet            Container nginx failed startup probe, will be restarted*<br>

</details>

<details>
<summary><h2>DAY-5 (Cluster Deploy kubeadm)</h2></summary>

Chaves de Acesso Cluster Kubernetes = /etc/kubernetes/admin.conf<br>
Certificados Cluster Kubernetes = /etc/kubernetes/pki/<br>
CNI = Container Network Interface (conjunto de bibliotecas, configurações e especificações que possibilita a criaçãoi de plugins de rede que resolve o problema de comunicação entre os containers)<br>
WeaveNet / Calico = Plugin de rede

```
$ vagrant up ubuntu_nfs
$ vagrant up ubuntu_kubeadm
$ vagrant up ubuntu_worker01
$ vagrant up ubuntu_worker02
```
```
kubectl get nodes -o wide
kubectl get nodes ubuntu-worker01 -o wide
kubectl get nodes ubuntu-worker01 -o yaml
kubectl describe node ubuntu-worker01
```

</details>

<details>
<summary><h2>DAY-6 (Volumes, PV, PVC)</h2></summary>

Volumes são necessários para persistir os dados. Há dois tipos: *ephemeral (emptyDir)* e *persistent*.<br>

StorageClass = Forma de automatizar a criação/remover o gerenciamento dos PV's por meio de engines chamados Provisioners. É possível criar pools de discos (exemplo: lentos e rápidos ou com políticas de retenção), para facilitar a gestão dos PV's<br>
PV = Volume "reservado" no disco. hostPath mais utilizado para teste, pois é criado um diretório somente no próprio nó em que o container/pod está a correr. NFS repositório em rede para armazenar o que é comum entre os containers/pods. Há outras milhares de opções<br>
PVC = Quando é feita uma requisição, o StorageClass cria o PV e "entrega" o que foi solicitado com base nas policies setadas no StorageClass<br>

```
$ kubectl get storageclass
$ kubectl describe storageclass (IsDefaultClass:  No)
$ kubectl patch storageclass meu-storage -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
$ kubectl apply -f pv-hostpath.yaml
$ kubectl apply -f pv-nfs.yaml
$ kubectl get pv
$ kubectl describe pv meu-pv-lento
$ kubectl describe pv meu-pv-nfs
```

**PersistentVolume (hostPath) YAML Explanation**
```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: meu-storage
provisioner: kubernetes.io/no-provisioner
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer #o claim (pvc) que for atribuído à este storageclass será criado somente quando houver "consumo" por algum container/pod
```

**PersistentVolume (hostPath) YAML Explanation**
```
apiVersion: v1
kind: PersistentVolume
metadata:
  labels:
    pool: lento
  name: meu-pv-lento
spec:
  capacity:
    storage: 1Gi
  accessModes: #é acessado por vários pods ao mesmo tempo ou um por vez? Por exemplo um há um lock quando acessado...
    - ReadWriteOnce #leitura/escrita somente por um único nó por vez. Exemplo database
    - ReadWriteMany #leitura/escrita por vários nós ao mesmo tempo. Exemplo logs distintos
  persistentVolumeReclaimPolicy: Retain #se excluir o PV, os dados não são apagados
  persistentVolumeReclaimPolicy: Recycle #se excluir o PV, os dados são apagados
  hostPath: #cria o diretorio local
    path: /mnt/data #caminho do hostPath, do nosso nó, onde o PV será criado
  storageClassName: storage #nome do storageclass criado
```

</details>

<details>
<summary><h2>DAY-7 (StatefulSets, Services: ClusterIP, NodePort, NodeBalancer, Headless)</h2></summary>
<br>

Stateful = Garante uma estrutura persistente de nome, endereçamento dns, persistent volume, rolling update durante a execução dos pods. Quando um Pod é recriado, ele se reconecta ao mesmo Volume Persistente, garantindo a persistência dos dados entre as recriações dos Pods. Por padrão, o Kubernetes cria um PersistentVolume para cada Pod em um StatefulSet, que é então vinculado a esse Pod para a vida útil do StatefulSet<br>
- Identidade de rede estável e única
- Armazenamento persistente estável
- Ordem de deployment e scaling garantida
- Ordem de rolling updates e rollbacks garantida
- Algumas aplicações que se encaixam nesses requisitos são bancos de dados, sistemas de filas e quaisquer aplicativos que necessitam de persistência de dados ou identidade de rede estável
Stateless = Aplicação que não precisa garantir nada durante a execução dos pods (Deployment, ReplicaSet)<br>
Headless = O Headless Service serve para que possamos acessar os Pods individualmente<br>
Services = Maneira de expor os pods para o meio externo<br>
<br>
<br>
ClusterIP (padrão) = Expõe o Service em um IP interno no cluster. Este tipo torna o Service acessível apenas dentro do cluster<br>
NodePort = Expõe o Service na mesma porta de cada Node selecionado no cluster usando NAT. Torna o Service acessível de fora do cluster usando NAT<br>
LoadBalancer = Cria um balanceador de carga externo no ambiente de nuvem atual (se suportado) e atribui um IP fixo, externo ao cluster, ao Service<br>
ExternalName = Mapeia o Service para o conteúdo do campo externalName (por exemplo, foo.bar.example.com), retornando um registro CNAME com seu valor
Expoẽ informações de fora para dentro do cluster<br>

**ClusterIP | NodePort | Endpoints**
```
# kubectl create deployment nginx --image nginx --port 80
# kubectl expose deployment nginx
# kubectl get svc
# kubectl run -it --rm debug --image busybox --restart Never -- sh
  / # wget -O- <nginx clusterip>

# kubectl expose deployment nginx --type NodePort
# kubectl get svc
# kubectl get pods -o wide
$ wget -O- 192.168.56.153:31984

# kubectl get endpoints
# kubectl scale deployment nginx --replicas 3
# kubectl get endpoints
# kubectl get pods -o wide
```

**LoadBalancer | ExternalName**
```
# kubectl create deployment nginx --image nginx --port 80
# kubectl scale deployment nginx --replicas 3
# kubectl expose deployment nginx --type LoadBalancer

# kubectl create service externalname giropops-db --external-name db.giropops.com.br (quando houver requisição para "giropops-db", há um redirect para "db.giropops.com.br")
# kubectl get svc

# kubectl create deployment nginx --image nginx --port 80
# kubectl create service externalname giropops-db --external-name db.giropops.com.br
# kubectl expose deployment nginx (ClusterIP)
# kubectl expose service nginx --name nginx-nodeport --type NodePort (Gambi para Troubleshooting)
# kubectl delete -f .
```

</details>

<details>
<summary><h2>DAY-8 (Secrets, ConfigMaps)</h2></summary>
<br>

ConfigMap = Armazena configurações para serem utilizados dentro dos pods<br>
Secrets = Armazena dados sensíveis, tais como tokens e certificados. Armazenado dentro do ETCD e por padrão essas informações não são criptografados.<br>
O acesso aos Secrets pode ser gerido via RBAC (Role Based Access Control). Por default não é seguro!<br>
Codificação base64 = para o cluster é mais rápido ler os dados e utilizá-los em base64 do que o dado puro, por isso é utilizado desta forma por default. Não está criptografado!<br>
<br>

**Secrets**
```
# kubectl get secrets -A
# kubectl -n kube-system get secrets chart-values-rke2-canal -o yaml
# echo -n "<hash>" | base64 -d

# echo -n "nuderval" | base64 (username)
# echo -n "giropos" | base64 (password)

# kubectl get secret giropops-secret -o yaml

# kubectl create secret generic giropops-test --from-literal=username="bnVkZXJ2YWw=" --from-literal=password="Z2lyb3Bvcw=="
# kubectl apply -f pod-secret.yaml
# kubectl describe pods giropops-pod
# kubectl exec -ti giropops-pod -- env
```

**ConfigMap (+ Secret TLS)**
```
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout chave-privada.key -out certificado.crt
# kubectl create secret tls meu-servico-web-tls-secret --cert=certificado.crt --key=chave-privada.key
# kubectl get secrets meu-servico-web-tls-secret -o yaml
# kubectl create configmap nginx-config --from-file nginx.conf
/
# kubectl apply -f pod-configmap.yaml
# kubectl apply -f pod-configmap-secret.yaml
# kubectl expose pods giropops-pod --type ClusterIP
# kubectl port-forward services/giropops-pod 4443:443
```

</details>

<details>
<summary><h2>DAY-9 (Ingress)</h2></summary>
<br>

Ingress = Expõe o serviço externamente. Além de expor o service, possui diversas features & controles, TLS & SSL, Regra de Roteamento (dependendo do endereço, roteia para outro serviço/aplicação, possui balanceamento de carga (conforme as regras feitas).<br>
Ingress Controller = Ingress Nginx Controller (mais utilizado hoje em dia), HAProxy, Traefik.<br>
<br>

Workround KIND para habilitar o ingress (kind-com-ingress.yaml)<br>

**Deploy do Ingress para o KIND**
```
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
# kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s
# kubectl -n ingress-nginx get pods
```

**Deploy App com as regras de Ingress - Parte 1**
```
# kubectl apply -f giropops-senhas-redis-deploy.yaml
# kubectl apply -f giropops-senhas-redis-svc.yaml
# kubectl apply -f giropops-senhas-deploy.yaml
# kubectl apply -f giropops-senhas-svc.yaml
# kubectl get endpoints
# kubectl port-forward services/giropops-senhas 5000:5000 (teste)
# curl localhost:5000 (outro terminal)
# kubectl apply -f giropops-senhas-ingress-1.yaml
# kubectl get ing
# kubectl describe ing giropops-senhas
# kubectl get svc -n ingress-nginx
# curl localhost/giropops-senhas
# kubectl logs pods/ingress-nginx-controller-75db587499-242gj -n ingress-nginx
# http://192.168.56.102/giropops-senhas
```

**Deploy App com as regras de Ingress - Parte 2**
```
# kubectl apply -f giropops-senhas-redis-deploy.yaml
# kubectl apply -f giropops-senhas-redis-svc.yaml
# kubectl apply -f giropops-senhas-deploy.yaml
# kubectl apply -f giropops-senhas-svc.yaml
# kubectl get endpoints
# kubectl apply -f giropops-senhas-ingress-2.yaml
# http://192.168.56.102/
```

**Múltiplos Ingresses no mesmo Ingress Controller (do zero)**
```
# kubectl apply -f giropops-senhas-redis-deploy.yaml
# kubectl apply -f giropops-senhas-redis-svc.yaml
# kubectl apply -f giropops-senhas-deploy.yaml
# kubectl apply -f giropops-senhas-svc.yaml
# kubectl get pods
# kubectl get svc
# kubectl get endpoints

# kubectl run nginx --image nginx --port 80
# kubectl expose pod nginx (para criar o serviço do nginx)
# kubectl apply -f nginx-multi-ingresses-1.yaml
# kubectl apply -f nginx-multi-ingresses-2.yaml
# kubectl get svc
# kubectl get endpoints
# kubectl get ing
# kubectl get svc --namespace=ingress-nginx

# cat << EOF >> /etc/hosts
127.0.0.1 page-one.io
127.0.0.1 page-two.io
EOF

ou

# cat << EOF >> /etc/hosts
192.168.56.102 page-one.io
192.168.56.102 page-two.io
EOF
```

</details>

<details>
<summary><h2>DAY-11 (kube-prometheus)</h2></summary>
<br>

```
# git clone https://github.com/prometheus-operator/kube-prometheus.git
# kubectl create -f kube-prometheus/manifests/setup (cria somente os CRDs e namespace monitoring)
# kubectl apply -f kube-prometheus/manifests (instala tudo)
# kubectl port-forward -n monitoring svc/grafana 33000:3000
# kubectl port-forward -n monitoring svc/prometheus-k8s 39090:9090
# kubectl port-forward -n monitoring svc/alertmanager-main 39093:9093
```

</details>

<details>
<summary><h2>EXTRA</h2></summary>

**LAB**
```
$ vagrant plugin install {vagrant-vboxmanage,vagrant-vbguest,vagrant-disksize,vagrant-env,vagrant-reload}
```

**Cronjob**
```
# kubectl create ns cronjob-operacoes
# kubectl -n cronjob-operacoes apply -f .
# watch kubectl -n cronjob-operacoes get cronjob
# watch kubectl -n cronjob-operacoes get jobs
# kubectl -n cronjob-operacoes get pods
# kubectl -n cronjob-operacoes logs pods/elk-indexes-cronjob-28142745-pjssp
# kubectl -n cronjob-operacoes describe pods/elk-indexes-cronjob-28142745-pjssp
# kubectl -n cronjob-operacoes patch cronjobs elk-indexes-cronjob -p '{"spec" : {"suspend" : true }}'

# echo -n '<user>' > ./username.txt
# echo -n '<pass>' > ./password.txt
# kubectl create secret generic elk-indexes-secret --from-file=./username.txt --from-file=./password.txt
# kubectl --context ops -n elk-cronjob create secret generic elastic-auth --from-literal=username=<user> --from-literal=password='<pass>'
# kubectl edit secrets elk-indexes-secret
# kubectl edit secrets elastic-auth
```

**K9s - Kubernetes CLI To Manage Your Clusters In Style!**<br>
https://github.com/derailed/k9s<br>
https://www.civo.com/learn/how-to-get-to-grips-with-your-kubernetes-clusters-on-the-command-line<br>
```
# curl -sS https://webinstall.dev/k9s | sudo bash
# echo "source '$HOME/.config/envman/PATH.env'" >> ~/.bashrc
# . ~/.bashrc
```
```
k9s
# List all available CLI options
k9s help
# To get info about K9s runtime (logs, configs, etc..)
k9s info
# To run K9s in a given namespace
k9s -n mycoolns
# Start K9s in an existing KubeConfig context
k9s --context cool
# Start K9s in readonly mode - with all cluster modification commands disabled
k9s --readonly
```

**!IMPORTANTE!**<br>

- Deployment
- Requests/Limits
- Probes (livenessProbe, readinessProbe)
- Strategy (rollingUpdate)
- DaemonSet (uso monitoramento, segurança)

</details>
