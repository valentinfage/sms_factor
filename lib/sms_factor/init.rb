class SmsFactor::Init
  attr_accessor :configuration
  
  def self.configuration
    @configuration ||= SmsFactor::Configuration.new
  end
  
  def self.configure
    yield(configuration)
  end
end
