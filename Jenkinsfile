pipeline {
    agent any
    
    environment {
        DOCKER_CREDS = credentials('dockerhub-credentials')
        IMAGE_NAME = 'dso101'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Prepare Secrets') {
            steps {
                script {
                    writeFile file: '.npmrc', text: """
registry=https://registry.npmjs.org/
//registry.npmjs.org/:_authToken=${env.NPM_TOKEN}
"""
                }
            }
        }
        
        stage('Build and Deploy') {
            parallel {
                stage('Build') {
                    steps {
                        script {
                            sh """
                                docker buildx build \
                                  --secret id=npmrc,src=./.npmrc \
                                  --cache-from=type=local,src=/tmp/docker-cache \
                                  --cache-to=type=local,dest=/tmp/docker-cache,mode=max \
                                  -t ${IMAGE_NAME}:${IMAGE_TAG} \
                                  --load .
                            """
                        }
                    }
                }
                stage('Deploy') {
                    steps {
                        script {
                            sh 'echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin'
                            sh "docker push $DOCKER_CREDS_USR/${IMAGE_NAME}:${IMAGE_TAG}"
                            sh "docker push $DOCKER_CREDS_USR/${IMAGE_NAME}:latest"
                        }
                    }
                }
            }
        }
    }
    
    post {
        always {
            node('any') {
                script {
                    echo 'Cleaning up...'
                    sh "docker logout"
                    sh "rm -f .npmrc"
                }
            }
        }
    }
}