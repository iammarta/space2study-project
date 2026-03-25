pipeline {
    agent any

    tools {
        nodejs 'node18'
    }

    environment {
        NEXUS_REGISTRY = "host.docker.internal:8082"
        SONAR_SCANNER_OPTS = "-Xmx2048m -XX:ReservedCodeCacheSize=256m"
    }

    stages {
        stage('1. Preparation') {
            steps {
                script {
                    ['backend', 'frontend'].each { dirName ->
                        dir(dirName) {
                            sh 'npm install --legacy-peer-deps --ignore-scripts'
                        }
                    }
                }
            }
        }

        stage('2. SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('MySonarServer') {
                        ['backend': 'BackEnd', 'frontend': 'Client'].each { folder, suffix ->
                            dir(folder) {
                                sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=ita-social-projects_SpaceToStudy-${suffix} -Dsonar.testExecutionReportPaths=''"
                            }
                        }
                    }
                }
            }
        }

        stage('3. Build & Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'nexus-auth', usernameVariable: 'USR', passwordVariable: 'PWD')]) {
                        sh "echo '${PWD}' | docker login ${NEXUS_REGISTRY} -u '${USR}' --password-stdin"

                        ['backend', 'frontend'].each { app ->
                            def tag = "${NEXUS_REGISTRY}/${app}:${env.BUILD_NUMBER}"
                            def latest = "${NEXUS_REGISTRY}/${app}:latest"
                            
                            dir(app) {
                                sh "docker build -t ${tag} -t ${latest} ."
                                sh "docker push ${tag}"
                                sh "docker push ${latest}"
                            }
                        }
                    }
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