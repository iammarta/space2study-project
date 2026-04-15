pipeline {
    agent { label 'docker-agent' }

    environment {
        AWS_REGION = "${env.AWS_DEFAULT_REGION}"
        AWS_ACCOUNT_ID = "${env.AWS_ACCOUNT_ID}"
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        SONAR_SCANNER_OPTS = "-Xmx2048m -XX:ReservedCodeCacheSize=256m"
    }

    stages {
        stage('SCA Scan: Snyk') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                        sh 'snyk auth $SNYK_TOKEN'
                        
                        parallel(
                            "Backend Snyk": { dir('backend') { sh 'snyk test --severity-threshold=high || true' } },
                            "Frontend Snyk": { dir('frontend') { sh 'snyk test --severity-threshold=high || true' } }
                        )
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('MySonarServer') {
                        dir('backend') {
                            sh "${scannerHome}/bin/sonar-scanner \
                                -Dsonar.javascript.node.maxspace=768 \
                                -Dsonar.scanner.skipNodeProvisioning=true \
                                -Dsonar.testExecutionReportPaths="
                        }
                        dir('frontend') {
                            sh "${scannerHome}/bin/sonar-scanner \
                                -Dsonar.javascript.node.maxspace=768 \
                                -Dsonar.scanner.skipNodeProvisioning=true \
                                -Dsonar.testExecutionReportPaths="
                        }
                    }
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                    }
                }
            }
        }

        stage('Build & Scan & Push') {
            steps {
                script {
                    parallel(
                        "Backend Pipeline": {
                            def app = 'backend'
                            def tag = "${ECR_REGISTRY}/space2study-${app}:${env.BUILD_NUMBER}"
                            def latest = "${ECR_REGISTRY}/space2study-${app}:latest"

                            dir(app) {
                                sh "docker build -t ${tag} -t ${latest} ."
                                echo "Scanning Backend Image..."
                                sh "trivy image --no-progress --severity HIGH,CRITICAL --exit-code 0 --timeout 15m ${tag}"
                                echo "Pushing Backend Image..."
                                sh "docker push ${tag}"
                                sh "docker push ${latest}"
                            }
                        },
                        "Frontend Pipeline": {
                            def app = 'frontend'
                            def tag = "${ECR_REGISTRY}/space2study-${app}:${env.BUILD_NUMBER}"
                            def latest = "${ECR_REGISTRY}/space2study-${app}:latest"

                            dir(app) {
                                sh "docker build --build-arg VITE_API_BASE_PATH=/api -t ${tag} -t ${latest} ."
                                echo "Scanning Frontend Image..."
                                sh "trivy image --no-progress --severity HIGH,CRITICAL --exit-code 0 --timeout 15m ${tag}"
                                echo "Pushing Frontend Image..."
                                sh "docker push ${tag}"
                                sh "docker push ${latest}"
                            }
                        }
                    )
                }
            }
        }
    }

    post {
        always {
            sh "docker logout ${ECR_REGISTRY} || true"
            sh "docker image prune -f || true"
            sh "docker builder prune -af || true"
            cleanWs()
        }
    }
}