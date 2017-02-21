require 'common/feature'
require 'common/git_commands/merge'
require 'common/git_commands/commit'
require 'common/git_commands/pull'
require 'common/git_commands/push'
require 'common/util'
require 'common/github'

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

    def land(_args = {})
      feature_name = current_feature
      pull_cmd = GitCommands::Pull.new('master')
      pull_cmd.run
      GitCommands::Merge.new(feature_name, 'master').run

      begin
        GitCommands::Commit.new("Merge master into #{feature_name}", '').run
      rescue StandardError => e
        unless e.message.match %r[Your branch is up-to-date with 'origin/#{feature_name}]
          raise e
        end
      end

      GitCommands::Push.new(feature_name).run
      if pull_request_closed?(feature_name)
        Util.logger.info %{#{feature_name} was merged in github.
          You're repo is up-to-date with remote}
      else
        GitCommands::Merge.new('master', feature_name).run
        GitCommands::Push.new('master').run
      end
      GitCommands::Push.new(feature_name, delete: true).run
      Command.new('git checkout master').run
    end

    def pull_request_closed?(feature_name)
      p = Github.pull_request_for_feature feature_name
      p.nil? || p.state == 'closed'
    end
  end
end
