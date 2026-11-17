FROM eclipse-temurin:21-jdk AS build
WORKDIR /src
COPY . .
RUN chmod +x mvnw \
 && mkdir -p calculadora/db \
 && ./mvnw -B flyway:migrate -Dflyway.configFiles=./flyway/flyway-pro.conf --errors \
 && ./mvnw -B -DskipTests package

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /src/target/api-regime-geral.jar app.jar
COPY --from=build /src/calculadora/db ./calculadora/db
ENV SERVER_PORT=8080
EXPOSE 8080
ENTRYPOINT ["java", "-Dspring.profiles.active=offline", "-jar", "app.jar"]
