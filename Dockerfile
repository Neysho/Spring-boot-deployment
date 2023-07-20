FROM openjdk:8
EXPOSE 8080
ADD target/springboot-employee-k8s.jar springboot-employee-k8s.jar
ENTRYPOINT ["java","-jar","/springboot-employee-k8s.jar"]