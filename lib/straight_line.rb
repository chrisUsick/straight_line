require 'straight_line/common/configure'
require 'straight_line/tasks'
require 'rake'

# Base module definition
module StraightLine
  TASK_NAMESPACE = 'sl'.freeze
  def self.configure
    yield Configure.new
  end

  def self.task_namespace
    Rake::DSL
  end
end
