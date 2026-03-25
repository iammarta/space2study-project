pipeline {
    agent any

    tools {
        nodejs 'node18'
    }

    environment {
        NEXUS_REGISTRY = "host.docker.internal:8082"
        DOCKER_API_VERSION = "1.44"
        SONAR_SCANNER_OPTS = "-Xmx2048m -XX:ReservedCodeCacheSize=256m"
    }

    stages {
        stage('1. Preparation') {
            steps {
                checkout scm
                script {
                    dir('backend') {
                        sh 'npm install --legacy-peer-deps --ignore-scripts'
                    }
                    dir('frontend') {
                        sh 'npm install --legacy-peer-deps --ignore-scripts'
                    }
                }
            }
        }

        stage('2. SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'

                    withSonarQubeEnv('MySonarServer') {
                        dir('backend') {
                            sh """
                                ${scannerHome}/bin/sonar-scanner \
                                -Dsonar.projectKey=ita-social-projects_SpaceToStudy-BackEnd \
                                -Dsonar.testExecutionReportPaths=""
                            """
                        }

                        dir('frontend') {
                            sh """
                                ${scannerHome}/bin/sonar-scanner \
                                -Dsonar.projectKey=ita-social-projects_SpaceToStudy-Client \
                                -Dsonar.testExecutionReportPaths=""
                            """
                        }
                    }
                }
            }
        }

        stage('3. Build & Push') {
            steps {
                script {
                    sh 'which docker'
                    sh 'docker version'

                    withCredentials([usernamePassword(
                        credentialsId: 'nexus-auth',
                        usernameVariable: 'NEXUS_USR',
                        passwordVariable: 'NEXUS_PWD'
                    )]) {
                        sh '''
                            echo "$NEXUS_PWD" | docker login "$NEXUS_REGISTRY" -u "$NEXUS_USR" --password-stdin
                        '''

                        def apps = ['backend', 'frontend']

                        apps.each { app ->
                            def buildTag = "${NEXUS_REGISTRY}/${app}:${env.BUILD_NUMBER}"
                            def latestTag = "${NEXUS_REGISTRY}/${app}:latest"

                            dir(app) {
                                sh """
                                    docker build -t ${buildTag} -t ${latestTag} .
                                    docker push ${buildTag}
                                    docker push ${latestTag}
                                """
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout "$NEXUS_REGISTRY" || true'
            cleanWs()
        }
    }
}