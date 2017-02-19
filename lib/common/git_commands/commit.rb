require 'common/command'

module GitCommands
  class Commit < Command
    def initialize(title, body)
      super 'git'
      arg 'commit -a'
      arg "-m #{title}"
      arg "-m #{body}"
    end
  end
end