require 'straight_line/common/command'
require 'straight_line/common/git_commands'

module GitCommands
  # Merge a branch into base
  class Merge < Command
    include GitCommands
    def initialize(base, branch)
      super('git')
      arg 'checkout'
      arg base
      merge_command = Command.new('git')
                             .arg('merge --no-ff')
                             .arg(branch)

      sub_command merge_command
    end

    def run(*_args)
      super true

    rescue ShellError => e
      handle_merge_conflict e
    end
  end
end
