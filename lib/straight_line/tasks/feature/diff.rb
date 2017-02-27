require 'rake'
require 'straight_line/common/command'
require 'straight_line/common/feature/diff'

namespace 'feature' do
  desc 'Manages a pull request for the current feature branch'
  task :diff, [:title, :body] do |_, args|
    Feature::Diff.new.diff(args)
  end
end
