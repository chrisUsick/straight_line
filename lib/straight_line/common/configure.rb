require 'rake'
require 'straight_line/common/command'
require 'straight_line/common/util'

# Configuration class to add tasks to the straightline rake config
class Configure
  def add(name, type, command, opts = {})
    Rake.application.in_namespace StraightLine::TASK_NAMESPACE do
      Rake::Task.define_task name => opts[:before] do
        if type == :shell
          cmd = Command.new command
          Util.logger.info "executing command #{command}. Error results will be
            displayed if any ocur"
          cmd.run
        elsif !name.nil?
          Util.logger.info "executing task #{command}. Error results will be
          displayed if any ocur"
          Rake::Task[command].invoke
        end
        run_after_commands(opts)
      end
    end
  end

  private

  def run_after_commands(opts)
    after = opts[:after]
    return if after.nil?
    after.each do |task|
      Rake::Task[task].invoke
    end
  end
end
