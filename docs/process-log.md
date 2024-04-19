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

## Just some thinking before actually turning in for the night

I need to figure out a deployment mechanism for this, one which can be integrated into a CI system fairly easily; need to research possible options, i think maybe building a tiny web service that can get webhooks from bitbucket, and which then controls the docker compose setup (changing the container tag) is probably the right call.

Potential problem: I don't know if bitbucket has the features i'd want for this, I do know github does, and I may migrate to that simply because I know what I need from there (container registry, deployments and ci system), and it's all integrated with a repo. -- bitbucket may be the wrong call here, looks less fleshed out than github or gitlab offerings.

theoretically i can maximum jank this but i don't want to maximum jank this, i want to make something good.


## Delivery Adventure (actually turned out to be more setup adventure idk)

okay, fresh the next day, lets see what we can do.

i think that before i can actually get into the automated/continuous deployments, i need to actually figure out how this thing is going to be made "live".
lets go look at terraform providers and see if anything immediately pops out as being a potentially simple option. my backup plan is going to be ansible.

alright, i don't love any of the available options, and in the interest of keeping the costs minimal, i'm going to go with the tried and true "just get yourself a VM running somewhere" method, hopefully somewhere that supports cloud-init (which, isn't super hard, you can get cloud-init working with bare metal using the nocloud provider).

so, things i need to do:

- tooling for getting a vm running with qemu (ideally supports both arm and x64)
- tooling for putting together a cloud init nocloud iso
- actually get a vm running this setup, ideally with a persistent storage space for kafka and postgres data

so, vm with qemu

- download debian nocloud disk image -- https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-arm64.qcow2

actually, nocloud is wrong -- that's for a super basic vm that isn't running in the cloud and doesn't have cloudinit, we need genericcloud

oops genericcloud also isn't right, we need just "generic" because it has the networking drivers necessary for having a network

with generic networking is now working, and the cloud init stuff also seems to be working, so calling that a good resting point for right now, and will focus on actually configuring the instance in cloud init later.

## initial cloud init fun

first round of cloud init fun: getting docker and nomad installed.
had to figure out how to get their key files into the instance (write_files ftw), but they now automagically install, so that's nice.

next steps:
- get nomad running
- write nomad config files to run all the services in docker-compose in nomad
- if all that works, get a new, persistent disk setup for postgres, kafka

## some reflection before continuing

With an evening of reflection, I think I've ended up going off on a choose your own adventure tangent here, focusing on building reproducable infrastructure for the project. I'm going to finish this work, and then get to the deployment system, which will be nomad.

## alright lets get a nomad running

just adding a runcmd to systemctl enable docker and nomad worked great, just needed to port forward nomad in the run-vm script


Went down an annoying tangent that ended up not working out, trying to get the dynamically allocated storage stuff working. My feeling right now is that lets just leave that as an exercise to the reader, and the volumes can either be figured out later, or left out, this is distracting me from my main goal.

got to the important step of actually trying to run the app, aaaaaaand got blocked because i didn't build an x64 container, just an arm one, oops

    docker buildx build -t ghcr.io/sleepdeprecation/procare-challenge --push .

ideally, if i get the actions working, this shouldn't be an issue (because the actions won't need to have a multi arch build, they can just be done on x64).
yeah don't love waiting for the classic intel build to finish, the apple silicon processors are really nice, but `bundle install` has taken 3x as long so far for the intel version because _emulated_, and my bet is it'll take even longer than just the five minutes it's already needed.
oh boy we've reached 400 seconds for just bundle install 🙃
(don't put emoji in markdown files? fight me)

just installing rails itself has been a huge part of this process, so that's _fun_ _great_ _really excellent_. am i sunk cost fallacy-ing myself into believing that it'll have to finish soon enough on my laptop to not just download the repo on my lil intel server and run the build over there? maybe. alright i'm doing it, lets see who finishes first, trying to run this on another computer, or the one that started almost 11 minutes ago? lol as soon as i opened the other terminal window it finished

okay so how about running it this time?? downloading image,,,,,,,,

well i'm getting a _different_ error now, this time it looks like the native extensions didn't properly build? seems like the answer is just go build on the other machine.
tiny mini desktop with an 8 year old processor i use as a server that's just hanging out in my office for the win! built the whole container in a little over two minutes.

okay so maybe this time i can get the service running in nomad? no, and same error.
the error that's coming up is can't find nokogiri, and it's looking for a different version of nokogiri than the one that's installed, my guess is because i didn't copy in Gemfile.lock for the bundle install process, so the lock doesn't agree with what's installed.
Except no, Gemfile.lock is copied into the builder container?

It looks like running a `bundle install` after the copy _should_ result in things getting fixed? lets find out.

and that was it!! nice!

hmm, seems like it can properly talk to postgres, but isn't connecting to kafka :/

Or, most likely it can, but kafka's advertised listeners is a static port, so requests coming to it from a different one might be getting bounced (I think I saw this when i was getting this setup with docker compose initially)

So I'm very confused. I can connect to kafka's port and I'm not blocked from the app container, but attempting to create topics just ends in pain and sadness :/

I'm going to try running these services on not a virtual machine (the lil server i mentioned earlier), and see if I can get it working.
I'm still confused why it worked in docker compose but doesn't work here, but idk idk idk.

okay so it's not a virtual machine vs real machine issue, so that's nice at least. still going to keep debugging on my live cluster.

the error seems to be from a variable having a port in it when I assumed it didn't. Removing the extra port from the stanza got kafka running as expected.

okay! and with some minor changes needed to the service's nomad definition, we are up and running!!

time to see if i can do the full bootstrap from zero with a VM (assuming already produced docker containers).
