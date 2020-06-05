# env-config-action

Env files really annoy me. They have API keys and stuff, and if you want to show off work deployed somewhere cool like AWS, then you need to start storing access tokens in places.

GitHub actions allows for everything to be stored in secrets. You could write a step to take the contents of `secrets.env` and replace the existing `.env` file, but that means if you ever wanted to change the env contents, you'd have to change the secret, and the secret is hidden. So that leaves us in a situation where we have to store the env config somewhere so we have a record of it.

So why not just use the record instead?

So what you can now do is store your env files in another repo, clone that repo, and copy its version of the `.env` file over.

First you need to make your own repo. The structure of the repo should look something like this:

```
CONFIG_REPO_NAME
├── REPO_1
│   ├── .env.dev
│   └── .env.prod
└── REPO_2
    ├── .env.dev
    └── .env.prod
```

The CONFIG_REPO_NAME is the one you'll clone when you want to get you config. REPO_1 and REPO_2 are the names of the repos that you'll get the env for. When running a build, you'll have to specify the stage as the action will look for `.env.${DEPLOYMENT_STAGE}`

So here's an example of mine with some public projects:
```
env-config
├── .gitignore
├── README.md
├── dbd-randomiser
│   ├── .env.dev
│   └── .env.prod
└── dbd-randomiser-server
    ├── .env.dev
    └── .env.prod
```

Second create a github private access token with repo access and set it as a secret variable.

Finally create your github action and include the action.
  * Clone the repo with `actions/checkout`, pass it your token, and your repo name. The path must be `./env-config`.
  * Use the action `arheio/env-config-action@v1`, pass it the name of the repo you're currently in, and then the deployment stage.



```
# This is a basic workflow to help you get started with Actions

name: Build

# Controls when the action will run. Triggers the workflow on push or pull request
# events but only for the master branch
on:
  push:
    branches: [ develop ]
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo🛎️ # this checkout gets the repo the action is running in
        uses: actions/checkout@v2
        with:
          persist-credentials: false

      - name: Checkout Config # this checkout gets the config repo with your env files
        uses: actions/checkout@v2
        with:
          repository: {username}/{config_repo) # this is MY config repo, replace it with your own
          token: ${{ secrets.GITHUB_ACCESS_TOKEN }}
          path: ./env-config
  
      - name: Overwrite environment files # this will overwrite the env file in your repo with the one in the config
        uses: arheio/env-config-action@v1
        with:
          deploymentStage: 'prod'
          repoName: {current_repo_name}
      ...
      # install test build and deploy
```
