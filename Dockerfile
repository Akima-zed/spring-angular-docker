
# Étape 1 : Compiler le code Java
# Utilise JDK 21 pour compiler (image avec tous les outils de compilation)
FROM eclipse-temurin:21-jdk AS build

WORKDIR /app

# Copie les fichiers Gradle (outil qui gère les dépendances Java)
COPY gradlew .
COPY gradle ./gradle
COPY build.gradle .
COPY settings.gradle .

# Copie le code source
COPY src ./src

# Donne les droits d'exécution au script Gradle
RUN chmod +x gradlew

# Compile le projet → Crée un fichier .jar dans build/libs/
RUN ./gradlew build --no-daemon

# Étape 2 : Exécuter l'application Image finale
# Utilise JRE 21 Le .jar est déjà compilé → On a juste besoin de l'exécuter → JRE suffit)
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copie le .jar compilé depuis l'étape 1
COPY --from=build /app/build/libs/*.jar app.jar

# Port utilisé par Spring Boot
EXPOSE 8080

# Commande pour lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
