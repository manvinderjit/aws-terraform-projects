ARG BASE_IMAGE
FROM ${BASE_IMAGE}

WORKDIR /app

COPY combined/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]