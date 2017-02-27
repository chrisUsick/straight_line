require 'rake'
require 'straight_line/common/command'
require 'straight_line/common/feature/create'

namespace 'feature' do
  desc 'Creates a feature branch'
  task :create, [:feature_name] do |_, args|
    feature_name = args[:feature_name]
    cmd = Feature::Create.new feature_name
    cmd.run
  end
end
