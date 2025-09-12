# Step 1: Build stage
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

# Copy everything
COPY . .

# Give mvnw execute permission
RUN chmod +x mvnw

# Package app using wrapper
RUN ./mvnw clean package -Dmaven.test.skip=true

# Step 2: Run stage
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
