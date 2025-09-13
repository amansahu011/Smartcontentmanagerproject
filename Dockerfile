# ------------------------------
# 1. Build stage (Maven + JDK)
# ------------------------------
FROM maven:3.9.9-eclipse-temurin-23 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies (cache layer)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the full source code
COPY . .

# Build the Spring Boot JAR (skip tests)
RUN mvn clean package -DskipTests

# ------------------------------
# 2. Runtime stage (JDK only)
# ------------------------------
FROM openjdk:23-jdk-slim

# Set working directory
WORKDIR /app

# Copy JAR from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose Spring Boot default port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
