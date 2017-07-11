# Job/Worker Paradigm Challenge

This is a small RESTful rails app that utilizes a job/worker queue to asynchronously complete tasks that come in through its API endpoints.

## Setup & Dependencies
Ruby, Rails, PostgreSQL, and Redis are required for this project
1. Clone the repo
2. Run `bundle install` to install ruby gems
3. Run the following command in order to set up and seed the database: `rake db:setup`
4. Start the built in rails server: `rails server`
5. Start Redis server: `redis-server`
6. Start the sidekiq gem: `bundle exec sidekiq`

The app should now be up and running. If at any point you need to reset the database you can run `rake db:reset` and restart the server.

## Testing

This app includes unit and integration tests for models and controllers using Rspec.

To run the Rspec tests use: `bundle exec rspec`

## Models, Controllers, and Workers

This project has only one model, `Url`, located at `app/models/url.rb`. It functions as both a completed and unfinished job.

This project has one `UrlController` located at `app/controllers/url_controller.rb`. This controller is connected to 2 routes: POST at `/job` and GET at `/job/:id`.

This project has one worker, `HardWorker`, located at `app/workers/hard_worker.rb`. This worker performs the logic of querying a webpage for it's html and completing jobs in the job queue.

## Bringing It All Together

I used a widely accepted ruby gem called sidekiq to implement my job/worker framework. Sideqik utilized redis for its queue and completes jobs in a multi-threaded process. This makes it more efficient with raw processing speed and relatively easy to set up. One important note about using this implementation is that though jobs might be started in a specific order, they can complete their execution in any order. Additional configuration would be required to perform serial execution with redis.

The basic workflow of this app would be a new job is sent to my api endpoint. The controller receives the request, saves an instance of the unfinished job to the db, and then creates a job for that instance. At this point the user receives the id for the incomplete job. Then, the worker takes that job off the queue from redis, makes the query, updates the status and html, and saves the completed job to the db.

Users can then hit my #show api endpoint to see a job's html after that job has been completed.

## Potential Improvements

One area I would like to improve would be to add more validations and smart corrections of a url. Right now, I have a model method that will add "https://" if it is not included in the user submitted url. I would also want something that checks and automatically corrects errors if "https://" is typed incorrectly or if they didn't put "www" or a ".com". As it stands, a bad url can be submitted and will be saved as a failure in the db, which not ideal. I would look for a service that knows viable urls and check if a url exists in their records before allowing a url to be saved to my db. 
