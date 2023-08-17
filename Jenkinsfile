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
    
    // environment{
    //     DOCKERHUB_CREDENTIALS=credentials('docker-hub-neysho')
    //     DB_HOST = '10.97.244.243'
    //     DB_USERNAME = 'root'
    //     DB_PASSWORD = 'root'
    //     DB_NAME = 'bsisa'
    // }
    environment{
     DB_HOST = ${{ vars.DB_HOST }}
    }
       stages{
             stage('checkout'){
                        steps{
                        //  deleteDir()
                         checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-neysho', url: 'https://github.com/Neysho/Spring-boot-deployment.git']])
                         // sh 'echo ${{ secrets.DB_USERNAME }}'
                        }
                  }
           stage('Test db_host var'){
                 steps{
                     sh 'echo "$DB_HOST"'
                 }
             }
         //           stage('Build Maven'){
         //              tools{
         //               maven 'maven-3.9.3'
         //              }
         //         steps{
         //             sh 'mvn clean install'
         //         }
         //     }
         //    stage("Sonarqube Analysis") {
         //        tools{
         //            maven 'maven-3.9.3'
         //            }
         //     steps {
         //         script {
         //             withSonarQubeEnv(credentialsId: 'sonar-id') {
         //                 sh "mvn sonar:sonar"
         //             }
         //         }
         //     }

         // }
         //     stage('docker build'){
         //         steps{
         //             container('docker') {
         //                 sh ''' ls
         //                        docker build -t neysho/emp-backend:1 .
         //                        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
         //                        docker push neysho/emp-backend:1
         //                 '''
         //        }
         //       }
         //     }
           
         //     stage('indentifying misconfigs using datree in helm charts'){
         //         agent any
         //     steps{
         //      catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
         //            // Steps that might fail but should be ignored
         //            script{
         //                  withEnv(['DATREE_TOKEN=624f205a-f8f9-4d84-a34b-7b1fe5f3fb50']) {
         //                       sh 'helm datree test kubernetes/chart/'
         //                }
         //         }
         //        }
                 
         //     }
         // }
            
         //     stage('Deploying to kubernetes') {
         //         steps {
         //             container('kubectl') {
         //              withKubeConfig([credentialsId: 'kube-config', serverUrl: 'https://192.168.1.130:6443']) {
         //              // sh 'kubectl get pods'
         //              sh 'kubectl delete pods -n emp -l app=springboot-k8s-mysql'
         //           }
         //           }
         //         }
         //     }
      
    }
    post {
        // Clean after build
        always {
            cleanWs()
            }
          }
  }
