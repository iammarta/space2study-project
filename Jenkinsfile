pipeline {
    agent any
    tools {
        nodejs 'node18'
        dockerTool 'docker'
        'hudson.plugins.sonar.SonarRunnerInstallation' 'SonarScanner'
    }
    stages {
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('2. Backend: CCI (SonarScan)') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    dir('backend') {
                        sh 'npm install --legacy-peer-deps --ignore-scripts'
                        withSonarQubeEnv('MySonarServer') {
                            sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=SpaceToStudy-Backend"
                        }
                    }
                }
            }
        }

        stage('3. Frontend: CCI (SonarScan)') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    dir('frontend') {
                        sh 'npm install --legacy-peer-deps --ignore-scripts'
                        withSonarQubeEnv('MySonarServer') {
                            sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=SpaceToStudy-Frontend"
                        }
                    }
                }
            }
        }

        stage('4. Build & Push to Nexus') {
            steps {
                withEnv(['DOCKER_API_VERSION=1.44']) {
                    sh "docker build -t localhost:8082/backend:${env.BUILD_NUMBER} ./backend"
                    sh "docker build -t localhost:8082/frontend:${env.BUILD_NUMBER} ./frontend"
                    
                    sh "docker push localhost:8082/backend:${env.BUILD_NUMBER}"
                    sh "docker push localhost:8082/frontend:${env.BUILD_NUMBER}"
                }
            }
        }
    }
}