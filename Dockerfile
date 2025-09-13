# Step 1: Base image with JDK 23
FROM eclipse-temurin:23-jdk-jammy

# Step 2: Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    apt-get clean

# Step 3: Set working directory
WORKDIR /app

# Step 4: Copy pom.xml and download dependencies first (for caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Step 5: Copy the rest of the project
COPY . .

# Step 6: Build the Spring Boot application (skip tests for faster build)
RUN mvn clean package -DskipTests

# Step 7: Expose port (default Spring Boot port)
EXPOSE 8080

# Step 8: Run the jar
CMD ["java", "-jar", "target/your-project-name.jar"]
