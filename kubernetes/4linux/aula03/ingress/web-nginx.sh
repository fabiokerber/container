#!/bin/bash
export POD1=$(kubectl get pods -o wide | grep nginx-deploy1 | awk -F" " '{print $1}')
export POD2=$(kubectl get pods -o wide | grep nginx-deploy2 | awk -F" " '{print $1}')

echo 'Servidor Matriz - Nginx Ingress' > /tmp/index.html
kubectl cp /tmp/index.html $POD1:/usr/share/nginx/html/

echo 'Servidor Filial - Nginx Ingress' > /tmp/index.html
kubectl cp /tmp/index.html $POD2:/usr/share/nginx/html/
