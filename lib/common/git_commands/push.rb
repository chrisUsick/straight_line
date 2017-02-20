require 'common/command'

module GitCommands
  # Push a branch to remote
  class Push < Command
    def initialize(branch, remote_exists = true)
      super('git')
      arg 'checkout'
      arg branch

      sub_command push_command(remote_exists)
    end

    def push_command(remote_exists)
      push_command = Command.new('git')
                            .arg('push')

      unless remote_exists
        push_command
          .arg('--set-upstream')
          .arg('origin')
          .arg(branch)
      end
      push_command
    end
  end
end
