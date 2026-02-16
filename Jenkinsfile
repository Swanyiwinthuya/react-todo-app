pipeline {
  agent any

  environment {
    CI = 'true'

    // Docker Hub settings
    DOCKER_HUB_USER  = 'swanyi'
    IMAGE_NAME       = 'finead-todo-app'
    DOCKER_HUB_CREDS = 'docker-hub-credentials'  // must match Jenkins Credential ID
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build (npm install)') {
      steps {
        // Use npm ci if lock file exists; fallback to npm install
        sh 'npm ci || npm install'
      }
    }

    stage('Test') {
      agent {
        docker {
          image 'mrts/docker-python-nodejs-google-chrome'
          reuseNode true
        }
      }
      steps {
        sh 'npm ci || npm install'
        sh 'npm test'
      }
    }

    stage('Containerize') {
      steps {
        echo 'Building Docker image...'
        sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest ."
      }
    }

    stage('Push') {
      steps {
        echo 'Login + Push to Docker Hub...'
        withCredentials([usernamePassword(
          credentialsId: "${DOCKER_HUB_CREDS}",
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
          sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
        }
      }
    }
  }

  post {
    always {
      echo 'Clean up local image...'
      sh "docker rmi ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest || true"
    }
  }
}
