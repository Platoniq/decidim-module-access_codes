# Decidim::AccessCodes

[![[CI] Test](https://github.com/Platoniq/decidim-module-access_codes/actions/workflows/test.yml/badge.svg)](https://github.com/Platoniq/decidim-module-access_codes/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/Platoniq/decidim-module-access_codes/branch/main/graph/badge.svg?token=DtR8J7AOav)](https://codecov.io/gh/Platoniq/decidim-module-access_codes)
[![Maintainability](https://api.codeclimate.com/v1/badges/9c1e9246a4b12af400e3/maintainability)](https://codeclimate.com/github/Platoniq/decidim-module-access_codes/maintainability)

The gem has been developed by [Platoniq](https://github.com/Platoniq/).

A [Decidim](https://github.com/decidim/decidim) module that provides a new
verification method that allows system administrators to define new verification
workflows where the admins can provide access to specific users by sending them an access code.

This module does not itself register any verification workflows because these
access code workflows are generally specific to the system in question. For
example, if the admins want to provide access only for specific users to add
new proposals in a specific participatory space, they can define a new workflow
for that.

The access code workflow works as follows:

- An admin enters a list of emails
- An access code is sent to each of these emails
- Users that receive the email can enter the acces code to get verified
- An access code can be used N times


## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-access_codes", git: "https://github.com/Platoniq/decidim-module-access_codes"
```

And then execute:

```bash
bundle
bundle exec rake decidim_access_codes_verification:install:migrations
rails db:migrate
```

Finally, enable the verification method by creating an initializer, for instance in the file `config/initializers/access_codes_verification.rb`:

```ruby
# frozen_string_literal: true

Decidim::Verifications.register_workflow(:access_codes) do |workflow|
  workflow.engine = Decidim::AccessCodes::Verification::Engine
  workflow.admin_engine = Decidim::AccessCodes::Verification::AdminEngine
end

```

## Usage

For enabling the verifcation method:

- Follow the installation instructions above.
- Login to the system management section of Decidim at `/system`.
- Enable the newly added verification method.

After enabled, you can now authorize with access codes:

- Login to Decidim.
- Go to My account > Authorizations.
- Click the newly added authorization ("Access codes").
- Enter the access code.
- Click "Submit".

As an admin, you can send access codes:

- Login to Decidim as an admin user.
- Go to Admin dashboard > Users > Verifications > Access codes.
- You will see a list of sent access codes.
- You can create new access codes by clicking on "Create access codes".
- You can destroy existing access codes by clicking on the cross icon in each row (this will also destroy related user authorizations).

As an admin, you can manage access codes:

- You can view users that have authorized with each of these access codes by clicking on the person icon in each row.
- You can view a user's profile by clicking on the person icon in each row
- You can destroy the authorization for a specific user by clicking on the cross icon in each row

After this, you can now control the access to certain functionality using
Decidim's permissions (e.g. component permssions). For example, you can limit
the creation of new proposals only for approved users.

## Contributing

See [Decidim](https://github.com/Platoniq/decidim-module-access_codes).

### Developing

To start contributing to this project, first:

- Install the basic dependencies (such as Ruby and PostgreSQL)
- Clone this repository

Decidim's main repository also provides a Docker configuration file if you
prefer to use Docker instead of installing the dependencies locally on your
machine.

You can create the development app by running the following commands after
cloning this project:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake development_app
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

Then to test how the module works in Decidim, start the development server:

```bash
$ cd development_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rails s
```

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add the environment variables to the root directory of the project in a file
named `.rbenv-vars`. If these are defined for the environment, you can omit
defining these in the commands shown above.

#### Code Styling

Please follow the code styling defined by the different linters that ensure we
are all talking with the same language collaborating on the same project. This
project is set to follow the same rules that Decidim itself follows.

[Rubocop](https://rubocop.readthedocs.io/) linter is used for the Ruby language.

You can run the code styling checks by running the following commands from the
console:

```
$ bundle exec rubocop
```

To ease up following the style guide, you should install the plugin to your
favorite editor, such as:

- Atom - [linter-rubocop](https://atom.io/packages/linter-rubocop)
- Sublime Text - [Sublime RuboCop](https://github.com/pderichs/sublime_rubocop)
- Visual Studio Code - [Rubocop for Visual Studio Code](https://github.com/misogi/vscode-ruby-rubocop)

### Testing

To run the tests run the following in the gem development path:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake test_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rspec
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add these environment variables to the root directory of the project in a
file named `.rbenv-vars`. In this case, you can omit defining these in the
commands shown above.

### Test code coverage

If you want to generate the code coverage report for the tests, you can use
the `SIMPLECOV=1` environment variable in the rspec command as follows:

```bash
$ SIMPLECOV=1 bundle exec rspec
```

This will generate a folder named `coverage` in the project root which contains
the code coverage report.

### Localization

If you would like to see this module in your own language, you can help with its
translation at Crowdin:

https://crowdin.com/project/decidim-access-codes

## License

See [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt).
