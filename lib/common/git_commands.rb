require 'common/util'
module GitCommands
  def handle_merge_conflict(e)
    if e.message.match %r[Merge conflict in]
      Util.logger.error %q(***** Hint: this looks like a merge conflict.
          Try fixing the conflicts, then run `git add .` and then run the previous command again.)
    end
    raise e
  end
end