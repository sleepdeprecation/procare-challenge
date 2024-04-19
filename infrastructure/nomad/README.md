# Nomad Configuration

All the resources required to get this infrastructure running using the Nomad container orchestration system.

## Bootstrapping

To be able to use this, you need to have a nomad cluster running somewhere.
If you don't already have something setup, you can use the VM infrastructure in [`../vm`](../vm).

## Contents

There are two Nomad job definitions in this directory: `datastorage.nomad`, used to run Kafka and Postgres; and `service.nomad`, used to run this rails app.

Make sure to have the `datastorage.nomad` spec running before trying to run `service.nomad`, because it depends on it.

### Rails Service (`service.nomad`)

There are three task definitions in the service's job:

-   `app`, the main app, it's web ui
-   `app-consumer`, a sidecar, karafka server
-   `app-migrator`, a "pre-start" task, which runs database and kafka migrations before the app and app-consumer tasks are started.

The use of the pre-start app-migrator task allows Nomad to control deployments, any time a new version is pushed to the cluster, Nomad will first attempt to run the migrations, and if those fail, the deployment will fail.
