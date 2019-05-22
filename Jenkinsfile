// use node/worker build with label jenkins-worker and send slack notif if build start
node ('jenkins-worker') {
   try {
        notifyBuild('STARTED')

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
      // If there was an exception thrown, the build failed
      currentBuild.result = "FAILED"
      throw e
   } finally {
      // Success or failure, always send notifications
      notifyBuild(currentBuild.result)
  }
}

def notifyBuild(String buildStatus = 'STARTED') {
  // build status of null means successful
  buildStatus =  buildStatus ?: 'SUCCESSFUL'

  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
  def summary = "${subject} (${env.BUILD_URL})"

  // Override default values based on build status
  if (buildStatus == 'STARTED') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'SUCCESSFUL') {
    color = 'GREEN'
    colorCode = '#00FF00'
  } else {
    color = 'RED'
    colorCode = '#FF0000'
  }

  // Send notifications
  slackSend (color: colorCode, message: summary)
}
