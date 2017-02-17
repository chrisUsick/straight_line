require 'common/command'
require 'common/git_commands/pull'
require 'common/git_commands/rebase'
require 'common/git_commands/merge'
require 'common/git_commands/push'
require 'common/git_commands/commit'
require 'common/user_error'
require 'common/github'
require 'octokit'
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
        .match(/^\*\s+(.*)/)[1].strip
    end

    def diff(params)
      raise 'Commit your changes before creating a diff' unless changes_committed?
      pull_cmd = GitCommands::Pull.new('master')
      if pull_request_exists?
        pull_cmd.run
        GitCommands::Merge.new(feature_name, 'master').run
        GitCommands::Commit.new(params[:title], params[:body]).run
        GitCommands::Push.new(feature_name).run
      else
        pull_cmd.run
        GitCommands::Rebase.new('master', feature_name).run
        GitCommands::Push.new(feature_name, false).run
        require_params params, [:title, :body]
        create_pull_request params[:title], params[:body]
      end

    end

    def require_params(params, required)

      required_errors = required.map do |o|
        validate_param params, o
      end.compact

      raise required_errors.join "\n" unless required_errors.size == 0

    end

    # @return String error message if there is an error, else nil
    def validate_param(params, param_spec)
      case param_spec.class
      when Symbol
        "#{param_spec} is not provided." unless params[param_spec]
      else
        nil
      end
    end

    def pull_request_exists?
      false
    end

    def create_pull_request(title, body)
      Github.create_pull_request current_feature,
                                 title,
                                 body
    end

    def changes_committed?
      cmd = Command.new 'git'
      cmd.arg 'status'

      out = cmd.run
      out =~ /nothing to commit/
    end
  end
end