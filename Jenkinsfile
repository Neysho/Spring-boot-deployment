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
    - mountPath: '/opt/springboot-app/shared'
      name: sharedvolume
  - name: maven
    image: maven:3.9.3
    tty: true
    command: ["mvn"]
    args: ["-v"]
    volumeMounts:
    - mountPath: '/opt/springboot-app/shared'
      name: sharedvolume
  volumes:
  - name: sharedvolume
    emptyDir: {}
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock      
      '''
      }
    }
    // tools {
    //     nodejs "node-14.21.3"
    // }
    environment{
        DOCKERHUB_CREDENTIALS=credentials('docker-hub-neysho')
    }

    stages{
      stage('checkout'){
        steps{
           checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-neysho', url: 'https://github.com/Neysho/Spring-boot-deployment.git']])
        }
      }
      stage('test text'){
                steps{
                    container('maven') {
                      sh 'touch /opt/springboot-app/shared/file.txt'
                      // sh  'mvn clean install'
                      sh 'ls'
                      sh 'pwd'
               }
              }
            }
            stage('Checkout'){
                steps{
                    container('docker') {
                      sh 'ls'
                      sh 'pwd'
                      sh 'ls /opt/springboot-app/shared'
                    // deleteDir()
                    //  checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-neysho', url: 'https://github.com/Neysho/Spring-boot-deployment.git']])
                    //    sh ''' ls
                    //           docker build -t neysho/emp-backend:1 .
                    //           echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                    //           docker push neysho/emp-backend:1
                    //    '''
               }
              }
            }

            
            // stage('Deploying Backend') {
            //     steps {
            //         container('kubectl') {
            //          withKubeConfig([credentialsId: 'kube-config', serverUrl: 'https://192.168.1.130:6443']) {
            //          sh 'kubectl delete pods -n emp -l app=springboot-dep'
            //       }
            //       }
            //     }
            // }
    }
  }
