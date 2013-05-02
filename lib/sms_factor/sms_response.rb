class SmsFactor::SmsResponse
  attr_accessor :is_success
  attr_accessor :credit
  attr_accessor :message
  
  def initialize(is_success, credit, message)
    @is_success = is_success
    @credit     = credit
    @message    = message
  end
  
end