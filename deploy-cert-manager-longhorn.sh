#!/bin/bash -x
admin_password=$1
rancher_server_url=$2
curlimage="appropriate/curl"
jqimage="stedolan/jq"
LOGINRESPONSE=$(docker run \
        --rm \
        $curlimage \
        -s "https://$rancher_server_url/v3-public/localProviders/local?action=login" -H 'content-type: application/json' --data-binary '{"username":"admin","password":"'$admin_password'"}' --insecure)
    LOGINTOKEN=$(echo $LOGINRESPONSE | docker run --rm -i $jqimage -r .token)

CLUSTERID=$(docker run \
    --rm \
    $curlimage \
      -sLk \
      -H "Authorization: Bearer $LOGINTOKEN" \
      "https://$rancher_server_url/v3/clusters?name=kodep" | docker run --rm -i $jqimage -r '.data[].id')

while true; do
    CLUSTERSTATE=$(docker run \
        --rm \
        $curlimage \
          -sLk \
          -H "Authorization: Bearer $LOGINTOKEN" \
          "https://$rancher_server_url/v3/clusters/$CLUSTERID" | docker run --rm -i $jqimage -r '.state' | head -1)

    if [ "$CLUSTERSTATE" == "active" ]; then
        break
    else
        sleep 30
    fi
done

curl -u "${LOGINTOKEN}" -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' 'https://'$rancher_server_url'/v3/clusters/'$CLUSTERID'?action=generateKubeconfig' | yq e -P - > conf.yaml
yq e 'del(.type, .baseType)' conf.yaml > $2.yaml
sed -i '1d' $rancher_server_url.yaml
rm -f conf.yaml

export KUBECONFIG=$rancher_server_url.yaml
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.8.0/cert-manager.yaml
sh -c "echo 'apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: cert-manager
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: devops@kodep.ru
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    # Enable the HTTP-01 challenge provider
    solvers:
    - http01:
        ingress:
          class: nginx' > production-issuer.yaml"
sleep 20
kubectl create -f production-issuer.yaml
rm -f production-issuer.yaml

kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.2.4/deploy/longhorn.yaml