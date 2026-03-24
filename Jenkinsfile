pipeline {
    agent any
    tools {
        nodejs 'node18'
        dockerTool 'docker'
        'hudson.plugins.sonar.SonarRunnerInstallation' 'SonarScanner'
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
                    dir('backend') { sh 'npm install --legacy-peer-deps --ignore-scripts' }
                    dir('frontend') { sh 'npm install --legacy-peer-deps --ignore-scripts' }
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
                                -Dsonar.projectKey=SpaceToStudy-Backend \
                                -Dsonar.testExecutionReportPaths="" \
                                -Dsonar.javascript.lcov.reportPaths=""
                            """
                        }
                        
                        dir('frontend') {
                            sh """
                                ${scannerHome}/bin/sonar-scanner \
                                -Dsonar.projectKey=SpaceToStudy-Frontend \
                                -Dsonar.testExecutionReportPaths="" \
                                -Dsonar.javascript.lcov.reportPaths=""
                            """
                        }
                    }
                }
            }
        }

        stage('3. Build & Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'nexus-auth', passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USR')]) {
                        sh 'docker login ${NEXUS_REGISTRY} -u ${NEXUS_USR} -p ${NEXUS_PWD}'
                        
                        def apps = ['backend', 'frontend']
                        apps.each { app ->
                            def imageTag = "${NEXUS_REGISTRY}/${app}:${env.BUILD_NUMBER}"
                            dir(app) {
                                sh "docker build -t ${imageTag} ."
                                sh "docker push ${imageTag}"
                            }
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
            sh 'docker logout ${NEXUS_REGISTRY} || true'
        }
    }
}