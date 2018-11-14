
# helm init --upgrade --service-account tiller

helm del --purge certificategenerator

Start-Sleep -Seconds 10

$namespace = "kube-system"

Start-Sleep -Seconds 10

# https://docs.helm.sh/using_helm/
Write-Host "Now installing for real"
helm install ./certificategenerator `
        --name certificategenerator `
        --set-string certhostname=foo.foo.com `
        --set-string certpassword=myfoo `
        --set-string clientCertificateUser=fabricrabbitmquser `
        --namespace kube-system `
        --debug

Write-Host "Listing packages"
helm list

kubectl get "deployments,pods,services,ingress,secrets" --namespace=$namespace -o wide

Start-Sleep -Seconds 30

kubectl logs -l app=certificategenerator -n kube-system

# kubectl attach -it -l app=certificategenerator -n kube-system