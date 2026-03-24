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
    }

    stages {
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('2. Code Inspection (CCI)') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    def components = ['backend', 'frontend']
                    
                    components.each { folder ->
                        dir(folder) {
                            echo "Scanning ${folder}..."
                            sh 'npm install --legacy-peer-deps --ignore-scripts'
                            
                            withSonarQubeEnv('MySonarServer') {
                                withEnv(["SONAR_SCANNER_OPTS=-Xmx1024m"]) {
                                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=SpaceToStudy-${folder.capitalize()} || true"
                                }
                            }
                        }
                    }
                }
            }
        }

        stage('3. Build & Push to Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-auth', passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USR')]) {
                    script {
                        sh "echo ${NEXUS_PWD} | docker login ${NEXUS_REGISTRY} -u ${NEXUS_USR} --password-stdin"
                        
                        def apps = ['backend', 'frontend']
                        apps.each { app ->
                            def imageTag = "${NEXUS_REGISTRY}/${app}:${env.BUILD_NUMBER}"
                            
                            echo "Building and pushing ${app}..."
                            sh "docker build -t ${imageTag} ./${app}"
                            sh "docker push ${imageTag}"
                        }
                        
                        sh "docker logout ${NEXUS_REGISTRY}"
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}