# Rancher

<kbd>
    <img src="https://github.com/fabiokerber/Rancher/blob/main/1.Udemy/img/190520220826.png">
</kbd>
<br />
<br />

# Links #  
https://staging--longhornio.netlify.app/docs/0.8.1/references/examples/<br>
https://www.elastic.co/guide/en/elasticsearch/reference/current/aliases.html<br>

# VM's #

**VirtualBox**
*File > Preferences > Network*<br>
OtherNAT
172.16.0.0/24
Uncheck *Supports DHCP*

*File > Host Network Manager*<br>
192.168.56.1<br>
255.255.255.0<br>
Uncheck *DHCP Server*

**rmaster01.aut.lab**<br>
vCPU: 4<br>
Ram: 4GB<br>
Disk: 2x 40G<br>
SO: Ubuntu Server 18.04.6 LTS<br>
Network: <br>
Adapter 1 - Host-only Adapter - vboxnet0 - Allow All - 192.168.56.10 *manual*<br>
Adapter 2 - OtherNAT - Allow All - 172.16.0.10/24 *manual*<br>
<br />

**rnode01.aut.lab**<br>
vCPU: 4<br>
Ram: 2GB<br>
Disk: 2x 40G<br>
SO: Ubuntu Server 18.04.6 LTS<br>
Network: <br>
Adapter 1 - Host-only Adapter - vboxnet0 - Allow All - 192.168.56.11 *manual*<br>
Adapter 2 - OtherNAT - Allow All - 172.16.0.11/24 *manual*<br>
<br />

**rnode02.aut.lab**<br>
vCPU: 4<br>
Ram: 2GB<br>
Disk: 2x 40G<br>
SO: Ubuntu Server 18.04.6 LTS<br>
Network: <br>
Adapter 1 - Host-only Adapter - vboxnet0 - Allow All - 192.168.56.12 *manual*<br>
Adapter 2 - OtherNAT- Allow All - 172.16.0.12/24 *manual*<br>
<br />

**rnode03.aut.lab**<br>
vCPU: 4<br>
Ram: 2GB<br>
Disk: 2x 40G<br>
SO: Ubuntu Server 18.04.6 LTS<br>
Network: <br>
Adapter 1 - Host-only Adapter - vboxnet0 - Allow All - 192.168.56.13 *manual*<br>
Adapter 2 - OtherNAT - Allow All - 172.16.0.13/24 *manual*<br>
<br />

```
- Adapter 1 -
Subnet 192.168.56.0/24
Address 192.168.56.{10,11,12,13}

- Adapter 2 -
Subnet 172.16.0.0/24
Address 172.16.0.{10,11,12,13}
Gateway: 172.16.0.1
Name servers: 172.16.0.1

/var > 40G
```
```
$ sudo apt upgrade -y
$ sudo ufw disable
$ sudo vim /etc/hosts
    192.168.56.10 rmaster01.aut.lab rmaster01
    192.168.56.11 rnode01.aut.lab rnode01
    192.168.56.12 rnode02.aut.lab rnode02
    192.168.56.13 rnode03.aut.lab rnode03

$ sudo apt install -y apt-transport-https gnupg2
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
$ echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
$ sudo apt update
$ sudo apt install -y docker.io kubectl && sudo systemctl start docker && sudo systemctl enable docker

$ sudo docker run -d --name rancher --restart=unless-stopped -v /opt/rancher:/var/lib/rancher -p 80:80 -p 443:443 --privileged rancher/rancher:v2.5.11 (sapo)
$ sudo docker run -d --name rancher --restart=unless-stopped -v /opt/rancher:/var/lib/rancher -p 80:80 -p 443:443 --privileged rancher/rancher:latest
$ sudo docker pull rancher/rancher-agent:v2.5.11
```

### Anotar senha após finalizar deploy rancher (Somente v2.6.3+)
```
$ vagrant ssh master01 -c "sudo docker ps -a" (anotar CONTAINER ID!)
$ sudo docker logs rancher 2>&1 | grep "Bootstrap Password:"
```

### Acessar o Rancher v2 (e ativar com a senha coletada => Somente v2.6.3+)
```
https://<MASTER_IP>
```

### Criar cluster - Parte 1
```
Cluster Name: ops
Kubernetes Options: v1.19.16-rancher2-1
Network Provider: canal
CNI Plugin MTU Override: 1450

Nginx Ingress: Enabled
Nginx Default Backend: Enabled
Pod Security Policy Support: Disabled
Docker version on nodes: Require a supported Docker version

etcd Snapshot Backup Target: local
Recurring etcd Snapshot Enabled: Yes
Scheduled CIS Scan Enabled: No
Drain nodes: Yes
```

### Criar cluster - Parte 2
Nesta etapa deve-se selecionar os três checkbox para que os três **workers** possam ter o etcd e control plane.<br>
Após selecionado, click em **Show advanced options**.<br>
Preencha o campo **Node Name** com o nome do primeiro node e copie o código abaixo e execute-o no respectivo node.<br>
Faça isso para os três nodes alterando o campo **Node Name**, copiando o código e executando em cada node.<br>
```
1. Node Name: rancher-k8s1 | rancher-k8s2 | rancher-k8s3
    Obs: Adicionar primeiro e aguardar até que normalize a inclusão e API, então adicione o segundo e aguarde, etc...

2. Exemplo: 
    a. $ ... --node-name rnode01 ...
    b. $ ... --node-name rnode02 ...
    c. $ ... --node-name rnode03 ...

3. "Done"
```

### Catalogs (Add)
```
Name: elastic
URL: https://helm.elastic.co
Branch: master
Scope: global
Helm Version: Helm v2
```

```
Name: nginx-ingress
URL: https://kubernetes.github.io/ingress-nginx
Branch: master
Scope: global
Helm Version: Helm v3
```

### Longhorn (Persistent Volumes)
ops > Projects/Namespaces > Add Project > *Longhorn*<br>
Instalar o App *Longhorn* acessando o cluster ops > Default > Apps > Launch<br>
Template Version: 1.2.4<br>
Helm Wait: False<br>
Helm Timeout: 300<br>
**app_deploy_longhorn.yml**<br>

### Configurar kube/config para administrar o cluster (fabio@rmaster01)

<kbd>
    <img src="https://github.com/fabiokerber/Rancher/blob/main/1.Udemy/img/171020221356.png">
</kbd>
<br />
<br />

<kbd>
    <img src="https://github.com/fabiokerber/Rancher/blob/main/1.Udemy/img/171020221358.png">
</kbd>
<br />
<br />

```
$ mkdir ~/.kube && vi ~/.kube/config (paste kubeconfig)
$ kubectl --context ops --namespace longhorn-system get pods
$ kubectl --context ops --namespace kube-system get pods
```

### Deploy ELK - Parte 01<br>
ops > Projects/Namespaces > Add Project > *Logging*<br>
ops > Projects/Namespaces > Project Logging > Add Namespace > *elasticsearch*<br>

### Deploy ELK - Parte 02<br>
ops > Logging > Resources > Secrets > *Add Secret*
Name: elasticsearch-master-account<br>
Available to a single namespace: elasticsearch<br>
Key:<br>
username - elastic<br>
password - vK39PY57MW46nf8V<br>

### Deploy ELK - Parte 03-1<br>
ops > Logging > Resources > Workloads > Volumes > *Add Volume*<br>
*elk-master-elk-master-0*<br>
*elk-master-elk-master-1*<br>
*elk-master-elk-master-2*<br>
Namespace: elasticsearch<br>
Source: Use a Storage Class to provision a new persistent volume<br>
Storage Class: longhorn<br>
Request Storage: 15<br>
Access Modes: Single Node Read-Write<br>

### Deploy ELK (yml) - Parte 03-2 (fabio@rmaster01)<br>
```
$ kubectl --context ops --namespace elk create -f es-pv-elk-master-0.yaml
$ kubectl --context ops --namespace elk create -f es-pv-elk-master-1.yaml
$ kubectl --context ops --namespace elk create -f es-pv-elk-master-2.yaml
$ kubectl --context ops --namespace elk get pv

$ kubectl --context ops --namespace elk create -f es-pvc-elk-master-0.yaml
$ kubectl --context ops --namespace elk create -f es-pvc-elk-master-1.yaml
$ kubectl --context ops --namespace elk create -f es-pvc-elk-master-2.yaml
$ kubectl --context ops --namespace elk get pvc
```

### Deploy ELK - Parte 03<br>
ops > Logging > Apps > Launch > *elasticsearch*<br>
Name: elasticsearch<br>
Template Version: 7.17.3<br>
Use an existing amespace: elasticsearch<br>
**app_deploy_elasticsearch.yml**

### Ingress (fail)
ops > Logging > Resources > Workloads > Load Balancing > *Add Ingress*<br>
Name: elk-master<br>
Namespace: elasticsearch<br>
Rules:<br>
Specify a hostname to use: elk-master.io.pt<br>
Target Backend: *+ Service*
Path: /<br>
Target: elk-master<br>
Port: 9200<br>
```
fabio@rmaster01
$ kubectl --context ops --namespace elasticsearch get ing
```