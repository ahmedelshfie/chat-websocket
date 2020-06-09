pipeline {

   environment {
        IMAGE_NAME = "ahmedelshfie/chat-tomcat:${BUILD_NUMBER}"
		    scannerHome = tool 'SonarQubeScanner'
     } 

    agent any

    stages {
	
	    stage ('Build-App') {
            steps {
               
                    sh ' mvn clean install -DskipTests -Ddockerfile.skip'
            }
        }
		
	    stage('Sonarqube') {
 
           steps {
                 withSonarQubeEnv('sonarqube') {
                   sh "${scannerHome}/bin/sonar-scanner"
               }
            timeout(time: 10, unit: 'MINUTES') {
            waitForQualityGate abortPipeline: true
                 }
             }
          }	
		  
         stage('Approval-Build-Docker-Image') {
            // no agent, so executors are not used up when waiting for approvals
            agent none
            steps {
                script {
                    def deploymentDelay = input id: 'Deploy', message: 'Push-Image to DockerHub', submitter: 'admin', parameters: [choice(choices: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24'], description: 'Hours to delay deployment?', name: 'deploymentDelay')]
                    sleep time: deploymentDelay.toInteger(), unit: 'HOURS'
                }
            }
        }	

        stage ('Deploy-Nexys') {
            steps {
               
                    sh ' mvn deploy -DskipTests -Ddockerfile.skip -Dbuild.number=${BUILD_NUMBER} '
            }
        }			
		
		stage ('Docker-Build-Login-Push-Image') {
            steps {

                withCredentials([[$class          : 'UsernamePasswordMultiBinding',
                                  credentialsId   : 'dockerhub_id',
                                  usernameVariable: 'USERNAME',
                                  passwordVariable: 'PASSWORD']]) {
								  
					sh ' docker build . -t $IMAGE_NAME'			  
                    sh ' docker login -u $USERNAME -p $PASSWORD'
                    sh ' docker push $IMAGE_NAME '
                }
            }

        }  
		
		
		stage('Approval-Deploy-Tomcat') {
            // no agent, so executors are not used up when waiting for approvals
            agent none
            steps {
                script {
                    def deploymentDelay = input id: 'Deploy', message: 'Deploy to Tomcat?', submitter: 'admin', parameters: [choice(choices: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24'], description: 'Hours to delay deployment?', name: 'deploymentDelay')]
                    sleep time: deploymentDelay.toInteger(), unit: 'HOURS'
                }
            }
        }

        stage ('Deploy-tomcat') {
            steps {
			   sshagent(['tomcat-ssh']){
			
					sh ' scp -o StrictHostKeyChecking=no target/*.war ubuntu@3.132.212.161:/opt/tomcat/latest/webapps '
					}
            }
        }  		
		
	
         stage('Approval-k8s-Deploy') {
            agent none
            steps {
                script {
                    def deploymentDelay = input id: 'Deploy', message: 'Deploy to Kubernetes?', submitter: 'admin', parameters: [choice(choices: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24'], description: 'Hours to delay deployment?', name: 'deploymentDelay')]
                    sleep time: deploymentDelay.toInteger(), unit: 'HOURS'
                }
            }
        }

        stage ('Deploy-Kubernetes') {
            steps {
			
					sh ' kubectl set image deployment/kubernetes-spring-chat kubernetes-spring-chat=$IMAGE_NAME --namespace jenkins-polls'
            }
        }  

         stage ('Describe-Kubernetes-Deployment-Service') {
            steps {
               
					sh ' kubectl describe deployment --namespace jenkins-polls'
					sh ' kubectl describe service --namespace jenkins-polls'
            }
        } 		
	
	}

}
