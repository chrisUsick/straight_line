require 'rake'
require 'straight_line/common/command'

class Configure
  def add(name, type, command, opts = {})
    Rake.application.in_namespace StraightLine::TASK_NAMESPACE do
      Rake::Task.define_task name => opts[:before] do
        if type == :shell
          cmd = Command.new command
          cmd.run
        elsif !name.nil?
          Rake::Task[command].invoke
        end
        after = opts[:after]
        unless after.nil?
          after.each do |task|
            Rake::Task[task].invoke
          end
        end
      end
    end
  end
end