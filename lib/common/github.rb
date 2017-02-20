require 'singleton'
require 'octokit'
require 'common/user_error'
require 'common/git_commands/config'

# Github API wrapper
class Github
  include Singleton

  def initialize
    @client = nil
  end

  def self.make_class(name)
    class << self
      self
    end.instance_eval do
      define_method name do |*args|
        instance.send name, *args
      end
    end
  end

  def login; end

  def list_repos
    @client.repositories query: { type: 'private' }
  end

  def user
    @client.user
  end

  def ensure_logged_in
    raise UserError, 'Must be logged in first' unless @client
  end

  def client
    return @client if @client

    @client = Octokit::Client.new netrc: true, auto_paginate: true
  end

  def create_pull_request(branch, title, body)
    repo = repo_name
    client.create_pull_request repo,
                               'master', "#{github_login}:#{branch}", title, body
  end
  make_class :create_pull_request

  def repo_name
    cmd = GitCommands::Config.new('remote.origin.url')
    remote = cmd.run
    remote.match(%r{(git@github.com:)(.*/.*)})[2]
  end

  def github_login
    client.user.login
  end
  make_class :github_login

  def pull_requests
    client.pull_requests repo_name
  end
  make_class :pull_requests
end
