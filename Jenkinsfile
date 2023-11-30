pipeline {
    agent {
    kubernetes {
      yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kubectl
    image: gcr.io/cloud-builders/kubectl
    imagePullPolicy: IfNotPresent
    command: ["cat"]
    tty: true
    resources:
      requests:
        cpu: "0.3"
        memory: "1000Mi"
      limits:
        cpu: "1"
        memory: "2000Mi"   
  - name: docker
    image: docker:latest
    imagePullPolicy: IfNotPresent
    command:
    - cat
    tty: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-sock
  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock     
      '''
      }
    }
    
    environment{
        DOCKERHUB_CREDENTIALS=credentials('docker-hub-neysho')
        DB_USERNAME = credentials('mysql_user')
        DB_PASSWORD = credentials('mysql_password')
    }
       stages{
             stage('checkout'){
                        steps{
                        //  deleteDir()
                         checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-neysho', url: 'https://github.com/Neysho/Spring-boot-deployment.git']])
                       }
                  }
           
                   stage('Build Maven'){
                      tools{
                       maven 'maven-3.9.3'
                      }
                 steps{
                     sh 'mvn clean install'
                 }
             }
            stage("Sonarqube Analysis") {
                tools{
                    maven 'maven-3.9.3'
                    }
             steps {
                 script {
                     withSonarQubeEnv(credentialsId: 'sonar-id') {
                         sh "mvn sonar:sonar"
                     }
                 }
             }

         }
             stage('docker build'){
                 steps{
                     container('docker') {
                         sh ''' ls
                                docker build -t neysho/emp-backend:1 .
                                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                                docker push neysho/emp-backend:1
                         '''
                }
               }
             }
           stage('Trivy Scan'){
                steps{
                    sh 'trivy image --scanners vuln neysho/achat-backend:1  --timeout 35m > backend-scan.txt'
                }
                post { 
                    success {
                     slackUploadFile filePath: 'backend-scan.txt', initialComment: 'Trivy Scan :'
                     } 
                    failure {
                            slackSend color: "danger", 
                             message: "Pipeline failed in stage 'Trivy Scan'",
                             tokenCredentialId: 'slack-alert-bot'
                     }
                }
            }
           
             stage('indentifying misconfigs using datree in helm charts'){
                 agent any
             steps{
              catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
                    // Steps that might fail but should be ignored
                    script{
                         // sh 'kubescape scan kubernetes/manifests --submit --account 54b216e2-2064-4fc5-93f7-44a22004f25e'
                          withEnv(['DATREE_TOKEN=624f205a-f8f9-4d84-a34b-7b1fe5f3fb50']) {
                               sh 'helm datree test kubernetes/chart/'
                        }
                 }
                }
                 
             }
         }
            
             stage('Deploying to kubernetes') {
                 steps {
                     container('kubectl') {
                      withKubeConfig([credentialsId: 'kube-config', serverUrl: 'https://192.168.1.130:6443']) {
                      // sh 'kubectl get pods'
                      sh 'kubectl delete pods -n emp -l app=emp-backend'
                   }
                   }
                 }
             }
      
    }
   post {
            always {
                script {
                    emailext attachLog: true, body: 'Here is your Log file.',
                    subject: 'Jenkins Notification', attachmentsPattern: 'backend-scan.txt',
                    to: 'azizamari100@gmail.com'
                    cleanWs()
                }
              }
               success {
                    slackSend color: "good",  message: 'Pipeline completed successfully!',
                     tokenCredentialId: 'slack-alert-bot'
              }  
               failure {
                    slackSend color: "warning",
                     message: 'Check logs.',
                     tokenCredentialId: 'slack-alert-bot'
             }
         }
  }
