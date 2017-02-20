require 'common/command'

module GitCommands
  # Merge a branch into base
  class Merge < Command
    def initialize(base, branch)
      super('git')
      arg 'checkout'
      arg base
      merge_command = Command.new('git')
                             .arg('merge --no-ff')
                             .arg(branch)

      sub_command merge_command
    end
  end
end
