require 'rake'
require 'common/command'
require 'common/feature/land'

namespace 'feature' do
  desc %q[Merges master into the feature branch then merges
  feature into master, and pushes to master]
  task :land, [] do |_, args|
    Feature::Land.new.land(args)
  end
end