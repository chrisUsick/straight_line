require 'straight_line/common/configure'
require 'rake'

# Base module definition
module StraightLine
  TASK_NAMESPACE = 'sl'
  def self.configure
    yield Configure.new
  end
  def self.task_namespace
    Rake::DSL
  end
end
