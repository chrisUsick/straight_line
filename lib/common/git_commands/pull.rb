require 'common/command'

module GitCommands
  # pull a branch from remote
  class Pull < Command
    def initialize(branch)
      super('git')
      arg 'checkout -b'
      arg branch
      pull_command = Command.new 'git'
      pull_command
        .arg('pull origin')
        .arg branch
      sub_command pull_command
    end
  end
end
