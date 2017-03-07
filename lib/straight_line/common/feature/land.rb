require 'straight_line/common/feature'
require 'straight_line/common/git_commands/merge'
require 'straight_line/common/git_commands/commit'
require 'straight_line/common/git_commands/pull'
require 'straight_line/common/git_commands/push'
require 'straight_line/common/util'
require 'straight_line/common/github'

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
        unless e.message.match %r[nothing to commit]
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
      Util.logger.info 'Changes landed to master, on master branch now.'
    end

    def pull_request_closed?(feature_name)
      p = Github.pull_request_for_feature feature_name
      p.nil? || p.state == 'closed'
    end
  end
end
