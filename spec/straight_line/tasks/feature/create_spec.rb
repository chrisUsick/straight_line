require 'spec_helper'
require 'straight_line/tasks/feature/create'
describe 'feature:create' do
  let :run_rake_task do
    Rake::Task['feature:create'].reenable
    Rake.application.invoke_task 'feature:create[feature_1]'
  end
  let(:create_cmd) {Feature::Create.new 'foo'}
  it 'calls git checkout' do
    allow_any_instance_of(Feature::Create).to receive(:run)
    allow(Feature::Create).to receive(:new).with('feature_1').and_return create_cmd
    run_rake_task
  end
end
