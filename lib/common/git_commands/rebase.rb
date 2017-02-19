require 'common/command'
module GitCommands
  class Rebase < Command
    def initialize(base, branch)
      super('git')
      arg 'rebase'
      arg base
      arg branch
    end
  end
end

