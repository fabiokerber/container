# 3.Alura

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

<kbd>
    <img src="https://github.com/fabiokerber/Kubernetes/blob/main/img/070420221118.JPG">
</kbd>
<br />
<br />