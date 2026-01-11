#!/bin/bash
set -e

kubectl apply -f db-secret.yaml
kubectl apply -f app-config.yaml

minikube ssh -- "sudo mkdir -p /data/mysql && sudo chmod 777 /data/mysql"

kubectl apply -f mysql-pv.yaml
kubectl apply -f mysql-pvc.yaml
kubectl apply -f mysql.yaml

kubectl rollout status statefulset/mysql --timeout=180s

kubectl apply -f wordpress.yaml
kubectl apply -f wordpress-service.yaml

echo
echo "Приложение доступно по адресу:"
minikube service wordpress --url
