pipeline {
  agent {
    docker {
      image 'maven:3-alpine'
      args '-v /root/.m2:/root/.m2'
    }

  }
  stages {
    stage('Build') {
      steps {
        sh 'mvn -B -DskipTests clean package'
      }
    }
    stage('Test') {
      post {
        always {
          junit 'target/surefire-reports/*.xml'

        }

      }
      steps {
        sh 'mvn test'
      }
    }
    stage('Deliver') {
      steps {
        sh './jenkins/scripts/deliver.sh'
      }
    }
    stage('Parallel In Sequential') {
      parallel {
        stage('Start Nginx') {
          agent {
            docker { image 'alpine' }
          }
          steps {
            sh 'docker container run -d --rm --name nginx --publish 8081:80 nginx'
          }
        }
        stage('Start HTTPD') {
          agent {
            docker { image 'alpine' }
          }
          steps {
            sh 'docker container run -d --rm --name httpd --publish 8082:80 httpd'
          }
        }
      }
    }
  }
}
