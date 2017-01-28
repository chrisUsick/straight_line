require 'common/command'

module Feature
  class Diff
    def initialize

    end

    def diff
      raise 'Commit your changes before creating a diff' unless changes_committed?
    end

    def changes_committed?
      cmd = Command.new 'git'
      cmd.arg 'status'

      out = cmd.run
      out =~ /nothing to commit/
    end
  end
end