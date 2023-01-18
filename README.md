# The Ultimate Search for Rails

The demo app to illustrate [this post on DEV.to](https://dev.to/lso/the-ultimate-search-for-rails-episode-1-1mi)

Chek out the [live app](https://search-paradise.fly.dev/)

This app runs on Rails 7 with `importmaps` and Ruby 3.2. 

Just make sure `redis` is running, then :
```
rails db:setup
# If you have overmind
overmind start -f  Procfile.dev
# Otherwise
rails s
```
