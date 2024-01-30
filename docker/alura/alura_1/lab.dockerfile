FROM ubuntu:latest 
MAINTAINER Fabio Kerber 
RUN apt update && apt install -y iputils-ping 
EXPOSE 3000 