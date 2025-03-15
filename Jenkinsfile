pipeline {
    agent any

    environment {
        IMAGE_NAME = "avinashcemk2010/php-app"
    }

    stages {

        stage('Debugging') {
            steps {
                script {
                    sh "whoami"  // Check which user Jenkins is running as
                    sh "echo %PATH%"  // Check environment variables
                    sh "git --version"  // Verify Git is installed
                    sh "docker --version"  // Verify Docker is installed
                }
            }
        }

        stage('Checkout Code') {
            steps {
                script {
                    try {
                        git branch: 'master', url: 'https://github.com/avinashcemk2010/devops-proj.git'
                    } catch (Exception e) {
                        error "Failed to checkout code: ${e.message}"
                    }
                }
            }
        }

        stage('Check System Resources') {
            steps {
                sh "df -h"  // Check disk space
                sh "docker system df"  // Check Docker storage usage
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        sh "docker build --progress=plain --no-cache -t ${IMAGE_NAME}:latest -f Dockerfile ."
                    } catch (Exception e) {
                        echo "Docker build failed! Checking logs..."
                        sh "docker images"  // Show existing Docker images
                        sh "docker system df"  // Show Docker storage usage
                        error "Docker build failed. Check logs above."
                    }
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        try {
                            sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                        } catch (Exception e) {
                            error "Docker login failed: ${e.message}"
                        }
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    try {
                        sh "docker push ${IMAGE_NAME}:latest"
                    } catch (Exception e) {
                        error "Docker push failed: ${e.message}"
                    }
                }
            }
        }
    }

    post {
        always {
            sh "docker logout"
        }
    }
}
