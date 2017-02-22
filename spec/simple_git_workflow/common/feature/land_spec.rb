require 'spec_helper'
require 'common/feature/land'
require 'common/user_error'
require 'common/command'
require 'common/github'

describe Feature::Land do
  it 'does not land if uncommitted files exist' do
    allow_any_instance_of(Feature::Land).to receive(:changes_committed?).and_return false
    expect{Feature::Land.new.land}.to raise_error UserError
  end

  context 'success', :vcr do
    let(:merge_master_to_feature) { double('Github::Merge', run: true)}
    let(:commit_merge) {double(GitCommands::Commit, run: true)}
    let(:push_feature) {double(GitCommands::Push, run:true)}
    let(:merge_master) { double(GitCommands::Merge, run: true)}
    let(:push_master) { double(GitCommands::Push, run: true)}
    let(:feature_name) {'f7'}
    before(:each) do
      allow_any_instance_of(Github).to receive(:repo_name).and_return('chrisUsick/workflow-test')
      allow_any_instance_of(Command).to receive(:run).and_return ''
      allow(GitCommands::Merge).to receive(:new).and_return merge_master_to_feature
      allow(GitCommands::Push).to receive(:new).and_return double('GitCommands::Push', run: true)
      allow_any_instance_of(Feature::Land).to receive(:current_feature).and_return feature_name
      allow_any_instance_of(Feature::Land).to receive(:changes_committed?).and_return true
      Feature::Land.new.land
    end
    it 'merges master branch to feature branch' do
      expect(GitCommands::Merge).to have_received(:new).with(feature_name, 'master')
    end

    it 'merges feature branch to master' do
      expect(GitCommands::Merge).to have_received(:new).with(feature_name, 'master')
      expect(GitCommands::Merge).to have_received(:new).with('master', feature_name)
    end

    context 'merged in github' do
      let(:feature_name) {'f2'}
      it 'does not merge feature branch to master if done in github' do
        allow_any_instance_of(Feature::Land).to receive(:pull_request_closed?).and_return true
        expect(GitCommands::Merge).to_not have_received(:new).with('master', feature_name)
        expect(GitCommands::Merge).to have_received(:new).with(feature_name, 'master')
      end
    end


    it 'deletes feature branch' do
      expect(GitCommands::Push).to have_received(:new).with(feature_name, delete: true)
    end
  end

end
