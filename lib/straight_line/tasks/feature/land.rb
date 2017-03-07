require 'rake'
require 'straight_line/common/command'
require 'straight_line/common/feature/land'

namespace 'feature' do
  desc 'Merges master into the feature branch then merges
  feature into master, and pushes to master'
  task :land, [] do |_, args|
    Feature::Land.new.land(args)
  end
end
