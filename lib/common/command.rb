class Command
  attr_accessor :working_dir
  def initialize(command, args = [])
    @command = command
    @args = args || []
    @working_dir = Dir.pwd
  end

  def arg(argument, *args)
    @args << argument
    @args += args if args
  end

  def run
    Dir.chdir working_dir do
      @env_vars = {}
      command_with_params = "#{@command} #{@args.join ' '}"

      system(@env_vars, command_with_params)
    end
  end
end