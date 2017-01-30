require 'common/command'
module GitCommands
  class Push < Command
    def initialize(branch, remote_exists = true)
      super('git')
      arg 'checkout'
      arg branch
      push_command = Command.new('git')
        .arg('push')

      push_command
        .arg('--set-upstream')
        .arg('origin')
        .arg(branch) unless remote_exists

    end
  end
end

