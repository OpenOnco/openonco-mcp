# Build stage
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn package -DskipTests -B

# Debug: show what was built
RUN ls -la /app/target/

# Runtime stage  
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy the runner jar (Quarkus uber-jar)
COPY --from=build /app/target/*-runner.jar ./app.jar

EXPOSE 8080
ENV PORT=8080
CMD ["java", "-jar", "app.jar"]
