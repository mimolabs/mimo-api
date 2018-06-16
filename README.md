# MIMO API!

[![CircleCI](https://circleci.com/gh/mimolabs/mimo-api.svg?style=svg)](https://circleci.com/gh/mimolabs/mimo-api)

Normally this will be run by the installer. Should you need to run as a standalone, please follow the steps below. If you also need the worker, add the ohmimo/mimo-worker section back to the docker-compose file

**Make sure you have Docker, Git and Docker Compose installed.**

Clone the repository:

```
git clone https://github.com/mimolabs/mimo-api.git
cd mimo-api
docker-compose up
```

Update your hosts file. vi /etc/hosts

```
127.0.0.1       mimo.api
127.0.0.1       mimo.dashboard
```

### Update your client ID and secret

You'll need to update some variables in the MIMO frontend if you're hitting the api from your local machine.

In a terminal (within this folder):

```
docker-compose run api rails c
```

Get the credentials:

```
d = Doorkeeper::Application.first
d.uid
d.secret
```

Then update server/config/local.env.sample.js and insert those variables around line 47.

A username and password will have been generated for you when you ran docker-compose up. They can be found in the log.

### Default User ###

The default user is user@mimo.com. If you want to change this:

```
docker-compose run api rails c
u = User.first
u.update email: my-email@bla.com, password: 123123123, password_confirmation: 123123123
```

DO NOT USE LIKE THIS IN PRODUCTION

## Testing

Create a `_test_vars.rb` file in config/initializers with the following credentials:

```
ENV['POSTGRES_PORT']='55432'
ENV['POSTGRES_USER']='mimo-api'
ENV['POSTGRES_PASSWORD']='passw0rd'
ENV['REDIS_PORT']='6380'
ENV['REDIS_HOST']='127.0.0.1'
```

These might need to be altered depending on your local variables

## Copyright / License

Copyright 2018 Cucumber Tony, trading as MIMO.

Licensed under the GNU General Public License Version 2.0 (or later);
you may not use this work except in compliance with the License.
You may obtain a copy of the License in the LICENSE file, or at:

   http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
