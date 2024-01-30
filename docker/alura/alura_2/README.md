# 2.Alura

### Docker Swarm (ORQUESTRADOR DE CONTAINERS) & Docker Machine
<br />

**Anotações**<br>
    *Docker machine cria máquinas virtuais com o auxilio do VirtualBox já com o docker instalado.*
    *Nunca mais do que 9 ou 10 managers dentro de um cluster.*
    *Serviços críticos nos managers e não-críticos em workers.*
    *Redes:*<br>
      *Bridge - Nós conseguem se comunicar entre si.*
      *Host - Nó só se comunica com o host onde esta rodando.*
      *Ingress - Todos os nós pertencentes ao Swarm automaticamente pertencem à esta rede. Comunicação criptografada.*
<br />

**Docker Machine**<br>
*Git BASH*
```
$ docker-machine rm vm{0,1,2,3,4,5}
$ docker-machine create -d virtualbox vm1 (se erro reinstalar o VirtualBox)
```
<br />

**Criando cluster de VMs**<br>
*Git BASH*
```
$ docker-machine ssh vm1
  $ docker swarm init --advertise-addr 192.168.99.101 
  (inicia o swarm com o IP atribuido à esta maquina virtual)
  (esta maquina também se tornou o 'manager' deste swarm)
$ docker inspect vm1
  Role: manager
$ docker swarm join-token worker (exibe o comando para adicionar workers)
```
<br />

**Criando workers**<br>
*Git BASH*
```
$ docker-machine create -d virtualbox vm2
$ docker-machine create -d virtualbox vm3

!! Acessar vm2 e vm3 e adicioná-las com o token ao cluster swarm !!
```
<br />

**Listando e removendo nós (worker)**<br>
*Git BASH*
```
$ docker-machine ssh vm3
  $ docker swarm leave

$ docker-machine ssh vm1
  $ docker node ls (lista managers e workers do swarm)
  $ docker node rm <ID_NODE_vm3>
```
<br />

**Subindo serviço e Routing Mesh**<br>
*Git BASH*
```
$ docker-machine start vm{1,2,3}
$ docker-machine ssh vm2
  $ docker container run -p 8080:3000 -d aluracursos/barbearia
  $ docker container ls

$ docker-machine ssh vm1
  $ docker inspect vm2 (pegar informações sobre o vm2)
  $ docker service create -p 8080:3000 -d aluracursos/barbearia (ira criar um container mas como serviço no swarm)
  $ docker service ls (exibe o status e replicação do serviço)
  $ docker service ps <ID _service>
  http://ip_vm{1,2,3}:8080 (routing mesh redireciona indenpente de onde o container estiver funcionando)
```
<br />

**Subindo serviço e Routing Mesh**<br>
*Git BASH*
```
$ docker-machine start vm{1,2,3}
$ docker-machine ssh vm2
  $ docker container run -p 8080:3000 -d aluracursos/barbearia
  $ docker container ls

$ docker-machine ssh vm1
  $ docker inspect vm2 (pegar informações sobre o vm2)
  $ docker service create -p 8080:3000 -d aluracursos/barbearia (ira criar um container mas como serviço no swarm)
  $ docker service ls (exibe o status e replicação do serviço)
  $ docker service ps <ID _service>
  http://ip_vm{1,2,3}:8080 (routing mesh redireciona indenpente de onde o container estiver funcionando)
```
<br />

**Backup do Swarm em caso de DR**<br>
*Git BASH*
```
$ docker-machine ssh vm1
  $ sudo su
  $ ls /var/lib/docker/swarm
  $ cp -r /var/lib/docker/swarm backup (faz o backup da pasta swarm que contem todas as configurações e logs do swarm)
  (caso ocorra algum problema com o manager, basta copiar esse conteudo para a pasta swarm novamente)
  (apos a copia, basta subir o swarm novamente adicionando a flag --force-new-cluster)
```
<br />

**Criando mais Managers**<br>
*Git BASH*
```
$ docker swarm leave --force (força a saida do node/manager do cluster. executar nas três vms)
$ docker swarm init --advertise-addr 192.168.99.101 (recria o cluster swarm)
$ docker swarm join-token manager (exibe o comando para adicionar novos managers ao cluster. executar na vm2 e vm3)
$ docker-machine create -d virtualbox vm4
$ docker-machine create -d virtualbox vm5
$ docker node ls --format "{{.Hostname}} {{.ManagerStatus}}" (visualizar somente as colunas hostname e manager status)

$ docker-machine ssh vm1
  $ docker swarm join-token worker

$ docker-machine ssh vm4
$ docker-machine ssh vm5 (join)
```
<br />

**Algoritmo de consenso RAFT**<br>
*Git BASH*
```
$ docker swarm leave --force (força a saida do node/manager do cluster. executar nas três vms)
$ docker swarm init --advertise-addr 192.168.99.101 (recria o cluster swarm)
$ docker swarm join-token manager (exibe o comando para adicionar novos managers ao cluster. executar na vm2 e vm3)
$ docker-machine create -d virtualbox vm4
$ docker-machine create -d virtualbox vm5
$ docker node ls --format "{{.Hostname}} {{.ManagerStatus}}" (visualizar somente as colunas hostname e manager status)

$ docker-machine ssh vm1
  $ docker swarm join-token worker

$ docker-machine ssh vm4
$ docker-machine ssh vm5 (join)
```
<br />

**Removendo um Manager**<br>
*Git BASH*
```
$ docker-machine ssh vm2
  $ docker node demote vm1
```
<br />

**Restringindo nós (serviços rodando apenas no Manager)**<br>
*Git BASH*
```
1 -
$ docker-machine ssh vm1
  $ docker node ls (availability active = disponivel para suportar serviços)
  $ docker node update --availability drain vm2 (altera o status para drain, somente da vm2 = não disponível para suportar serviços)

2 - 
$ docker-machine ssh vm1
  $ docker service update --constraint-add node.role==worker <ID_serviço> (impõe restrição para que o serviço só rode em workers)
  $ docker service update --constraint-rm node.role==worker <ID_serviço> (remove restrição)
```
<br />

**Replicação de serviço**<br>
*Git BASH*
```
$ docker-machine ssh vm1
  $ docker service update --replicas 4 <ID_serviço> (aloca quatro copias para os 5 containers)
  (necessario restringir apenas para workers se necessario)
  $ docker service scale <ID_serviço>=4 (outra forma de executar o mesmo comando acima...)
```
<br />

**Replicação de serviço (modo Global)**<br>
*Git BASH*
```
$ docker-machine ssh vm1
  $ docker service create -p 8080:3000 --mode global aluracursos/barbearia (instância rodando em todos os nós)
  (por termos 5 nos, 3 managers e 2 workers,
```
<br />

**Service Discovery**<br>
*Git BASH*
```
$ docker-machine ssh vm1
  $ docker network create -d my_overlay (serviços utilizando essa rede, irão se comunicar via nome)
```
<br />

**Aplicações em Swarm (docker-compose.yml)**<br>
*Git BASH*
```
version: "3"
services:

  redis:
    image: redis:alpine
    networks:
      - frontend
    deploy:
      replicas: 1 (replicas para este container)
      restart_policy:
        condition: on-failure (politica de reinicialização - quando houver falha)
        
  db:
    image: postgres:9.4
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend
    deploy:
      placement:
        constraints: [node.role == manager] (adição de restrição - sera executado somente nos managers)
    environment:
        POSTGRES_HOST_AUTH_METHOD: trust

  vote:
    image: dockersamples/examplevotingapp_vote:before
    ports:
      - 5000:80
    networks:
      - frontend
    depends_on:
      - redis
    deploy:
      replicas: 2 (replicas para este container)
      restart_policy:
        condition: on-failure (politica de reinicialização - quando houver falha)

  result:
    image: dockersamples/examplevotingapp_result:before
    ports:
      - 5001:80
    networks:
      - backend
    depends_on:
      - db
    deploy:
      replicas: 1 (replicas para este container)
      restart_policy:
        condition: on-failure (politica de reinicialização - quando houver falha)

  worker:
    image: dockersamples/examplevotingapp_worker
    networks:
      - frontend
      - backend
    depends_on:
      - db
      - redis
    deploy:
      mode: replicated (pode ser modo global também)
      replicas: 1
      labels: [APP=VOTING] (etiqueta do serviço)
      restart_policy:
        condition: on-failure
      placement:
        constraints: [node.role == worker] (adição de restrição - sera executado somente nos workers)

  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - 8080:8080
    stop_grace_period: 1m30s
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.role == manager] (adição de restrição - sera executado somente nos managers)

networks:
  frontend:
  backend:

volumes:
  db-data:
```
<br />

**Subindo a stack(deploy docker-compose.yml)**<br>
*Git BASH*
```
$ docker-machine ssh vm1
  $ cat > docker-compose.yml
  $ ctrl+d
  $ docker stack deploy --compose-file docker-compose.yml vote (deploy da stack com o nome "vote")
  $ docker service ls --format "{{.Name}} {{.Replicas}}" (acompanhar...)
  http://<IP_vm1>:8080
  http://<IP_vm1>:5000
  http://<IP_vm1>:5001
  $ docker stack rm vote (remove toda stack criada)
```
<br />