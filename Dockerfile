# Stage 1: Maven 빌드 (프론트엔드 + 백엔드 통합)
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

# pom.xml 먼저 복사해 의존성 레이어 캐싱
COPY pom.xml .
RUN mvn dependency:go-offline -q || true

# 소스 복사 (node_modules, target은 .dockerignore로 제외)
COPY src ./src

# frontend-maven-plugin: Node 다운로드 → npm install → npm run build (src/main/view)
# maven-antrun-plugin: src/main/view/build → target/classes/public 복사
RUN mvn clean package -DskipTests -q

# Stage 2: 경량 JRE로 실행 (Spring Boot 실행 가능 WAR)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/demo-0.0.1-SNAPSHOT.war app.war
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]
