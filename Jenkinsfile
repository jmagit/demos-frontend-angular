pipeline {
  agent none
  environment {
    REGISTRY = 'jamarton/demo-frontend-angular'
  }
  stages {
    stage('Unit tests') {
      agent {
          docker { image 'jamarton/angular-cicd' }
      }
      stages {
        stage('Install dependencies') {
            steps {
                sh "npm install"
            }
        }
        stage('Unit tests') {
            steps {
                // echo 'Run unit tests'
                sh "npm run ci-test"
            }
            post {
              always {
                  junit 'coverage/frontend/**/*.xml'
              }
            }
        }
      }
    }
    stage("SonarQube Analysis") {
        agent any
        environment {
            // Previously defined in the Jenkins "Global Tool Configuration"
            scannerHome = tool 'SonarQube Scanner'
        }
        steps {
            withSonarQubeEnv('SonarQubeDockerServer') {
                sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=demo-angular \
                  -Dsonar.sources=./src \
                  -Dsonar.sourceEncoding=UTF-8 \
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

