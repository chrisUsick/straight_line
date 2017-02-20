require 'spec_helper'
require 'common/git_commands/config'

describe GitCommands::Config do
  let(:setting) {'remote.origin.url'}
  let(:remote) {%r{git@github\.com:chrisUsick/simple_git_workflow\.git}}
  before do
    allow_any_instance_of(Kernel).to receive(:system)
      .with({}, "git config --get #{setting}").and_return remote
  end
  it 'returns the setting' do
    cmd = GitCommands::Config.new(setting)
    expect(cmd.run).to match remote
  end
end