
# Stage 1: Build stage
FROM maven:3.9.9-eclipse-temurin-21-jammy AS build

# Set working directory
WORKDIR /app

#copy the source code
COPY . .

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Runtime stage
FROM tomcat:10-jdk21

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file from build stage to Tomcat webapps directory
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]