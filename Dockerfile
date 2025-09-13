# Build stage with Maven + JDK
FROM maven:3.9.4-eclipse-temurin-23-jdk AS build
WORKDIR /app
COPY . .

# Build the project
RUN mvn clean package -Dmaven.test.skip=true

# Run stage with JDK only
FROM eclipse-temurin:23-jdk
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
