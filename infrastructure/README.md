# Reproducible Infrastructure

For this exercise I produced the following:

-   [`cloud-init`](./cloud-init), the cloud-init user-data as well as the ability to turn that into an iso disk that cloud init can understand as part of the NoCloud provisioner type (used in the VM)
-   [`vm`](./vm), tooling for producing a local virtual machine that uses the cloud-init data to run a single-node Nomad cluster
-   [`nomad`](./nomad), Nomad job specs for running Kafka, Postgres, and this application


## How to use this

If you're going to use this, you need to do the following:

1.  Update [cloud-init/user-data](./cloud-init/user-data) to include your SSH public key (_if_ you want to be able to SSH to the virtual machine for debugging; this is technically unnecessary, because the user data should allow for an entirely hands-off provisioning, you should be able to just launch the VM and use it without having to SSH to it).

1.  Launch the virtual machine!

    1.  Make sure to `cd` into the `vm` directory, the [`vm/bin/run-vm`](./vm/bin/run-vm) script assumes that's where it's being run from

    1.  Run `bin/run-vm`. This will bring up a virtual machine with several ports forwarded for you, see the [vm/README.md](./vm/README.md) file for more information.

1.  Run the services in nomad on the VM

    1.  If you haven't already, [install Nomad](https://developer.hashicorp.com/nomad/install?product_intent=nomad) on your machine so that you can interact with the cluster.
        If you would rather not, you can launch the jobs in the Nomad UI (accessible at http://localhost:4646 once the VM has been started).

    1.  Tell the Nomad client how to communicate with the cluster, and run

        ``` bash
        export NOMAD_ADDR=http://localhost:4646
        ```

    1.  Confirm the Nomad cluster is up and ready with

        ``` bash
        nomad status
        ```

        You may need to wait a minute or two for the VM to finish provisioning

    1.  Launch the data services (Kafka and Postgres)

        ``` bash
        nomad run infrastructure/nomad/datastorage.nomad
        ```

    1.  Launch the Rails service

        ``` bash
        nomad run infrastructure/nomad/service.nomad
        ```

1.  Check http://localhost:3000 for the rails service. This may take another minute after Nomad reports the job as complete to be ready.

    -   I unfortunately experienced intermittent issues with the first run of the service, and it's unclear to me why that happened. If this occurs, stop and purge the job and try running it again.

        ``` bash
        nomad job stop -purge pc-demo
        nomad run infrastructure/nomad/service.nomad
        ```


## What's Missing

This is not the best, most resilient setup, but it is enough that someone could get started and spin up everything needed to run this somewhere with minimal hassle. As such, there are several missing pieces.

-   Persistent storage for Kafka and Postgres.

    I did go down a tangent trying to get the `hostpath` storage plugin working with Nomad to enable the Kafka and Postgres containers to keep their data stored outside of the running container. Unfortunately the hostpath plugin is not the best, and I ended up getting errors trying to get it working. Instead of continuing to try figuring it out, I determined I spent too much time working on it already, and it was ultimately a distraction for the real end goal.

    In the real world, you probably wouldn't want to run Postgres or Kafka on the container orchestration system, because it's not the right tool for the job, and if you did, the orchestrator should have a real storage option available.

-   Automated builds and deploys of the app.

    In all honesty this was my original goal, to just build the automated CI/CD pipelines, and as part of the CD aspect have the pipeline automatically deploy the new version of the app to the cluster. After having spent the time I did just building the cluster, I honestly don't have the energy to build the pipelines for a technical challenge just given the amount of work I put into this aspect.

-   A load balancer or other ingress system for the app.

    This is an exercise left to the reader. A production system should have an already blessed load balancing/ingress system, that's not a wheel I need to reinvent right now. If pushed, I would most likely add a Traefik service to the Nomad cluster, because it has plugins which integrate nicely with Nomad and Lets Encrypt for free and easy SSL certs.
