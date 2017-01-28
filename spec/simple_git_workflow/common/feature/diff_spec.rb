require 'spec_helper'
require 'common/feature/diff'

describe Feature::Diff do
  it 'does not create PR if there are uncommitted changes' do
    allow_any_instance_of(subject).to receive(:changes_committed?).and_return false
    diff = Feature::Diff.new
    expect(diff.diff).to raise_error(/Commit.*changes/)
  end

  it 'rebases feature branch to master branch'

  it 'creates pull request'

  it 'pushes committed changes to existing PR'

  it 'merges changes from master into PR branch'


end