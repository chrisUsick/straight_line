require 'logger'

class Util
  def self.logger
    @logger ||= Logger.new STDOUT
  end
end