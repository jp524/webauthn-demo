# WebAuthn Demo

Ruby on Rails application demonstrating login with multi-factor authentication using WebAuthn.

The app relies on the `webauthn` gem and the `@github/webauthn-json` package.

## Local Installation

### Requirements

* Ruby 3.1.2
* SQLite
* Chromedriver (for system tests)
* Google Chrome (for system tests)

### Setup

1. Download the repository: `git clone https://github.com/jp524/webauthn-demo.git`
2. Enter the directory: `cd webauthn-demo`
3. Install gems: `bundle install`
4. Prepare database: `rails db:create` and `rails db:migrate`
5. Start the server: `bin/dev`

The application can be viewed at http://localhost:3000.