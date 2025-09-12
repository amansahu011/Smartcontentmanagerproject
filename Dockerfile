# Step 1: Build stage
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app

# Copy everything
COPY . .

# Package the application using system Maven (skip tests)
RUN mvn clean package -Dmaven.test.skip=true

# Step 2: Run stage
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java","-jar","app.jar"]
