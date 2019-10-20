#!/bin/bash

if [ $DEPLOY_GATEKEEPER = "true" ]; then
    kubectl apply -f clusterloader2/testing/gatekeeper/gk.yaml
    sleep 5

    if [ $DEPLOY_GATEKEEPER_SYNC = "true" ]; then
        kubectl apply -f clusterloader2/testing/gatekeeper/sync.yaml
        sleep 5

        # TODO: multiple templates
        if [ $DEPLOY_GATEKEEPER_TEMPLATE = "true" ]; then
            kubectl apply -f clusterloader2/testing/gatekeeper/allowedrepos-template.yaml
            sleep 100

            i="0"
            while [ $i -lt $NUMBER_CONSTRAINTS ]
            do
                export CONSTRAINT_NAME=repo-$(openssl rand -hex 6)

                envsubst < clusterloader2/testing/gatekeeper/allowedrepos-constraint-template.yaml > clusterloader2/testing/gatekeeper/allowedrepos-constraint.yaml

                kubectl apply -f clusterloader2/testing/gatekeeper/allowedrepos-constraint.yaml

                sleep 10

                i=$[$i+1]
            done
        fi
    fi
fi
