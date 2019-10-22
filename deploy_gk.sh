#!/bin/bash

if [ $DEPLOY_GATEKEEPER = "true" ]; then
    kubectl apply -f clusterloader2/testing/gatekeeper/gk.yaml
    sleep 5

    if [ $DEPLOY_GATEKEEPER_SYNC = "true" ]; then
        # syncing pods + namespaces
        kubectl apply -f clusterloader2/testing/gatekeeper/sync.yaml
        sleep 5

        # deploying templates
        t="0"
        while [ $t -lt $NUMBER_TEMPLATES ]
        do
            export TEMPLATE_NAME=template-$(openssl rand -hex 6)

            envsubst < clusterloader2/testing/gatekeeper/allowedrepos-template-template.yaml > clusterloader2/testing/gatekeeper/allowedrepos-template.yaml

            kubectl apply -f clusterloader2/testing/gatekeeper/allowedrepos-template.yaml

            sleep 100

            t=$[$t+1]

            # number of constraints per template
            c="0"
            while [ $c -lt $NUMBER_CONSTRAINTS ]
            do
                export CONSTRAINT_NAME=repo-$(openssl rand -hex 6)

                envsubst < clusterloader2/testing/gatekeeper/allowedrepos-constraint-template.yaml > clusterloader2/testing/gatekeeper/allowedrepos-constraint.yaml

                kubectl apply -f clusterloader2/testing/gatekeeper/allowedrepos-constraint.yaml

                sleep 10

                c=$[$c+1]
            done
        done
    fi
fi
