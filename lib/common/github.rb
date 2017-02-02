require 'singleton'
require 'octokit'

class Github
  include Singleton

  def initialize
    @client = nil
  end

  def login
    @client ||= Octokit::Client.new netrc: true, auto_paginate: true
  end

  def list_repos
    @client.repositories query: {type: 'private'}
  end

  def user
    @client.user
  end

end