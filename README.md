# Simple domain tool

This aims to be a simple, handy, web-based tool to query for e.g. DNS and WHOIS records. It should make life easier for people who work with many domains and provide them a "swiss army knife" tool. It is written in [Ruby](http://www.ruby-lang.org) and built with [Sinatra](http://www.sinatrarb.com/). It runs great on Ruby 1.9.3 or 2.0.0 and on Heroku "Celadon Cedar" stack.

## Installation

### How to run the application on your local machine

You can run the application on your local computer by following these steps:

 1. You need to have Ruby installed to proceed.

 2. The dependencies of the application are managed with [Bundler](http://gembundler.com). If Bundler is not yet installed on your system, do this by running

 ```
 gem install bundler
 ```

 The dependencies are specified in the `Gemfile`.

 3. Now that Bundler is available, you can install all dependencies by switching to your application directory and running

 ```
 cd path/to/simple-domain-tool
 bundle install
 ```

 4. You're ready to go. You can run the application as `rack` application by just typing

 ```
 rackup
 ```

 in your application folder.

 5. Open the application in your browser under the given URL (see the console output). Typically this is something like `http://localhost:9292/`.

### How to run the application on Heroku

_(following soon)_

## Dependency status ![Gemnasium dependency status](https://gemnasium.com/rkallensee/simple-domain-tool.png)

## License

[![AGPLv3](http://www.gnu.org/graphics/agplv3-155x51.png)](http://www.gnu.org/licenses/agpl-3.0.html)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
