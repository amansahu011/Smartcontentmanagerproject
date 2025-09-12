# Step 1: Build stage (use Maven + JDK 17 to build the app)
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Package the application (skip tests for faster build)
RUN mvn clean package -DskipTests

# Step 2: Run stage (use smaller JDK image for runtime)
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copy jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port 8080
EXPOSE 8080

# Run the application
ENTRYPOINT ["java","-jar","app.jar"]
