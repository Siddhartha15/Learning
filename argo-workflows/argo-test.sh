#!/bin/bash

for i in `seq 1 1000`; do curl http://localhost:2746/api/v1/workflows/default --insecure -H 'Content-Type: application/json' \
   -d '{
   "workflow": {
     "metadata": {
       "generateName": "test-argo-"
     },
     "spec": {
       "activeDeadlineSeconds":600,
       "templates": [
         {
           "name": "test-argo",
           "container": {
             "image": "alpine",
             "command": [
               "sh","-c"
             ],
             "args":[
                "echo Hello World && sleep 120"
             ],
             "resources":{
              "limits":{
                "memory":"1024Mi",
                "cpu":"1500m"
              },
              "requests":{
                "memory":"1024Mi",
                "cpu":"1500m"
              }
             }
           }
         }
       ],
       "entrypoint": "test-argo",
       "imagePullSecrets": [
         {
           "name": "regcred"
         }
       ],
       "ttlStrategy": {
          "secondsAfterCompletion": 3600,
          "secondsAfterSuccess":    3600,
          "secondsAfterFailure":    3600
        }
     }
   }
 }' && echo ""; done