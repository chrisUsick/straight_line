require 'straight_line/common/command'

module GitCommands
  # Read a config setting
  class Config < Command
    def initialize(setting)
      super 'git'
      arg 'config --get'
      arg setting
    end
  end
end
