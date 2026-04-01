pipeline {
    agent { label 'docker-agent' }

    environment {
        NEXUS_REGISTRY = "${env.NEXUS_REGISTRY}"
        SONAR_SCANNER_OPTS = "-Xmx2048m -XX:ReservedCodeCacheSize=256m"
    }

    stages {

        stage('SCA Scan: Snyk') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                        sh 'snyk auth ${SNYK_TOKEN}'

                        ['backend', 'frontend'].each { folder ->
                            dir(folder) {
                                echo "Running Snyk scan in ${folder}..."
                                sh 'snyk test --severity-threshold=high || true'
                            }
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
                        ['backend', 'frontend'].each { folder ->
                            dir(folder) {
                                sh "${scannerHome}/bin/sonar-scanner -Dsonar.testExecutionReportPaths= -Dsonar.javascript.node.maxspace=768"
                            }
                        }
                    }
                }
            }
        }

        stage('Build Images') {
            steps {
                script {
                    ['backend', 'frontend'].each { app ->
                        def tag = "${NEXUS_REGISTRY}/${app}:${env.BUILD_NUMBER}"
                        def latest = "${NEXUS_REGISTRY}/${app}:latest"

                        dir(app) {
                            sh "docker build -t ${tag} -t ${latest} ."
                        }
                    }
                }
            }
        }

        stage('Image Scan: Trivy') {
            steps {
                script {
                    ['backend', 'frontend'].each { app ->
                        def tag = "${NEXUS_REGISTRY}/${app}:${env.BUILD_NUMBER}"

                        echo "Scanning image ${tag}..."
                        sh "trivy image --no-progress --severity HIGH,CRITICAL --exit-code 0 ${tag}"
                    }
                }
            }
        }

        stage('Push Images') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'nexus-auth', usernameVariable: 'NEXUS_USR', passwordVariable: 'NEXUS_PWD')]) {
                        sh 'echo "${NEXUS_PWD}" | docker login ${NEXUS_REGISTRY} -u "${NEXUS_USR}" --password-stdin'

                        ['backend', 'frontend'].each { app ->
                            def tag = "${NEXUS_REGISTRY}/${app}:${env.BUILD_NUMBER}"
                            def latest = "${NEXUS_REGISTRY}/${app}:latest"

                            echo "Pushing ${app} images to Nexus..."
                            sh "docker push ${tag}"
                            sh "docker push ${latest}"
                        }
                    }
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                withCredentials([string(credentialsId: 'aws-runtime-ip', variable: 'AWS_IP')]) {
                    script {
                        ansiblePlaybook(
                            playbook: 'ansible/deploy.yml',
                            inventory: 'ansible/inventory.ini',
                            extraVars: [
                                remote_ip: "${AWS_IP}"
                            ],
                            credentialsId: 'aws-runtime-key'
                        )
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