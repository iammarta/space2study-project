pipeline {
    agent { label 'docker-agent' }

    environment {
        AWS_REGION = "eu-central-1"
        AWS_ACCOUNT_ID = "614441038759"
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        SONAR_SCANNER_OPTS = "-Xmx2048m -XX:ReservedCodeCacheSize=256m"
    }

    stages {

        stage('SCA Scan: Snyk') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                        sh "snyk auth ${SNYK_TOKEN}"

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
                                sh "${scannerHome}/bin/sonar-scanner -Dsonar.testExecutionReportPaths= -Dsonar.javascript.node.maxspace=768 -Dsonar.scanner.skipNodeProvisioning=true"
                            }
                        }
                    }
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds'
                    ]]) {
                        sh """
                            aws ecr get-login-password --region ${AWS_REGION} \
                            | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                        """
                    }
                }
            }
        }

        stage('Build Images') {
            steps {
                script {
                    ['backend', 'frontend'].each { app ->
                        def tag = "${ECR_REGISTRY}/space2study-${app}:${env.BUILD_NUMBER}"
                        def latest = "${ECR_REGISTRY}/space2study-${app}:latest"

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
                        def tag = "${ECR_REGISTRY}/space2study-${app}:${env.BUILD_NUMBER}"

                        echo "Scanning image ${tag}..."
                        sh "trivy image --no-progress --severity HIGH,CRITICAL --exit-code 0 --timeout 15m ${tag}"
                    }
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    ['backend', 'frontend'].each { app ->
                        def tag = "${ECR_REGISTRY}/space2study-${app}:${env.BUILD_NUMBER}"
                        def latest = "${ECR_REGISTRY}/space2study-${app}:latest"

                        sh """
                            docker push ${tag}
                            docker push ${latest}
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            sh "docker logout ${ECR_REGISTRY} || true"
            cleanWs()
        }
    }
}