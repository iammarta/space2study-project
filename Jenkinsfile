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
                    def components = ['backend', 'frontend']
                    
                    withSonarQubeEnv('MySonarServer') {
                        components.each { folder ->
                            dir(folder) {
                                sh "${scannerHome}/bin/sonar-scanner \
                                    -Dsonar.projectKey=SpaceToStudy-${folder.capitalize()} \
                                    -Dsonar.javascript.node.maxspace=2048 || true"
                            }
                        }
                    }
                }
            }
        }

        stage('3. Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-auth', passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USR')]) {
                    script {
                        sh "echo ${NEXUS_PWD} | docker login ${NEXUS_REGISTRY} -u ${NEXUS_USR} --password-stdin"
                        def apps = ['backend', 'frontend']
                        apps.each { app ->
                            def imageTag = "${NEXUS_REGISTRY}/${app}:${env.BUILD_NUMBER}"
                            sh "docker build -t ${imageTag} ./${app}"
                            sh "docker push ${imageTag}"
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
            sh "docker logout ${NEXUS_REGISTRY} || true"
        }
    }
}