require 'spec_helper'
require 'common/github'

describe Github do
  it 'lists repos' do
    github = Github.instance
    github.login
    # expect(github.list_repos.size).to eq(94)
  end

  describe '#create_pull_request', :vcr do
    it 'creates a pull request' do
      instance = Github.instance
      allow(instance).to receive(:repo_name).and_return 'chrisUsick/workflow-test'
      instance.create_pull_request 'f3', 'Title for feature01', ''
    end
  end
end