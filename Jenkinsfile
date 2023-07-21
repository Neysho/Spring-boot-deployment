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
  - name: docker
    image: docker:latest
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
    tools{
        maven 'maven-3.9.3'
    }
    environment{
        DOCKERHUB_CREDENTIALS=credentials('docker-hub-neysho')
        DB_HOST = '10.96.161.243'
        DB_USERNAME = 'root'
        DB_PASSWORD = 'root'
        DB_NAME = 'bsisa'
    }
       stages{
             stage('checkout'){
                        steps{
                         deleteDir()
                         checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-neysho', url: 'https://github.com/Neysho/Spring-boot-deployment.git']])
                       }
                  }
                  stage('Build Maven'){
                steps{
                  withKubeConfig([credentialsId: 'kube-config', serverUrl: 'https://192.168.1.130:6443']) {
                    sh 'mvn clean install'
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

            
             stage('Deploying Backend') {
                 steps {
                     container('kubectl') {
                      withKubeConfig([credentialsId: 'kube-config', serverUrl: 'https://192.168.1.130:6443']) {
                      sh 'kubectl delete pods -n emp -l app=springboot-dep'
                   }
                   }
                 }
             }
    }
  }
