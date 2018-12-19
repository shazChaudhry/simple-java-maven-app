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
				sh 'mvn -B -DskipTests clean install'
			}
		}
		stage('Test') {
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
			steps {
				sh './jenkins/scripts/deliver.sh'
			}
		}
		stage('Start proxies') {
			failFast true
			parallel {
				agent none
				stage('Nginx') {
					agent any
					steps {
						sh 'docker container stop nginx'
						sh 'docker container run -d --rm --name nginx --publish 8081:80 nginx'
					}
				}
				stage('HTTPD') {
					agent any
					steps {
						sh 'docker container stop httpd'
						sh 'docker container run -d --rm --name httpd --publish 8082:80 httpd'
					}
				}
			}
		}
	}
}
