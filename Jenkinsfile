pipeline {
    agent { label 'docker-agent' }

    tools {
        nodejs 'node18'
    }

    environment {
        NEXUS_REGISTRY = "${env.NEXUS_REGISTRY}"
        SONAR_SCANNER_OPTS = "-Xmx2048m -XX:ReservedCodeCacheSize=256m"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis - Backend') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('MySonarServer') {
                        dir('backend') {
                            sh """
                                ${scannerHome}/bin/sonar-scanner \
                                  -Dsonar.javascript.node.maxspace=4096
                            """
                        }
                    }
                }
            }
        }

        stage('SonarQube Analysis - Frontend') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('MySonarServer') {
                        dir('frontend') {
                            sh """
                                ${scannerHome}/bin/sonar-scanner \
                                  -Dsonar.javascript.node.maxspace=4096
                            """
                        }
                    }
                }
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'nexus-auth',
                        usernameVariable: 'NEXUS_USR',
                        passwordVariable: 'NEXUS_PWD'
                    )
                ]) {
                    sh 'echo "${NEXUS_PWD}" | docker login ${NEXUS_REGISTRY} -u "${NEXUS_USR}" --password-stdin'
                }
            }
        }

        stage('Docker Build & Push - Backend') {
            steps {
                dir('backend') {
                    sh """
                        docker build \
                          -t ${NEXUS_REGISTRY}/backend:${BUILD_NUMBER} \
                          -t ${NEXUS_REGISTRY}/backend:latest \
                          .
                    """
                    sh "docker push ${NEXUS_REGISTRY}/backend:${BUILD_NUMBER}"
                    sh "docker push ${NEXUS_REGISTRY}/backend:latest"
                }
            }
        }

        stage('Docker Build & Push - Frontend') {
            steps {
                dir('frontend') {
                    sh """
                        docker build \
                          -t ${NEXUS_REGISTRY}/frontend:${BUILD_NUMBER} \
                          -t ${NEXUS_REGISTRY}/frontend:latest \
                          .
                    """
                    sh "docker push ${NEXUS_REGISTRY}/frontend:${BUILD_NUMBER}"
                    sh "docker push ${NEXUS_REGISTRY}/frontend:latest"
                }
            }
        }
    }

    post {
        always {
            sh "docker logout ${NEXUS_REGISTRY} || true"
            cleanWs()
        }
    }
}