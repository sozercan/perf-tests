#!/bin/bash

if [ $DEPLOY_GATEKEEPER = "true" ]; then
    kubectl apply -f $(modulePath)/clusterloader2/testing/gatekeeper/gk.yaml
    sleep 5

    if [ $DEPLOY_GATEKEEPER_SYNC = "true" ]; then
        kubectl apply -f $(modulePath)/clusterloader2/testing/gatekeeper/sync.yaml
        sleep 5
    fi

    if [ $DEPLOY_GATEKEEPER_TEMPLATE = "true" ]; then
        kubectl apply -f $(modulePath)/clusterloader2/testing/gatekeeper/allowedrepos-template.yaml
        sleep 60
        kubectl apply -f $(modulePath)/clusterloader2/testing/gatekeeper/allowedrepos-constraint.yaml
        sleep 60
    fi
fi
