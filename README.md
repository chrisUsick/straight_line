# StraightLine

StraightLine helps achieve a good DevOps practise with minimal effort. It provides a mechanism for creating an managing tasks, is easily distributed (through rubygems), and provides a revision control process which follows the Github workflow.  

Why does revision control and task management need to be combined? StraightLine's aim is to allow developers to focus on coding without compromising on a good CI process. In the near future StraightLine will allow tasks to be executed before any revision control action is done. For example, before a feature is pushed, the lint and test tasks could be run. This is bringing the errors closer to the developer which has been proven to increase efficiency.

StraightLine is **not** only for Ruby based projects. StraightLine can be used to manage tasks and workflow of *any* type of project.  

Feel free to submit any bugs or questions as github issues [here](https://github.com/chrisUsick/straight_line/issues).  

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'straight_line'
```

And then execute:

```
    $ bundle install
```

Next, add these lines to your Rakefile: 

```ruby
require 'straight_line'
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

Note `~/.netrc` needs to have `600` permissions. Do this with the following command:

```bash
chmod 600 ~/.netrc
```
## Revision Control
### Usage

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
    - This command manages rebasing and/or merging with remote when it is appropriate
    - If a pull request has already been made this command simply pushes you code to the remote branch
 3. `rake "feature:land"`
    - This command merges the feature branch to master

## Tasks

Straightline extends [Rake](https://github.com/ruby/rake), a simple yet powerful task running tool, to allow for quick definition of build and deploy pipelines. It allows tasks to be defined as rake tasks, shell commands, or bash scripts and lets you manage them from one place.   
StraightLine injects rake tasks at runtime. In other words, you configure straightline tasks in a Rakefile (or elsewhere) and execute them by running rake tasks.  

### Usage 

In you rake file add a config block like so: 

```ruby
StraightLine.configure do |config|
    config.add 'provision', :shell, './scripts/provision.sh'
    config.add 'deploy', :shell, './scripts/deploy.sh'
end
```

#### `config.add` options

These are the parameters that can be passed to `config.add`, in order:

 - name:    Required   Name of the task
 - type:    Required   Type of command, either `:shell` or `:rake`
 - command: Required   The command to run. If `type` is `:shell` then this should point to a shell script or be a shell command. If `type` is `:rake` then it should be the namespaced name of a rake task
 - options: Optional   The options can be passed to further modify a task. `opts[:before]` and  `opts[:after]` should be array of straightline tasks to run before/after the given task executes.  

 Example of defining before tasks:

 ```ruby
StraightLine.configure do |config|
    config.add 'build', :shell, './scripts/build.sh'
    config.add 'deploy', :shell, './scripts/deploy.sh', before: 'build'
end
 ```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/chrisUsick/straight_line](). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

