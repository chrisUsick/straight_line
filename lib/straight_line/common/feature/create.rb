require 'straight_line/common/user_error'
require 'straight_line/common/command'

module Feature
  # Creates a new branch for the feature
  class Create
    def initialize(feature_name)
      raise UserError, 'Feature name required' unless feature_name
      raise UserError, "Feature name can't have spaces" if feature_name =~ /\s/
      @feature_name = feature_name
    end

    def run
      cmd = Command.new 'git', ['checkout', '-b', @feature_name]
      cmd.run
    end
  end
end
