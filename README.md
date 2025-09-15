
Kafka Container for Ubuntu.

The source code on <https://github.com/wendaoji/kafka-container>.

The original Dockfile can be found on the official website <https://github.com/apache/kafka/blob/trunk/docker/docker_official_images/3.7.0/jvm/Dockerfile>.


# docker compose

connect-standalone.properties
```properties
bootstrap.servers=kafka:9092
key.converter=org.apache.kafka.connect.json.JsonConverter
value.converter=org.apache.kafka.connect.json.JsonConverter
key.converter.schemas.enable=true
value.converter.schemas.enable=true
offset.storage.file.filename=/opt/kafka/connectors/connect.offsets
offset.flush.interval.ms=10000
plugin.path=/opt/kafka/connectors
```

docker-compose.yml

```yml
services:
  kafka:
    image: wendaoji/kafka:3.7.0
    container_name: kafka
    hostname: kafka
    restart: unless-stopped
    environment:
      KAFKA_NODE_ID: 1
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: 'CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT'
      KAFKA_ADVERTISED_LISTENERS: 'PLAINTEXT_HOST://kafka:9092,PLAINTEXT://kafka:19092'
      KAFKA_PROCESS_ROLES: 'broker,controller'
      KAFKA_CONTROLLER_QUORUM_VOTERS: '1@kafka:29093'
      KAFKA_LISTENERS: 'CONTROLLER://:29093,PLAINTEXT_HOST://:9092,PLAINTEXT://:19092'
      KAFKA_INTER_BROKER_LISTENER_NAME: 'PLAINTEXT'
      KAFKA_CONTROLLER_LISTENER_NAMES: 'CONTROLLER'
      CLUSTER_ID: '4L6g3nShT-eMCtK--X86sw'
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1
      KAFKA_SHARE_COORDINATOR_STATE_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_SHARE_COORDINATOR_STATE_TOPIC_MIN_ISR: 1
      KAFKA_NUM_PARTITIONS: 3
      KAFKA_LOG_DIRS: '/opt/kafka/logs'
    ports:
      - "9092:9092"
    volumes:
      - ./data:/var/lib/kafka/data
      - ./logs:/opt/kafka/logs
    networks:
      - kafka
  kafka-connect:
    image: wendaoji/kafka:3.7.0
    container_name: kafka-connect
    hostname: kafka-connect
    restart: unless-stopped
    ports:
      - "8083:8083"
    volumes:
      - ./connectors:/opt/kafka/connectors
      - ./connect-standalone.properties:/opt/kafka/config/connect-standalone.properties
    command: /opt/kafka/bin/connect-standalone.sh /opt/kafka/config/connect-standalone.properties
    depends_on:
      - kafka
    networks:
      - kafka
networks:
  kafka:
```