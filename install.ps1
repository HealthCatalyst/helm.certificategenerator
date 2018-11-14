
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

if (0 -ne $LastExitCode) {
    Write-Error "helm threw an error"
    exit 1
}

Write-Host "Listing packages"
helm list

kubectl get "deployments,pods,services,ingress,secrets" --namespace=$namespace -o wide

Write-Host "--- Waiting for certificategenerator pod to complete ---"
kubectl wait job --for=condition=complete --timeout=30s -l app=certificategenerator -n kube-system

kubectl describe pod -l app=certificategenerator -n kube-system

kubectl logs -l app=certificategenerator -n kube-system

# kubectl attach -it -l app=certificategenerator -n kube-system