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

  def run
    Dir.chdir working_dir do
      command_with_params = "#{@command} #{@args.join ' '}"

      res = %x[#{command_with_params}]
      sub_res = ''
      sub_res = @sub_commands.map {|c| c.run }.join("\n") unless @sub_commands.empty?

      res + "\n" + sub_res
    end
  end

  def sub_command(command)
    raise ArgumentError.new 'command must be of type common/command' unless command.kind_of? Command
    @sub_commands << command

  end
end