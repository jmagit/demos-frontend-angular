pipeline {
    agent {
        docker { image 'jamarton/angular-cicd' }
    }
    environment {
      REGISTRY = 'jamarton/demo-frontend-angular'
    }
    stages {
        // stage('Checkout') {
        //     steps {
        //         // Get Github repo using Github credentials (previously added to Jenkins credentials)
        //         git url: 'https://github.com/jmagit/MOCKWebServer'
        //     }
        // }
        stage('Install dependencies') {
            steps {
                sh 'npm --version'
                sh "npm install"
            }
            post {
              always {
                  junit 'coverage/frontend/**/*.xml'
              }
            }
        }
        stage('Unit tests') {
            steps {
                // echo 'Run unit tests'
                sh "npm run ci-test"
            }
        }
        stage("SonarQube Analysis") {
            environment {
                // Previously defined in the Jenkins "Global Tool Configuration"
                scannerHome = tool 'SonarQube Scanner'
            }
            steps {
                withSonarQubeEnv('SonarQubeDockerServer') {
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=demo-angular \
                    	-Dsonar.sources=./src \
                      -Dsonar.sourceEncoding=UTF-8
                    	-Dsonar.tests=./spec \
                      -Dsonar.test.inclusions=**/*.spec.ts \
                    	-Dsonar.javascript.lcov.reportPaths=./coverage/frontend/lcov.info \
                      -Dsonar.exclusions=**/node_modules/**"
                }
                timeout(2) { // time: 5 unit: 'MINUTES'
                    // In case of SonarQube failure or direct timeout exceed, stop Pipeline
                    // waitForQualityGate abortPipeline: waitForQualityGate().status != 'OK'
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}
