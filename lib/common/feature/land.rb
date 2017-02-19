require 'common/feature'
module Feature
  class Land
    include Feature
    def initialize
      raise UserError.new('Failed to create diff: you\'re on the master branch') if current_feature == 'master'
      raise UserError.new('Commit your changes before creating a diff') unless changes_committed?
    end
    def land(args)
      pull_cmd = GitCommands::Pull.new('master')
      pull_cmd.run
      feature_name = current_feature
      GitCommands::Merge.new(feature_name, 'master').run
      GitCommands::Commit.new("Merge master into #{feature_name}", '').run
      GitCommands::Push.new(feature_name).run
      GitCommands::Merge.new('master', feature_name).run
      GitCommands::Push.new('master').run
    end
  end
end