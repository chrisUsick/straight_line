require 'straight_line/common/util'

# Util class for common git related actions
module GitCommands
  def handle_merge_conflict(e)
    if e.message =~ /Merge conflict in/
      Util.logger.error '***** Hint: this looks like a merge conflict.
          Try fixing the conflicts, then run `git add .` and then run the
          previous command again.'
    end
    raise e
  end
end
