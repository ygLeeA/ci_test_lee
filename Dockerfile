# Stage 1: Build (Maven이 백엔드 + 프론트엔드 통합 빌드)
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

# pom.xml 먼저 복사해 의존성 레이어 캐싱
COPY pom.xml .
RUN mvn dependency:go-offline -q || true

# 소스 복사 (.dockerignore로 node_modules/target 제외)
COPY src ./src

# pom.xml은 src/main/frontend를 참조하지만 실제 React 앱은 src/main/view에 존재
# 심볼릭 링크로 경로 불일치 해결
RUN ln -s /app/src/main/view /app/src/main/frontend

RUN mvn clean package -DskipTests -q

# Stage 2: 경량 JRE로 실행 (Spring Boot 실행 가능 WAR)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/demo-0.0.1-SNAPSHOT.war app.war
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]
