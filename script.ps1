# This will give client id and password
az ad sp create-for-rbac --skip-assignment

# This will give acr id
az acr show --resource-group {resource group} --name {name} --query "id" --output tsv

# Replace {client id} and {acr id} with acr id retrived from above
az role assignment create --assignee {client id} --scope {acr id} --role Reader

# Then create AKS cluster using client id and password in authentication section

az aks get-credentials --resource-group {resource group} --name {name}

# Replace {service name} and wait till public IP address is available then stop watch or use CTRL-C
kubectl get service {service name} --watch 

# Create kubernetes-dashboard
kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard

#---- Optional ----
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
#------------------

# Configure nginx-ingress
kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
helm init --upgrade
helm install stable/nginx-ingress
helm install --set config.LEGO_EMAIL={email address} --set config.LEGO_URL=https://acme-v01.api.letsencrypt.org/directory stable/kube-lego
kubectl create -f ingress-ssl.yaml
kubectl get ing
kubectl get svc
