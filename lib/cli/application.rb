require 'thor'
require 'cli/feature'
class Application < Thor
  desc 'feature SUBCOMMAND ...ARGS', 'Feature sub commands'
  subcommand 'feature', Cli::Feature
end