require 'straight_line/common/configure'

# Base module definition
module StraightLine
  def self.configure
    yield Configure.new
  end
end
