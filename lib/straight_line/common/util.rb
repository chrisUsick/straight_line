require 'logger'

# Class for global utility methods
class Util
  def self.logger
    @logger ||= Logger.new STDOUT
  end
end
