# StraightLine

StraightLine is an opinionated Git workflow tool. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'straight_line'
```

And then execute:

    $ bundle

Next, add these lines to your Rakefile: 

```ruby
require 'straight_line/tasks'
```

Generate a github api token by following [these instructions](https://help.github.com/articles/creating-an-access-token-for-command-line-use/).
Make sure the token has the `repo` scope selected.
Save that token for the next step.

Lastly, create a `.netrc` file at `~/.netrc` with the following contents:  

```text
machine api.github.com
	login <Your Github username>
	password <Github API token>
```
## Usage

The basic workflow of StraightLine is: 

 1. Create a feature branch
 2. Create a pull request for the feature
 3. Land the changes to master and delete the remote branch.
 
There are 3 rake commands that help with this workflow.
Note: the quotation marks are important!

 1. `rake "feature:create[<feature-name>]"`
    - creates a branch named `feature-name`
 2. `rake "feature:diff[<title>, <body>]"`
    - Creates a pull request
    - This command manages rebased and/or merging with remote when it is appropriate
    - If a pull request has already been made this command simply pushes you code to the remote
 3. `rake "feature:land"`
    - This command merges the feature branch to master

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/chrisUsick/straight_line](). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

