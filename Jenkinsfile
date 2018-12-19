pipeline {
	agent any
	stages {
		stage('Build') {
			agent {
				docker {
					image 'maven:3-alpine'
					args '-v /root/.m2:/root/.m2'
				}
			}
			steps {
				sh 'mvn -B -DskipTests clean install'
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
				sh 'java -jar /root/.m2/repository/com/mycompany/app/my-app/1.0-SNAPSHOT/my-app-1.0-SNAPSHOT.jar'
			}
		}
		stage('Start proxies') {
			failFast true
			parallel {
				stage('Nginx') {
					steps {
						sh 'docker container stop nginx'
						sh 'docker container run -d --rm --name nginx --publish 8081:80 nginx'
					}
				}
				stage('HTTPD') {
					steps {
						sh 'docker container stop httpd'
						sh 'docker container run -d --rm --name httpd --publish 8082:80 httpd'
					}
				}
			}
		}
	}
}
