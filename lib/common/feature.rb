
module Feature
  def current_feature
    Command.new('git')
        .arg('branch')
        .run
        .match(/^\*\s+(.*)/)[1].strip
  end
end