require 'common/command'
require 'common/shell_error'
require  'common/util'
module GitCommands
  # Rebase a branch to a base
  class Rebase < Command
    def initialize(base, branch)
      super('git')
      arg 'rebase'
      arg base
      arg branch
    end

    def run(*args)
      super true
    rescue ShellError => e
      if e.message.match %r[Merge conflict in]
        Util.logger.error %q(***** Hint: this looks like a merge conflict.
          Try fixing the conflicts, then run `git add .` and then run the previous command again.)
      end
      raise e
    end
  end
end
