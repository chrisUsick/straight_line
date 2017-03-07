require 'straight_line/common/command'

module GitCommands
  # Push a branch to remote
  class Push < Command
    def initialize(branch, remote_exists = true, opts = {})
      super('git')
      arg 'checkout'
      arg branch
      if remote_exists.is_a? Hash
        opts = remote_exists
        remote_exists = true
      end

      sub_command push_command(branch, remote_exists, opts)
    end

    def push_command(branch, remote_exists, opts)
      push_command = Command.new('git')
                            .arg('push')

      if opts[:delete]
        push_command
            .arg('origin')
            .arg('--delete')
            .arg(branch)
      elsif !remote_exists
        push_command
          .arg('--set-upstream')
          .arg('origin')
          .arg(branch)
      end
      push_command
    end
  end
end
