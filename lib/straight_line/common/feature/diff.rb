require 'straight_line/common/command'
require 'straight_line/common/feature'
require 'straight_line/common/git_commands/pull'
require 'straight_line/common/git_commands/rebase'
require 'straight_line/common/git_commands/merge'
require 'straight_line/common/git_commands/push'
require 'straight_line/common/git_commands/commit'
require 'straight_line/common/git_commands/log'
require 'straight_line/common/user_error'
require 'straight_line/common/github'
require 'octokit'

module Feature
  # Multi purpose feature. It creates a pull request or pushes
  # latest commits to the existing pull request
  class Diff
    include Feature
    attr_reader :feature_name

    def initialize
      @feature_name = current_feature
      if @feature_name == 'master'
        raise UserError, 'Failed to create diff: you\'re on the master branch'
      end
      return if changes_committed?
      raise UserError, 'Commit your changes before creating a diff'
    end

    def diff(params)
      pull_cmd = GitCommands::Pull.new('master')
      pull_cmd.run
      if pull_request_exists?
        diff_pull_request_exists params
      else
        diff_no_pull_request params
      end
    end

    def diff_pull_request_exists(params)
      GitCommands::Merge.new(feature_name, 'master').run
      title, body = extract_params params, [:title, :body]
      begin
        GitCommands::Commit.new(title, body).run
      rescue StandardError => e
        unless e.message.match %r[nothing to commit]
          raise e
        end
      end
      GitCommands::Push.new(feature_name).run
    end

    def diff_no_pull_request(params)
      GitCommands::Rebase.new('master', feature_name).run
      GitCommands::Push.new(feature_name, false).run
      title, body = extract_params params, [:title, :body]
      pr = create_pull_request title, body
      Util.logger.info %(Pull request created: #{pr.html_url}.)
    end

    def require_params(params, required)
      required_errors = required.map do |o|
        validate_param params, o
      end.compact

      raise required_errors.join "\n" unless required_errors.empty?
    end

    def extract_params(params, keys)
      keys.map do |key|
        case key
          when :title
            params[:title] || last_commit_message
          else
            params[key]
        end
      end
    end

    def last_commit_message
      GitCommands::Log.new('-1 --pretty=%B').run.split("\n").first
    end

    # @return String error message if there is an error, else nil
    def validate_param(params, param_spec)
      case param_spec.class
      when Symbol
        "#{param_spec} is not provided." unless params[param_spec]
      end
    end

    def pull_request_exists?
      if Github.pull_request_for_feature(feature_name)
        true
      else
        false
      end
    end

    def create_pull_request(title, body)
      Github.create_pull_request feature_name,
                                 title,
                                 body
    end
  end
end
