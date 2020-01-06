#!/bin/bash
# exit script when any command ran here returns with a non-zero exit code
set -e

COMMIT_SHA1=$CIRCLE_SHA1

# We must export it so that it's available for envsubst
export COMMIT_SHA1=$COMMIT_SHA1

# since the only way to envsubst to work on files is using input/ouput redirection,
# it's not possible to do in-place substitution so we need to save the output to another file
# and overwrite the original with that one
envsubst <./kube/do-sample-deployment.yaml >./kube/do-sample-deployment.yml.out
mv ./kube/do-sample-deploymnet.yml.out ./kube/do-sample-deployment.yml

echo "$KUBERNETES_CLUSTER_CERTIFICATE" | base64 --decode > cert.crt

./kubectl \
  --kubeconfig=/dev/null \
  --server=$KUBERNETES_SERVER \
  --certificate-authority-=cert.crt \
  --token=$KUBERNETES_TOKEN \
  apply -f ./kube/