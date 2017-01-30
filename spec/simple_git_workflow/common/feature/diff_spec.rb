require 'spec_helper'
require 'common/feature/diff'

describe Feature::Diff do
  before do
    allow_any_instance_of(Kernel).to receive(:system)
  end
  it 'does not create PR if there are uncommitted changes' do
    allow_any_instance_of(Feature::Diff).to receive(:changes_committed?).and_return false
    diff = Feature::Diff.new
    expect {diff.diff}.to raise_error(/Commit.*changes/)
  end

  it 'does not create a PR if not in a feature branch' do
    allow_any_instance_of(Feature::Diff).to receive(:determine_current_feature?).and_return 'master'
    expect {Feature::Diff.new}.to raise_error(UserError)
  end

  context 'pull request does not exist' do
    let(:pull_master) {spy GitCommands::Pull.new('master')}
    let(:rebase_cmd) {spy GitCommands::Rebase.new('master', 'foo')}
    it 'rebases feature branch to master branch' do
      allow_any_instance_of(Feature::Diff).to receive(:changes_committed?).and_return true
      allow_any_instance_of(Feature::Diff).to receive(:current_feature).and_return 'foo'
      allow_any_instance_of(Feature::Diff).to receive(:pull_request_exists?).and_return false
      allow(GitCommands::Pull).to receive(:new).with('master').and_return pull_master
      allow(GitCommands::Rebase).to receive(:new).with('master', 'foo').and_return rebase_cmd
      diff = Feature::Diff.new
      diff.diff
      expect(pull_master).to have_received(:run)
      expect(rebase_cmd).to have_received(:run)
    end
  end

  let(:pull_master) {spy GitCommands::Pull.new('master')}
  let(:rebase_cmd) {spy GitCommands::Rebase.new('master', 'foo')}
  it 'creates pull request' do
    allow_any_instance_of(Feature::Diff).to receive(:changes_committed?).and_return true
    allow_any_instance_of(Feature::Diff).to receive(:current_feature).and_return 'foo'
    allow_any_instance_of(Feature::Diff).to receive(:pull_request_exists?).and_return true
    allow_any_instance_of(Feature::Diff).to receive(:create_pull_request).and_return
    allow(GitCommands::Pull).to receive(:new).with('master').and_return pull_master
    allow(GitCommands::Rebase).to receive(:new).with('master', 'foo').and_return rebase_cmd
    diff = Feature::Diff.new
    diff.diff
  end

  context 'pull request exists' do

  end

  it 'pushes committed changes to existing PR'

  it 'merges changes from master into PR branch'


end