
Write on rails
===
WriteOnRails is an application designed to inspire and motivate the Ruby on Rails community to write more RoR-related content.
We wrote this application during the Ruby on Rails 2023 Hackathon. Although we only managed to use 10 hours out of the 48 hours from the competition, we were captivated by the idea. As a result, we are now refining some features and deploying it for anyone who wishes to use it!

#### Main features:

🚀 Share Your Knowledge, Reach a Wider Audience: Write in our editor or sync your content from integrated platforms like Hashnode, Dev.to, Medium, and Notion. Utilize our repost feature to publish your content on any platform of your choice, expanding your reach effortlessly.

📣 Reach even more: We assist in sharing your articles on LinkedIn and Twitter, adapting the style for better engagement.

🏆 Earning Recognition and Rewards: Get acknowledged for your content with our points-based system. Your top 3 articles with the highest points compete in the community leaderboard for monthly prizes.


## Project Details

We are using ruby 3.2.2 and Rails 7.0.6. If you want to setup locally just follow these steps.
This project uses [Standard](https://github.com/testdouble/standard) plus some extra config in the .rubocop.yml for formatting Ruby code. Please make sure to run rubocop with it before submitting pull requests.

1. Run `bundle install`
2. Run `yarn install` (some dev dependencies here needs node v20+)
3. Run `bin/rails credentials:edit` and update your integration credentials:
```yaml
notion:
  client_id: <your-notion-client-id>
  client_secret: <your-notion-client-secret>

medium:
  integration_token: <your-medium-integration-token>
  client_id: <your-medium-client-id>
  client_secret: <your-medium-client-secret>

development:
  github:
    client_id: <your-github-client-id>
    client_secret: <your-github-clinet-secret>

production:
  github:
    client_id: <your-github-client-id>
    client_secret: <your-github-clinet-secret>

```
4. Run migrations and you are ready to get started
5. *(optional)* Install tmux and overmind and then use `overmind start` instead of bin/dev for running the application. Its really helpful for debugging and restarting process on the fly.


## Appendix and FAQ

> **NOTE**
> Tests are coming! We decided to skip them because only had about 10 hours to code the project in the 48hours Hackathon (it was a busy weekend for us)
> Find this document incomplete? Open an issue!
