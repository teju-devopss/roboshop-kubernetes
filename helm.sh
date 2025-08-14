aws eks update-kubeconfig --name dev-eks

if [ "$1" == "install" ]; then
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo add elastic https://helm.elastic.co
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo add autoscaler https://kubernetes.github.io/autoscaler


  helm repo update

  helm upgrade -i ngx-ingres ingress-nginx/ingress-nginx
  kubectl apply -f external-dns.yml
  helm upgrade -i filebeat elastic/filebeat -f filebeat.yml
  helm upgrade -i prometheus prometheus-community/kube-prometheus-stack -f prometheus.yml
  helm upgrade -i node-autoscaler  autoscaler/cluster-autoscaler --set 'autoDiscovery.clusterName'=dev-eks
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
fi

if [ "$1" == "uninstall" ]; then
  helm uninstall ngx-ingres
  kubectl delete -f external-dns.yml
  helm uninstall filebeat
  helm uninstall prometheus
  helm uninstall node-autoscaler
fi

