require 'common/command'

module GitCommands
  # Rebase a branch to a base
  class Rebase < Command
    def initialize(base, branch)
      super('git')
      arg 'rebase'
      arg base
      arg branch
    end
  end
end
