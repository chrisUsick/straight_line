require 'thor'

module Cli
  # Thor subcommand for feature related commands
  class Feature < Thor
    desc 'create <feature_name>', 'Creates a feature branch'
    def create(feature_name)
      cmd = Feature::Create.new feature_name
      cmd.run
    end
  end
end
