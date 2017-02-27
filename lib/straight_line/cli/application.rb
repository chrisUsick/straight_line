require 'thor'
require 'cli/feature'

# Thor CLI application to use this library's features
class Application < Thor
  desc 'feature SUBCOMMAND ...ARGS', 'Feature sub commands'
  subcommand 'feature', Cli::Feature
end
