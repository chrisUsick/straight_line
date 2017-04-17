require 'open3'
require 'straight_line/common/shell_error'
# Basic class for wrapping shell execution
class Command
  attr_accessor :working_dir
  def initialize(command, args = [])
    @command = command
    @args = args || []
    @working_dir = Dir.pwd
    @sub_commands = []
  end

  def arg(argument, *args)
    @args << argument
    @args += args if args
    self
  end

  def self.from_file(file_name)

  end

  def run(return_stderr = false)
    Dir.chdir working_dir do
      command_with_params = "#{@command} #{@args.join ' '}"

      if return_stderr
        res, status = Open3.capture2e command_with_params
      else
        res, stderr, status = Open3.capture3(command_with_params)
      end
      unless status.exitstatus == 0
        output = return_stderr ? res : "#{res}\n#{stderr}"
        raise ShellError, %(Command `#{command_with_params}` exited with
          status code: #{status.exitstatus}. Command outputted:\n #{output})
      end

      sub_res = ''
      sub_res = @sub_commands.map do |sub_command|
        sub_command.run return_stderr
      end.join("\n") unless @sub_commands.empty?

      res + "\n" + sub_res
    end
  end

  def sub_command(command)
    unless command.is_a? Command
      raise ArgumentError, 'command must be of type straight_line/common/command'
    end
    @sub_commands << command
  end
end
