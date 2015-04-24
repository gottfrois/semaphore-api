# A Hubot-compatible Semaphore API wrapper for Node.js

## Install

```
npm install semaphore-api
```

## Require

Use it in your Hubot scripts:

```coffeescript
module.exports = (robot)->
  semaphore = require('semaphore-api')(robot)
```

Or use it on its own:

```coffeescript
semaphore = require('semaphore-api')
```

You can pass additional options to the constructor if needed.

## Usage

Make any call to the Semaphore API, get the parsed JSON response:

```coffeescript
semaphore.get "projects", (projects)->
  console.log projects[0].name

semaphore.get "projects/:hash_id/branches", (branches)->
  console.log branches[0].name

# Initate a deploy
semaphore.post "project/:hash_id/:branch_id/builds/:build_number/deploy/:server_id", (response)->
  console.log response
```

## Authentication

Simply set `HUBOT_SEMAPHORE_AUTH_TOKEN` env variable:

```
export HUBOT_SEMAPHORE_AUTH_TOKEN=xxxx...
```

## Errors

Used with Hubot, errors are automatically sent to Hubot logger. If you would like to catch errors as well, define your own callback:

```coffeescript
semaphore.handleErrors (response)->
  console.log "Oh no! #{response.statusCode}!"
```

The callback takes a `response` argument with the following keys:

* `error` -- the error message
* `statusCode` -- the status code of the API response, if present.
* `body` -- the body of the API response, if present.

## Options

### Passing options

Options may be passed in three ways, in increasing order of precedence:

1. Through shell env variables
2. Through the constructor:

   ```coffeescript
   semaphore = require('semaphore-api')(robot, authToken: 'xxx')
   ```
3. Using `withOptions`, which lets you pass options to only some requests:

   ```coffeescript
   semaphore = require('semaphore-api')(robot)
   other_provider = semaphore.withOptions(authToken: 'xxxx')

   semaphore.get "projects", -> # ...
   other_provider.get "projects", -> # ...
   ```

### Available options

* `authToken` / `HUBOT_SEMAPHORE_AUTH_TOKEN` -- semaphore API token. Required.
* `apiRoot` / `HUBOT_SEMAPHORE_API` -- base API url. Default to `https://semaphoreci.com/api/v1`.
* `concurrentRequests` / `HUBOT_CONCURRENT_REQUESTS` -- limits the allowed number of concurrent requests to the semaphore API. Default to 20.
* `errorHandler` -- function for custom error handling logic.

## Built-in methods

Because life is too short.

### Projects

```coffeescript
# get all projects
semaphore.projects (projects)->
  console.log projects[0].name
```

### Branches

```coffeescript
# get all branches of given project
semaphore.branches ':project_id', (branches)->
  console.log branches[0].name

# get branch status of given branch
semaphore.branches(':project_id').status ':branch_id', (response)->
  console.log response

# get branch history of given branch (page 1)
semaphore.branches(':project_id').history ':branch_id', (response)->
  console.log response

# get branch history of given branch (page 2)
semaphore.branches(':project_id').history ':branch_id', { page: 2 }, (response)->
  console.log response
```

### Builds

```coffeescript
# get build info of given project and branch
semaphore.builds(':project_id').info ':branch_id', ':build_id', (response)->
  console.log response

# get build log of given project and branch
semaphore.builds(':project_id').log ':branch_id', ':build_id', (response)->
  console.log response

# rebuild given build
semaphore.builds(':project_id').rebuild ':branch_id', ':build_id', (response)->
  console.log response

# launch given build
semaphore.builds(':project_id').launch ':branch_id', ':build_id', (response)->
  console.log response

# stop given build
semaphore.builds(':project_id').stop ':branch_id', ':build_id', (response)->
  console.log response

# deploy given build on given server
semaphore.builds(':project_id').deploy ':branch_id', ':build_id', ':server_id', (response)->
  console.log response
```

### Servers

```coffeescript
# get all servers of given project
semaphore.servers ':project_id', (servers)->
  console.log servers[0].name

# get status of given server
semaphore.servers(':project_id').status ':server_id', (response)->
  console.log response

# get history of given server (apge 1)
semaphore.servers(':project_id').history ':server_id', (response)->
  console.log response

# get history of given server (apge 2)
semaphore.servers(':project_id').history ':server_id', { page: 2 }, (response)->
  console.log response
```

### Deploys

```coffeescript
# get info of given deploy
semaphore.deploys(':project_id', ':server_id').info ':deploy_id', (response)->
  console.log response

# get log of given deploy
semaphore.deploys(':project_id', ':server_id').log ':deploy_id', (response)->
  console.log response

# stop deploying given deploy on given server
semaphore.deploys(':project_id', ':server_id').stop ':deploy_id', (response)->
  console.log response
```

## Contributing

Install the dependencies:

```
npm install
```

Run the tests:

```
make test
```

I'm vastly more likely to merge code that comes with tests. If you're confused by the testing process, ask and I can probably point you in the right direction.

## Thanks

Thanks to [Githubot](https://github.com/iangreenleaf/githubot) author for his amazing work that could get me started.
