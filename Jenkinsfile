// use node/worker build with label jenkins-worker and send slack notif if build start
node ('jenkins-worker') {
   try {
        notifySlack()

   stage('Checkout') {
      // run clean dir and checkout scm
      deleteDir()
      checkout scm
      sh 'git status'
   }
   stage('build docker image') {
      // run build
      sh 'docker build -t $GCP_REGISTRY_REGION/$GCP_PROJECT_ID/$DEPLOYMENT_NAME:$BRANCH-$BUILD_NUMBER -f Dockerfile .'
   }
   stage('push docker image to gcr') {
      // run build
      sh 'gcloud auth configure-docker'
      sh 'docker push $GCP_REGISTRY_REGION/$GCP_PROJECT_ID/$DEPLOYMENT_NAME:$BRANCH-$BUILD_NUMBER'
   }
   stage('config env manifest k8s') {
      // run build
      sh '''GKE_DEPLOYMENT_NAME=$DEPLOYMENT_NAME \\
         GKE_DEPLOYMENT_ENV=$DEPLOYMENT_ENV \\
         GKE_POD_CPU=$POD_CPU \\
         GKE_POD_MEMORY=$POD_MEMORY \\
         GKE_POD_MINIMUM_REPLICAS=$POD_MINIMUM_REPLICAS \\
         GKE_POD_HEALTHCHECK=$POD_HEALTHCHECK \\
         GKE_REGISTRY_REGION=$GCP_REGISTRY_REGION \\
         GKE_PROJECT_ID=$GCP_PROJECT_ID \\
         envsubst < k8s/10-deployment.yml > k8s/deployment.yml'''
   }
   stage('upload manifest k8s to gcs') {
      // run build (folder gcs automated create with command "gsutil cp -r")
      sh 'gsutil cp -r k8s/deployment.yml gs://zeus-k8s-manifest/$DEPLOYMENT_NAME/'
   }


// CONFIG SLACK NOTIF !
} catch (e) {
        currentBuild.result = 'FAILURE'
        throw e
    } finally {
        notifySlack(currentBuild.result)
    }
}

def notifySlack(String buildStatus = 'STARTED') {
    // Build status of null means success.
    buildStatus = buildStatus ?: 'SUCCESS'

    def color

    if (buildStatus == 'STARTED') {
        color = '#D4DADF'
    } else if (buildStatus == 'SUCCESS') {
        color = '#00FF00'
    } else if (buildStatus == 'UNSTABLE') {
        color = '#fffd00'
    } else {
        color = '#FF0000'
    }

    def msg = "${buildStatus}: `${env.JOB_NAME}` #${env.BUILD_NUMBER}:\n${env.BUILD_URL}"

    slackSend(color: color, message: msg)
}