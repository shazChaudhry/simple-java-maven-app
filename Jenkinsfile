pipeline {
  agent none
  stages {
    stage('Start proxies') {
	  failFast true
      parallel {
        stage('Nginx') {
          agent any
          steps {
            sh 'docker container run -d --rm --name nginx --publish 8081:80 nginx'
          }
        }
        stage('HTTPD') {
          agent any
          steps {
            sh 'docker container run -d --rm --name httpd --publish 8082:80 httpd'
          }
        }
      }
    }
    stage('Build') {
	  agent {
      docker {
        image 'maven:3-alpine'
        args '-v /root/.m2:/root/.m2'
      }
	  }
      steps {
        sh 'mvn -B -DskipTests clean package'
      }
    }
    stage('Test') {
	  agent {
      docker {
        image 'maven:3-alpine'
        args '-v /root/.m2:/root/.m2'
      }
	  }
      steps {
        sh 'mvn test'
      }
      post {
        always {
          junit 'target/surefire-reports/*.xml'
        }
      }
    }
    stage('Deliver') {
	  agent {
      docker {
        image 'maven:3-alpine'
        args '-v /root/.m2:/root/.m2'
      }
	  }
      steps {
        sh './jenkins/scripts/deliver.sh'
      }
    }
  }
}
