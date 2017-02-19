require 'common/command'
module GitCommands
  class Config < Command
    def initialize(setting)
      super 'git'
      arg 'config --get'
      arg setting
    end
  end

end