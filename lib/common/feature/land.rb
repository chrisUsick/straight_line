require 'common/feature'

module Feature
  # Merges the feature to master and pushes it
  class Land
    include Feature
    def initialize
      if current_feature == 'master'
        raise UserError,
              'Failed to create diff: you\'re on the master branch'
      end
      return if changes_committed?
      raise UserError,
            'Commit your changes before creating a diff'
    end

    def land(_args)
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
