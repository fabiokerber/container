# 1.Alura

### Docker
<br />

**Anotações**<br>
    *Docker Hub / Docker Store é o repositório oficial de imagens de containers.*<br>
    *Camadas dos containers podem ser "compartilhadas entre si" e as que são baixadas são "read only". Quando altera-se algo é modificado em uma nova camada "read/write".*<br>
    *Na rede default do Docker os containers só se comunicam via IP. Para que a comunicação seja realizada por hostname, é necessário criar uma outra rede e atribuir os containers à esta rede.*
<br />

**Início**
```
> docker run hello-world
> docker run ubuntu
> docker ps
> docker ps -a
> docker run ubuntu echo "Ola Mundo"
> docker run -it ubuntu (sobe o container e já conecta no terminal do mesmo)
> docker start <ID>
> docker stop <ID>
> docker history <ID_IMAGEM>
```
<br />

**Layered File System (camadas)**
```
> docker rm <ID>
> docker container prune (remove todos os containers inativos/stopped)
> docker images (exibe todas as imagens já baixadas)
> docker rmi hello-world (remove imagem hello-world)
> docker run ubuntu:14.04 (roda container do ubuntu com da versao especifica)
```
<br />

**Praticando**
```
> docker run dockersamples/static-site (imagens não oficiais é necessário informar <mantenedor>/<nome_imagem>)
    > docker ps (outro terminal)
> docker run -d dockersamples/static-site (detached)
> docker container prune
> docker run -d -P dockersamples/static-site (atribui porta externa aleatoria da maquina local para o container)
> docker port <ID> (lista portas em uso pelo container)
    http://localhost:<port>
> docker run -d -P --name meu-site dockersamples/static-site (atribui o nome "meu-site" ao container)
> docker stop -t 0 meu-site (interrompe o container de forma mais rápida)
> docker run -d -p 12345:80 --name meu-site dockersamples/static-site (mapeia porta 12345 local para a porta 80 do container)
> docker run -d -P -e AUTHOR="Borracha" --name meu-site dockersamples/static-site (starta o container com um valor atribuído a variável AUTHOR)
    > http://localhost:<port>
> docker ps -q (lista somente os ID's dos containers)
> docker stop $(docker ps -q) (para todos os containers listados com o ps -q)
```
<br />

**Salvando dados com volumes**
```
> docker run -v "/var/www" ubuntu (mapeia a pasta /var/lib... para /var/www dentro do container)
> docker inspect <ID>
    Mounts...
> docker run -it -v "C:\Temp:/var/www" ubuntu (mapeia a pasta C:\Temp para /var/www dentro do container)
> docker run -p 8080:3000 -v "C:\Temp:/var/www" -w "/var/www" node npm start ("inicia" o container na pasta /var/www e executa o comando "node npm start", logo apos a criação do container)
> docker run -p 8080:3000 -v "$(pwd):/var/www" -w "/var/www" node npm start
```
<br />

**Criando um Dockerfile e "buildando"**
```
Criar 01.dockerfile
---
FROM node:latest (monta imagem a partir de uma outra imagem fonte)
MAINTAINER Fabio Kerber (mantenedor da imagem, quem é responsável pela imagem - depreciado por LABEL)
COPY . /var/www (copia conteudo pasta local para /var/www)
RUN npm install (executa comando apos a criação do container)
WORKDIR /var/www (seta o path padrao para execucao dos comandos abaixo - no exemplo os arquivos estao em /var/www)
ENTRYPOINT [ "npm", "start" ](quando imagem for startada tera um comando de entrada - funciona conforme acima também)
EXPOSE 3000 (permite a exposição da porta 3000)
---

> docker build -f 01.dockerfile -t fabiokerber/node 01.dockerfile (-f indicar arquivo a ser buildado | -t <mantenedor>/<nomeimagem>)

> docker build -f lab.dockerfile -t meu_ubuntu .
> docker images
```
<br />

**Networking**
```
> docker run -it ubuntu
> docker ps -q
> docker inspect <ID>
    NetworkSettings
        Networks
            Bridge (rede default containers, onde a comunicação entre containers é realizada)
> docker network create --driver bridge minha-rede (cria uma rede chamada minha rede e normalmente o bridge já atende as necessidade)
> docker network ls
> docker run -it --name meu-container-de-ubuntu --network minha-rede ubuntu 
    apt update && apt install -y iputils-ping 
> docker inspect meu-container-de-ubuntu
    NetworkSettings
        Networks
            minha-rede
> docker run -it --name meu-segundo-container-de-ubuntu --network minha-rede ubuntu
    apt update && apt install -y iputils-ping 
    ping meu-container-de-ubuntu (testa o ping entre o segundo e o primeiro via hostname)
```
<br />

**Docker Compose**
```
Cria arquivo docker-compose.yml
---
version: '3' (checar ultima versao)

services: (diferentes partes da aplicação, cada parte da aplicação por exemplo cinco containers = cinco serviços)

  nginx: 
    build: (informa que o nginx sera construido a partir de outra imagem, neste caso o nginx.dockerfile)
      dockerfile: ./docker/nginx.dockerfile (contruido a partir de um dockerfile)
      context: . (busca a partir da pasta raiz)
    image: fabiokerber/nginx (identificacao da imagem)
    container_name: nginx (nome a ser atribuido apos a criação do container)
    ports:
      - "80:80" (80 local para 80 do container)
    networks:
      - prod-net
    depends_on:
      - "node1"
      - "node2"
      - "node3"

  mongodb:
    image: mongo
    networks:
      - prod-net

  node1:
    build:
      dockerfile: . /docker/alura-books.dockerfile
      context: .
    image: fabiokerber/alura-books
    container_name: alura-books-1
    ports:
      - "3000"
    networks:
      - prod-net
    depends_on:
      - "mongodb" (só é executado quando o container do mongodb subiu)

  node2:
    build:
      dockerfile: . /docker/alura-books.dockerfile
      context: .
    image: fabiokerber/alura-books
    container_name: alura-books-2
    ports:
      - "3000"
    networks:
      - prod-net
    depends_on:
      - "mongodb" (só é executado quando o container do mongodb subiu)

        node3:
    build:
      dockerfile: . /docker/alura-books.dockerfile
      context: .
    image: fabiokerber/alura-books
    container_name: alura-books-3
    ports:
      - "3000"
    networks:
      - prod-net
    depends_on:
      - "mongodb" (só é executado quando o container do mongodb subiu)

networks:
  prod-net: (cria a network prod-net)
    driver: bridge (especifica o driver a ser utilizado pela network recem criada)
---

> docker-compose build (busca o docker-compose na pasta atual e "builda")
> docker-compose up (cria de fato todo o ambiente)
> docker-compose up -d (libera terminal)
> docker-compose ps (processos rodando)
> docker-compose down (para os containers e os remove)

http://localhost:80 (5x F5)
http://localhost/seed
http://localhost:80 (1x F5)
```
<br />

## Sobre Microsserviços<br>
Já ouviu falar de Microsserviços? Se já ouviu, pode pular a introdução abaixo e ir diretamente para a parte "Docker e Microsserviços", senão continue comigo.
<br />
<br />
Uma forma de desenvolver uma aplicação é colocar todas as funcionalidades em um único "lugar". Ou seja, a aplicação roda em uma única instância (ou servidor) que possui todas as funcionalidades. Isso talvez seja a forma mais simples de criar uma aplicação (também a mais natural), mas quando a base de código cresce, alguns problemas podem aparecer.
<br />
<br />
Por exemplo, qualquer atualização ou *bug fix* necessita parar todo o sistema, buildar o sistema todo e subir novamente. Isso pode ficar demorado e lento. Em geral, quanto maior a base de código mais difícil será manter ela mesmo com uma boa cobertura de testes e as desvantagens não param por ai. Outro problema é se alguma funcionalidade possuir um gargalo no desempenho o sistema todo será afetado. Não é raro de ver sistemas onde relatórios só devem ser gerados à noite para não afetar o desempenho de outras funcionalidades. Outro problema comum é com os ciclos de testes e *build* demorados (falta de agilidade no desenvolvimento), problemas no monitoramento da aplicação ou falta de escalabilidade. Enfim, o sistema se torna um legado pesado, onde nenhum desenvolvedor gostaria de colocar a mão no fogo.
<br />
## Arquitetura de Microsserviços<br>
Então a ideia é fugir desse tipo de arquitetura monolítica monstruosa e dividir ela em pequenos pedaços. Cada pedaço possui uma funcionalidade bem definida e roda como se fosse um "mini sistema" isolado. Ou seja, em vez de termos uma única aplicação enorme, teremos várias instâncias menores que dividem e coordenam o trabalho. Essas instâncias são chamadas de Microsserviços.
<br />
<br />
Agora fica mais fácil monitorar cada serviço específico, atualizá-lo ou escalá-lo pois a base de código é muito menor, e assim o *deploy* e o teste serão mais rápidos. Podemos agora achar soluções específicas para esse serviço sem precisar alterar os demais. Outra vantagem é que um desenvolvedor novo não precisa conhecer o sistema todo para alterar uma funcionalidade, basta ele focar na funcionalidade desse microsserviço.
<br />
<br />
Importante também é que um microsserviço seja acessível remotamente, normalmente usando o protocolo HTTP trocando mensagens JSON ou XML, mas nada impede que outro protocolo seja usado. Um microsserviço pode usar outros serviços para coordenar o trabalho.
<br />
<br />
Repare que isso é uma outra abordagem arquitetural bem diferente do monolítico e por isso também é chamado de *arquitetura de microsserviços*.
<br />
<br />
Por fim, uma arquitetura de Microsserviços tem um grau de complexidade muito alta se comparada com uma arquitetura monolítica. Aliás, há aqueles profissionais que indicam partir para uma arquitetura monolítica primeiro e mudar para uma baseada em microsserviços depois, quando estritamente necessário.
<br />
## Docker e Microsserviços<br>
Trabalhar com uma arquitetura de microsserviços gera a necessidade de publicar o serviço de maneira rápida, leve, isolada e vimos que o **Docker** possui exatamente essas características! Com **Docker** e **Docker Compose** podemos criar um ambiente ideal para a publicação destes serviços.
<br />
<br />
O **Docker** é uma ótima opção para rodar os microsserviços pelo fato de isolar os containers. Essa utilização de containers para serviços individuais faz com que seja muito simples gerenciar e atualizar esses serviços, de maneira automatizada e rápida.
<br />
## Docker Swarm<br>
Ok, tudo bem até aqui. Agora vou ter vários serviços rodando usando o **Docker**. E para facilitar a criação desses containers já aprendemos usar o **Docker Compose** que sabe subir vários containers. O **Docker Compose** é a ferramenta ideal para coordenar a criação dos containers, no entanto para melhorar a escalabilidade e desempenho pode ser necessário criar muito mais containers para um serviço específico. Em outras palavras, agora gostaríamos de criar muitos containers aproveitando várias máquinas (virtuais ou físicas)! Ou seja, pode ser que um microsserviço fique rodando em 20 containers usando três máquinas físicas diferentes. Como podemos facilmente subir e parar esses containers? Repare que o **Docker Compose** não é para isso e por isso existe uma outra ferramenta que se chama **Docker Swarm** (que não faz parte do escopo desse curso).
<br />
<br />
**Docker Swarm** facilita a criação e administração de um cluster de containers.