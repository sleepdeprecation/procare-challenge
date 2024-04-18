# Process Log

This is just a quick log of my process for getting this project working and selecting an adventure.

As an early note, I did consider doing this just in git, but my process is frequently do all the work and then chunk it into comprehensible commits, and I'd rather keep even just a quick and dirty text log of what I'm doing while I do it.

## Initial Setup

Before anything, I know that if I want to run this, I need to containerize this app.
My fast, plain and simple idea for running a deployment of this is to just use docker compose, so that getting the app running in a publicly accessible way is repeatable.
I have some other thoughts around the deployment infrastructure (and I think I'm going to pick the delivery adventure for this challenge), specifically if I need to have this publicly accessible, configuring it to run on Nomad may be the cheapest way for me to do it.
I run a nomad "cluster" (single node), from my home, which runs some services that are accessible from the public internet, this unfortunately may not make the infrastructure builds the most repeatable.
Depending on how far I get in a couple hours of work I may try setting something up with the AWS or Oracle Cloud free tier.

So: Containerization.
Theoretically I should be able to just pull a rails container down and tell it to run `bin/bootstrap`.
Let's find out.

So `bin/bootstrap` runs the db migrations and other seeding tasks, which we don't want as part of the container build stage.
Instead of just running it, I'm going to have the container just do the dependency install.

diffend configuration is missing key/value is invalid.

> OSS supply chain security and management platform

diffend.io no longer seems to be fully working, and it seems like i would need to register to diffend to actually use it, which i don't love :/

yeah, in reading the mend.io (which diffend.io redirects to) docs, i definitely would need to signup. seeing as the yarn.lock doesn't have diffend in it, this seems like it comes from karafka, and my inclination is to just disable it (and maybe come back later and figure out if i should enable it).

bigdecimal didn't want to install, needed to install build-essential, not sure if this is because rubygems doesn't distribute an aarch64 precompiled bigdecimal, or if this would happen on x64 too, will investigate later.

libpq-dev also required to build pg gem

lack of assets directory and pipeline means we can probably skip the yarn install step

added app (and container build) to compose file, also added postgres and a karafka consumer container (reuses the app container)

added bin/docker-bootstrap for quickly bootstraping the composed setup (run docker compose up first, and then the bin/docker-bootstrap script)

fully able to run and create new environment, calling that a good stopping point for tonight.
