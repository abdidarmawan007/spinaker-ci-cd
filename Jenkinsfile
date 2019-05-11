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