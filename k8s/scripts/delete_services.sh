#!/bin/bash

kubectl delete -f "../k8s/ingress.yaml"
kubectl delete -f "../k8s/service.yaml"
kubectl delete -f "../k8s/deployment.yaml"
kubectl delete -f "../k8s/secret.yaml"
kubectl delete -f "../k8s/namespace.yaml"

