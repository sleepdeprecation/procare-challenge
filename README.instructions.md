# Procare Online Platform Engineering Exercise

We strive to be a practical and pragmatic platform engineering team. That extends to the way that we work with you to understand if this team is a great fit for you. We want you to come away with a great understanding of the kind of things that we actually do day to day and what it is like to work in our teams.

We realize that taking on this assignment represents a time commitment for you, and we do not take that lightly. Throughout the recruitment process we will be respectful of your time and commit to working quickly and efficiently. This will be the only technical assessment you'll be asked to do. Your submission will be reviewed by our team, and we will provide feedback, no matter what. Your work will not go unreviewed, should you choose to submit it.


## Challenge Guidelines

Think of this like an open source project. Create a repo on Github or Bitbucket, use git for source control, and use a Readme file to document what you built for the newcomer to your project.

We build systems engineered to run in production. Given this, please organize, design, test, deploy, and document your solution as if you were going to put it into production. We do not expect the usage of anything beyond local machine or free-tier resources in order to support it.

Think out loud in your documentation. Write out tradeoffs decisions, the thoughts behind your choices, or things you would do or do differently if you were able to spend more time on the project or do it a second time.

Our team supports a large Ruby/Rails monolith, as well as several other Ruby based applications. For that reason this exercise is centered around a Ruby/Rails app, inspired by an example application relevant to the work our team does, and is aspiring to do. A big thank you to Karafka, and its example apps, for the bulk of this sample  application. You can learn more about that framework here: https://github.com/karafka/example-apps/tree/master/v2.2-rails

With those guidelines in place, the challenge is relatively straightforward:


1. Get the app working somewhere. Preferrably, somewhere you can share with us in the real world, but if you can only get it working on your local machine in the time given, that's OK too. We'll just review that with you on a Zoom call.
2. Choose from the "Adventures" waiting below. You need only pick one, and you can pick whichever you think best showcases your skills and abilities as a platform engineer.
3. Show your work in the form of a Bitbucket or Github repo, with commits or PRs demonstrating your familiarity with incremental change and good Git hygiene.


## Available Adventure(s)

As a Platform Engineering Team, our efforts are focused into three functional areas: stability, delivery, and strategy. As such, we invite you to implement one of these adventures in the application.

### Stability Adventure
NewRelic is reporting increasingly long response times in requests to the /visits page. How could we improve the stability of this endpoint?

### Delivery Adventure
The business risk unit wants CI/CD to run before any deploys to production, and block those deploys if it doesn't pass. They also don't want anything to go out that would jeopardize system response times. What could you write to achieve this?

### Strategy Adventure
Our product team wants to be able to show a real-time view of attendance as it is created, updated, and destroyed. How might we go about achieving that?

### BYO Adventure
You tell us! Show off. Be creative. We're really interested in what you might build with this starter pack.


## Usage Tips

1. Start Kafka using the `docker-compose.yml` by running: `docker-compose up`
2. Run the setup script `./bin/bootstrap` (it will help!)
3. Run `bundle exec rails server` to start the Rails web server
4. Run `bundle exec karafka server` to start Karafka consumption server
5. Visit `localhost:3000` and refresh the page couple of times
6. Visit `localhost:3000/karafka` to see and explore the Karafka Web UI

You can also run RSpec specs to see how the testing RSpec library integrates with Rails:

```
bundle exec rspec spec
```
