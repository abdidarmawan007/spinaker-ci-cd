pipeline {
  agent {
    node {
      label 'jenkins-worker'
    }

  }
  stages {
    stage('build docker images') {
      steps {
        sh '''#!/bin/bash -ex
## build docker images ##

docker build -t $GCP_REGISTRY_REGION/$GCP_PROJECT_ID/$DEPLOYMENT_NAME:$BRANCH-$BUILD_NUMBER -f Dockerfile .'''
      }
    }
    stage('push docker image') {
      steps {
        sh '''#!/bin/bash -ex


## push docker image to gcr ##

gcloud auth configure-docker

docker push $GCP_REGISTRY_REGION/$GCP_PROJECT_ID/$DEPLOYMENT_NAME:$BRANCH-$BUILD_NUMBER'''
      }
    }
    stage('config env k8s and upload to gcs') {
      steps {
        sh '''#!/bin/bash -ex
## config env and upload manifest k8s to gcs ##

GKE_DEPLOYMENT_NAME=$DEPLOYMENT_NAME \\
GKE_POD_CPU=$POD_CPU \\
GKE_POD_MEMORY=$POD_MEMORY \\
GKE_POD_MINIMUM_REPLICAS=$POD_MINIMUM_REPLICAS \\
GKE_POD_HEALTHCHECK=$POD_HEALTHCHECK \\
GKE_REGISTRY_REGION=$GCP_REGISTRY_REGION \\
GKE_PROJECT_ID=$GCP_PROJECT_ID \\
GKE_BRANCH=$BRANCH-$BUILD_NUMBER \\
envsubst < k8s/10-deployment.yml > k8s/deployment.yml


gsutil cp k8s/deployment.yml gs://abdi-zeus-k8s/'''
      }
    }
  }
  environment {
    BRANCH = 'develop'
    GCP_PROJECT_ID = 'zeus-cloud-238017'
    GCP_REGISTRY_REGION = 'asia.gcr.io'
    DEPLOYMENT_NAME = 'develop-golang'
    POD_CPU = '50m'
    POD_MEMORY = '50Mi'
    POD_MINIMUM_REPLICAS = '2'
    POD_HEALTHCHECK = '/'
  }
}