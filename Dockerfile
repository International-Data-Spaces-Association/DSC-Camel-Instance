#
# Copyright 2021 Fraunhofer Institute for Software and Systems Engineering
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Dependencies
FROM maven:3-jdk-11 AS maven
WORKDIR /app
COPY pom.xml .
RUN mvn -e -B dependency:resolve

# Classes
COPY src/main/java ./src/main/java
COPY src/main/resources ./src/main/resources
RUN mvn -e -B clean package -DskipTests -Dmaven.javadoc.skip=true

FROM adoptopenjdk/openjdk11:alpine-jre
COPY --from=maven /app/target/*.jar /app/app.jar
WORKDIR /app
EXPOSE 9090
ENTRYPOINT ["java","-jar","app.jar"]
