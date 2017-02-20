
# Base module for all features
module Feature
  def current_feature
    Command.new('git')
           .arg('branch')
           .run
           .match(/^\*\s+(.*)/)[1].strip
  end

  def changes_committed?
    cmd = Command.new 'git'
    cmd.arg 'status'

    out = cmd.run
    out =~ /nothing to commit/
  end
end
