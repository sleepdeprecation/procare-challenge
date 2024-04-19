# vi: ft=hcl

job "pc-demo" {
  type = "service"

  group "pc-demo" {
    count = 1

    service {
      provider = "nomad"
      name = "pc-demo"
      port = "http"
    }

    network {
      port "http" {
        # using `static` here instead of `to` as you normally would, because
        # i'm not setting up a load balancer or other front door service.
        static = 3000
      }
    }

    task "app" {
      driver = "docker"

      config {
        image = "ghcr.io/sleepdeprecation/procare-challenge:latest"
        ports = ["http"]
      }

      env {
        RAILS_ENV = "production"
      }

      template {
        data = <<EOF
{{ range nomadService "kafka" }}
KAFKA_URL="{{ .Address }}:{{ .Port }}"
{{ end }}
{{ range nomadService "postgres" }}
DATABASE_URL="postgresql://pguser:pgpasswd@{{ .Address }}:{{ .Port }}"
{{ end }}
EOF
        env = true
        destination = "local/env.txt"
      }
    }

    task "app-consumer" {
      driver = "docker"

      config {
        image = "ghcr.io/sleepdeprecation/procare-challenge:latest"
        command = "/bin/bash"
        args = ["-c", "bundle exec karafka server"]
      }

      lifecycle {
        hook    = "poststart"
        sidecar = true
      }

      env {
        RAILS_ENV = "production"
      }


      template {
        data = <<EOF
{{ range nomadService "kafka" }}
KAFKA_URL="{{ .Address }}:{{ .Port }}"
{{ end }}
{{ range nomadService "postgres" }}
DATABASE_URL="postgresql://pguser:pgpasswd@{{ .Address }}:{{ .Port }}"
{{ end }}
EOF
        env = true
        destination = "local/env.txt"
      }
    }

    task "app-migrator" {
      driver = "docker"

      config {
        image = "ghcr.io/sleepdeprecation/procare-challenge:latest"
        command = "bin/docker-bootstrap"
      }

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      env {
        RAILS_ENV = "production"
      }


      template {
        data = <<EOF
{{ range nomadService "kafka" }}
KAFKA_URL="{{ .Address }}:{{ .Port }}"
{{ end }}
{{ range nomadService "postgres" }}
DATABASE_URL="postgresql://pguser:pgpasswd@{{ .Address }}:{{ .Port }}"
{{ end }}
EOF
        env = true
        destination = "local/env.txt"
      }
    }
  }
}
