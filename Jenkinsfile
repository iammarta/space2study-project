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
                sh 'ls -la' 
            }
        }

        stage('2. Backend: Test & Scan') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    dir('backend') {
                        sh 'npm install --legacy-peer-deps --ignore-scripts'
                        sh 'npx jest src/test/unit --coverage || true'
                        withSonarQubeEnv('MySonarServer') {
                            sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=SpaceToStudy-Backend || true"
                        }
                    }
                }
            }
        }

        stage('3. Frontend: Test & Scan') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    dir('frontend') {
                        sh 'npm install --legacy-peer-deps --ignore-scripts'
                        sh 'npm test -- --run --coverage || true'
                        withSonarQubeEnv('MySonarServer') {
                            sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=SpaceToStudy-Frontend || true"
                        }
                    }
                }
            }
        }

        stage('4. Build, Tag & Push Artifacts') {
            steps {
                withEnv(['DOCKER_API_VERSION=1.44']) {
                    sh "docker build -t localhost:8082/backend:${env.BUILD_NUMBER} ./backend"
                    sh "docker build -t localhost:8082/backend:latest ./backend"
                    sh "docker build -t localhost:8082/frontend:${env.BUILD_NUMBER} ./frontend"
                    sh "docker build -t localhost:8082/frontend:latest ./frontend"
                    
                    sh "docker push localhost:8082/backend:${env.BUILD_NUMBER}"
                    sh "docker push localhost:8082/backend:latest"
                    sh "docker push localhost:8082/frontend:${env.BUILD_NUMBER}"
                    sh "docker push localhost:8082/frontend:latest"
                }
            }
        }
    }
}