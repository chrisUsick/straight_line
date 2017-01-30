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
      @env_vars = {}
      command_with_params = "#{@command} #{@args.join ' '}"

      system(@env_vars, command_with_params)
      @sub_commands.each {|c| c.run }
    end
  end

  def sub_command(command)
    raise ArgumentError.new 'command must be of type common/command' unless command.kind_of? Command
    @sub_commands << command

  end
end