require 'straight_line/common/command'
# Base module for all features
module Feature
  def current_feature
    res = Command.new('git')
                 .arg('branch')
                 .run
                 .match(/^\*\s+(.*)/)[1].strip
    if res =~ /no branch/
      raise UserError, 'A rebase is in process.
        Finish the rebase, then run the command again'
    else
      res
    end
  end

  def changes_committed?
    cmd = Command.new 'git'
    cmd.arg 'status'

    out = cmd.run
    out =~ /nothing to commit/
  end
end
