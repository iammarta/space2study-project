pipeline {
    agent { label 'docker-agent' }

    tools {
        nodejs 'node18'
    }

    environment {
        NEXUS_REGISTRY = "host.docker.internal:8082"
        SONAR_SCANNER_OPTS = "-Xmx2048m -XX:ReservedCodeCacheSize=256m"
    }

    stages {
        stage('Check Agent') {
            steps {
                sh 'echo "Running on:"'
                sh 'hostname'
                sh 'whoami'
                sh 'docker version'
            }
        }
        
        stage('Preparation') {
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

        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('MySonarServer') {
                        ['backend': 'BackEnd', 'frontend': 'Client'].each { folder, suffix ->
                            dir(folder) {
                                sh """
                                  ${scannerHome}/bin/sonar-scanner \
                                    -Dsonar.projectKey=ita-social-projects_SpaceToStudy-${suffix} \
                                    -Dsonar.testExecutionReportPaths= \
                                    -Dsonar.javascript.node.maxspace=4096
                                """
                            }
                        }
                    }
                }
            }
        }

        stage('Build & Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'nexus-auth', usernameVariable: 'NEXUS_USR', passwordVariable: 'NEXUS_PWD')]) {
                        sh 'echo "${NEXUS_PWD}" | docker login ${NEXUS_REGISTRY} -u "${NEXUS_USR}" --password-stdin'

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