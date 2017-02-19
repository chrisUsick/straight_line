require 'spec_helper'
require 'common/feature/diff'

describe Feature::Diff do
  before do
    allow_any_instance_of(Kernel).to receive(:system)
  end

  context 'pull request does not exist' do
    let(:pull_master) {spy GitCommands::Pull.new('master')}
    let(:rebase_cmd) {spy GitCommands::Rebase.new('master', 'foo')}
    it 'creates pull request' do
      allow_any_instance_of(Feature::Diff).to receive(:changes_committed?).and_return true
      allow_any_instance_of(Feature::Diff).to receive(:current_feature).and_return 'foo'
      allow_any_instance_of(Feature::Diff).to receive(:pull_request_exists?).and_return false
      allow_any_instance_of(Feature::Diff).to receive(:create_pull_request)
      allow(GitCommands::Pull).to receive(:new).with('master').and_return pull_master
      allow(GitCommands::Rebase).to receive(:new).with('master', 'foo').and_return rebase_cmd
      diff = Feature::Diff.new
      diff.diff title: 'title', body: 'body'
      expect(pull_master).to have_received(:run)
      expect(rebase_cmd).to have_received(:run)
      expect(diff).to have_received(:create_pull_request).with 'title', 'body'
    end
  end

  context 'pull request exists' do
    let(:pull_master) {spy GitCommands::Pull.new('master')}
    let(:merge_cmd) {spy GitCommands::Merge.new('foo', 'master')}
    let(:push_cmd) {spy GitCommands::Push.new('foo')}
    let(:commit_cmd) {spy GitCommands::Commit.new('title', 'body')}
    it 'merges changes on master and pushes changes' do
      allow_any_instance_of(Feature::Diff).to receive(:changes_committed?).and_return true
      allow_any_instance_of(Feature::Diff).to receive(:current_feature).and_return 'foo'
      allow_any_instance_of(Feature::Diff).to receive(:pull_request_exists?).and_return true
      allow(GitCommands::Pull).to receive(:new).with('master').and_return pull_master
      allow(GitCommands::Merge).to receive(:new).with('foo', 'master').and_return merge_cmd
      allow(GitCommands::Commit).to receive(:new).with('title', 'body').and_return commit_cmd
      allow(GitCommands::Push).to receive(:new).with('foo').and_return push_cmd

      diff = Feature::Diff.new
      diff.diff title: 'title', body: 'body'

      expect(pull_master).to have_received(:run)
      expect(merge_cmd).to have_received(:run)
      expect(push_cmd).to have_received(:run)
      expect(commit_cmd).to have_received(:run)
    end
  end

  it 'pushes committed changes to existing PR' do

  end

  it 'merges changes from master into PR branch'


end