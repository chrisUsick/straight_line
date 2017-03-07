require 'straight_line/common/command'

module GitCommands
  # return git log information
  class Log < Command
    def initialize(opts)
      super 'git'
      arg 'log'
      arg opts
    end
  end
end
