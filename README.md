# README

Running in development

```
git clone https://github.com/mimolabs/mimo-api.git
cd mimo-api
docker-compose up
```

Update your hosts file

```
vi /etc/hosts
127.0.0.1       mimo.api
127.0.0.1       mimo.dashboard
```

### Update your client ID and secret

You'll need to update some variables in the MIMO frontend if you're hitting the api from your local machine.

In a terminal (within this folder):

```
docker-compose run api rails c
d = Doorkeeper::Application.first
d.uid
d.secret
```

Update server/config/local.env.sample.js and insert those variables around line 47.

A username and password will have been generated for you when you ran docker-compose up. They can be found in the log.

DO NOT USE LIKE THIS IN PRODUCTION

## Testing

Create a test_vars.rb file in config/initializers with the following credentials:

```
ENV['POSTGRES_PORT']='55432'
ENV['POSTGRES_USER']='mimo-api'
ENV['POSTGRES_PASSWORD']='passw0rd'
```

These might need to be altered depending on your local variables