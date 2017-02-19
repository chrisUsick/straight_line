require 'common/user_error'
require 'common/command'

module Feature
  class Create
    def initialize(feature_name)
      raise UserError.new 'Feature name required' unless feature_name
      @feature_name = feature_name
    end
    def run
      cmd = Command.new 'git', ['checkout',  '-b', @feature_name]
      cmd.run
    end
  end
end