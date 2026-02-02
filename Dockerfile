# Étape 1 : build
FROM gradle:8-jdk21 AS build
WORKDIR /app
COPY . .
RUN gradle build --no-daemon -x test

# Étape 2 : exécution
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/build/libs/workshop-organizer-*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
