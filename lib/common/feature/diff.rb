require 'common/command'
require 'common/git_commands/pull'
require 'common/git_commands/rebase'
require 'common/user_error'
module Feature
  class Diff
    attr_reader :feature_name

    def initialize
      @feature_name = current_feature
      raise UserError.new('Failed to create diff: you\'re on the master branch') if @feature_name == 'master'
    end

    def current_feature
      Command.new('git')
        .arg('branch')
        .run
        .match(/^\s\*\S+/)[0].strip
    end

    def diff
      raise 'Commit your changes before creating a diff' unless changes_committed?
      pull_cmd = GitCommands::Pull.new('master')
      if pull_request_exists?
        pull_cmd.run
        GitCommands::Merge.new(feature_name, 'master').run
        GitCommands::Push.new(feature_name).run
      else
        pull_cmd.run
        GitCommands::Rebase.new('master', feature_name).run
        create_pull_request
        GitCommands::Push.new(feature_name, false).run
      end

    end

    def pull_request_exists?
      false
    end

    def create_pull_request

    end

    def changes_committed?
      cmd = Command.new 'git'
      cmd.arg 'status'

      out = cmd.run
      out =~ /nothing to commit/
    end
  end
end