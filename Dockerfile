FROM maven:3.6.3-jdk-11-slim AS build
WORKDIR /app

#Copying pomxml and code
COPY pom.xml /app/
COPY src/main /app/src/main/

#building the application
RUN mvn clean package -DskipTests

FROM openjdk:11-jre-slim
WORKDIR /app

#copying the built application
COPY --from=build /app/target/s3rekognition-0.0.1-SNAPSHOT.jar /app/

#expose a port to run on
EXPOSE 8080

#enviroment variable
ENV AWS_ACCESS_KEY_ID=XXX
ENV AWS_SECRET_ACCESS_KEY=YYY
ENV BUCKET_NAME=kjellsimagebucket

#running the application
ENTRYPOINT ["java", "-jar", "s3rekognition-0.0.1-SNAPSHOT.jar"]