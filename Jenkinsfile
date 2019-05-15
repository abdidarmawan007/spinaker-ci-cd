node ('jenkins-worker') {
   stage("Checkout") {
        checkout scm
   }
   stage('build docker image') {
      // Run build
         sh 'git status'
         sh 'docker build -t $GCP_REGISTRY_REGION/$GCP_PROJECT_ID/$DEPLOYMENT_NAME:$BRANCH-$BUILD_NUMBER -f Dockerfile .'
   }
   stage('push docker image to gcr') {
      // Run build
        sh 'gcloud auth configure-docker'
        sh 'docker push $GCP_REGISTRY_REGION/$GCP_PROJECT_ID/$DEPLOYMENT_NAME:$BRANCH-$BUILD_NUMBER'
   }
   stage('config env manifest k8s') {
      // Run build
         sh '''GKE_DEPLOYMENT_NAME=$DEPLOYMENT_NAME \\
             GKE_POD_CPU=$POD_CPU \\
             GKE_POD_MEMORY=$POD_MEMORY \\
             GKE_POD_MINIMUM_REPLICAS=$POD_MINIMUM_REPLICAS \\
             GKE_POD_HEALTHCHECK=$POD_HEALTHCHECK \\
             GKE_REGISTRY_REGION=$GCP_REGISTRY_REGION \\
             GKE_PROJECT_ID=$GCP_PROJECT_ID \\
             GKE_BRANCH=$BRANCH-$BUILD_NUMBER \\
             envsubst < k8s/10-deployment.yml > k8s/deployment.yml'''
   }
   stage('upload manifest k8s to gcs') {
      // Run build (folder gcs automated create with command "gsutil cp -r")
         sh 'gsutil cp -r k8s/deployment.yml gs://zeus-k8s-manifest/$DEPLOYMENT_NAME/'
   }
}