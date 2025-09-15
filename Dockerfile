###############################################################################
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

# https://github.com/apache/kafka/blob/trunk/docker/docker_official_images/3.7.0/jvm/Dockerfile
FROM apache/kafka:3.7.0 AS parent

FROM eclipse-temurin:21-jre-noble

# exposed ports
EXPOSE 9092

USER root

ENV build_date 2025-9-15

LABEL org.label-schema.name="kafka" \
      org.label-schema.description="Apache Kafka" \
      org.label-schema.build-date="${build_date}" \
      org.label-schema.vcs-url="https://github.com/apache/kafka" \
      maintainer="Apache Kafka"

COPY --from=parent /opt/kafka /opt/kafka
COPY --from=parent /etc/kafka /etc/kafka

RUN set -eux ; \
    mkdir -p /var/lib/kafka/data; \
    mkdir -p /usr/logs /mnt/shared/config; \
    useradd -m -d /home/appuser -s /bin/bash appuser; \
    chown appuser:appuser -R /usr/logs /opt/kafka /mnt/shared/config; \
    chown appuser:root -R /var/lib/kafka /etc/kafka/secrets /etc/kafka; \
    chmod -R ug+w /etc/kafka /var/lib/kafka /etc/kafka/secrets;

USER appuser

VOLUME ["/etc/kafka/secrets", "/var/lib/kafka/data", "/mnt/shared/config"]

CMD ["/etc/kafka/docker/run"]