pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub'
        IMAGE_NAME = 'humzaaa/django-notes-app'
    }

    stages {

        stage('Clone the Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/malik-hamza2/django-notes-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    env.IMAGE_TAG = "${IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh "docker build -t ${env.IMAGE_TAG} ."
                }
            }
        }

        stage('Login in Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDENTIALS_ID}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh "docker push ${env.IMAGE_TAG}"
            }
        }

        stage('Run Docker Containers') {
            steps {
                sh "docker run -d -p 8001:8000 --name dev ${env.IMAGE_TAG}"
                sh "docker run -d -p 8002:8000 --name staging ${env.IMAGE_TAG}"
            }
        }
    }

    post {
        success {
            echo "Dev on 8001 and Staging on 8002"
        }

        failure {
            echo "Deployment Failed"
        }
    }
}
