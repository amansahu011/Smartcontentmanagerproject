# Stage 1: Build with Maven + JDK
FROM maven:3.9.3-eclipse-temurin-17 AS build
WORKDIR /app

# Copy only pom.xml first (dependency caching)
COPY pom.xml ./

# Download dependencies first (speeds up Docker build)
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build JAR without running tests
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jdk
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
