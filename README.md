# Procare Platform Engineering Exercise, by Sleep

My changes to the actual app are fairly minimal, just enough changes to enable me to run the entire project containerized and inject Kafka and Postgres endpoints as environment variables.

I ended up creating a full infrastructure setup that could be used to run this in almost any environment, and all of that (including more comprehensive documentation) is contained in [`./infrastructure`](./infrastructure).

Just as some general narrative, I had originally intended to go down the Delivery Adventure route, and the majority of the time I was working on spinning up the infrastructure that remained my intention. However, as I continued building out the infrastructure side of things I realized that I think this constitutes a larger effort than what I would've done for the standard build a CI/CD pipeline to prevent deployments when tests don't pass.

For the interested, I also kept a [process log](./docs/process-log.md) tracking some of what I was doing and what I was thinking while I was working on this. It is incredibly messy, and I don't really want to go back and clean it up, because it represents how I would be messaging my work process with someone else over Slack or Teams.

As a side note, keeping my process log has inspired me to try and build a small little project for basically being a process log, but as its own application, that will actually keep track of timestamps. The utility I think is in being able to reference what you did/were thinking while building something so that when it comes time to document those things can be included.
