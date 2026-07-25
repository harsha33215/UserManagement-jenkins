# ---------- Stage 1 : Build ----------
FROM maven:3.9.11-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml first to cache dependencies
COPY pom.xml .

RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# ---------- Stage 2 : Runtime ----------
FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 1234

ENTRYPOINT ["java","-jar","app.jar"]