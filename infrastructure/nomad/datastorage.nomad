# vi: ft=hcl

job "storage" {
  type = "service"

  group "kafka" {
    service {
      provider = "nomad"
      name     = "kafka"
      port     = "kafka"
    }

    network {
      port "kafka" { }
    }

    task "kafka" {
      driver = "docker"

      config {
        image = "confluentinc/cp-kafka:7.5.1"
        ports = ["kafka"]
      }

      env {
        CLUSTER_ID = "kafka-docker-cluster-1"
        KAFKA_PROCESS_ROLES = "broker,controller"
        KAFKA_NODE_ID = "1"
        KAFKA_ADVERTISED_LISTENERS = "PLAINTEXT://${NOMAD_HOST_ADDR_kafka}"
        KAFKA_LISTENERS = "PLAINTEXT://:${NOMAD_PORT_kafka},CONTROLLER://:9093"

        KAFKA_LISTENER_SECURITY_PROTOCOL_MAP = "CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT"
        KAFKA_INTER_BROKER_LISTENER_NAME = "PLAINTEXT"
        KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR = "1"
        KAFKA_CONTROLLER_LISTENER_NAMES = "CONTROLLER"
        KAFKA_CONTROLLER_QUORUM_VOTERS = "1@127.0.0.1:9093"
        KAFKA_AUTO_CREATE_TOPICS_ENABLE = "true"

        ALLOW_PLAINTEXT_LISTENER = "yes"
      }

      resources {
        cpu = 500
        memory = 1024
      }
    }
  }

  group "postgres" {
    service {
      provider = "nomad"
      name     = "postgres"
      port     = "postgres"
    }

    network {
      port "postgres" {
        to = 5432
      }
    }

    task "postgres" {
      driver = "docker"

      config {
        image = "postgres:16"
        ports = ["postgres"]
      }

      env {
        # please don't run this in production, and please don't use this easily guessable username/password combination.
        POSTGRES_PASSWORD = "pgpasswd"
        POSTGRES_USER = "pguser"
        POSTGRES_DB = "procare_production"
      }
    }
  }
}
