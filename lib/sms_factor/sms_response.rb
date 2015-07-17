class SmsFactor::SmsResponse
  attr_accessor :response
  
  def initialize(response)
    @response = JSON.parse(response)
  end
  
  def success?
    @response['status'] == 1
  end
  
  def message
    @response['message']
  end
  
  def method_missing(m, *args, &block)
    super unless @response.keys.include?(m.to_s)
    @response[m.to_s]
  end
end
