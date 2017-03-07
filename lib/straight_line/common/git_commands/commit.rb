require 'straight_line/common/command'

module GitCommands
  # Commit
  class Commit < Command
    def initialize(title, body = '')
      super 'git'
      arg 'commit -a'
      arg %(-m "#{title}") unless title.empty?
      arg %(-m "#{body}") unless body.nil? || body.empty?
    end
  end
end
