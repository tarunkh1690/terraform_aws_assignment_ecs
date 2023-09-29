FROM openjdk:17-oracle

WORKDIR /app

COPY app/target/tdd-supermarket-1.0.0-SNAPSHOT.jar build/

WORKDIR /app/build

EXPOSE 8080

RUN useradd -u 8877 john

USER john

ENTRYPOINT ["java","-jar","tdd-supermarket-1.0.0-SNAPSHOT.jar"]