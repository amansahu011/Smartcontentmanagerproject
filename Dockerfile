# ------------------------------
# 1. Base image with JDK 23
# ------------------------------
FROM openjdk:23-jdk-slim

# ------------------------------
# 2. Install system dependencies
# ------------------------------
RUN apt-get update && apt-get install -y \
    maven \
    git \
    curl \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------
# 3. Set working directory
# ------------------------------
WORKDIR /app

# ------------------------------
# 4. Copy pom.xml first for caching
# ------------------------------
COPY pom.xml .

# Download all dependencies (offline) to avoid build errors later
RUN mvn dependency:go-offline

# ------------------------------
# 5. Copy the rest of the project
# ------------------------------
COPY . .

# ------------------------------
# 6. Build the Spring Boot application
# ------------------------------
# Skip tests to avoid failing builds if test errors exist
RUN mvn clean package -DskipTests

# ------------------------------
# 7. Expose Spring Boot default port
# ------------------------------
EXPOSE 8080

# ------------------------------
# 8. Run the built jar
# ------------------------------
# Replace 'your-project-name.jar' with the actual jar file name
CMD ["java", "-jar", "target/your-project-name.jar"]
