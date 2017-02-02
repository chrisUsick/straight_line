require 'spec_helper'
require 'common/github'

describe Github do
  it 'lists repos' do
    github = Github.instance
    github.login
    expect(github.list_repos.size).to eq(94)
    puts github.user.inspect
  end
end