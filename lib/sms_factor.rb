require 'rest-client'
require 'nokogiri'

class SmsFactor
  attr_accessor :message, :recipients, :sender
  
  def initialize(message, recipients, sender)
    raise "The configuration is not complete" unless SmsFactor::Init.configuration.is_valid?
    
    @sender        = sender 
    @recipients    = recipients.kind_of?(Array) ? recipients : [recipients]
    @message       = message
  end
  
  def build
    {
      sms: auth_credentials.merge(
        message: {text: @message, sender: @sender, pushtype: 'alert'},
          recipients: {
            gsm: @recipients.collect{|recipient| {value: recipient}}
          }
      )
    }
  end
  
  def auth_credentials
    @auth_credentials ||= {
                            authentication: {
                              username: SmsFactor::Init.configuration.api_login,
                              password: SmsFactor::Init.configuration.api_password
                            }
                          }
  end
  
  def deliver(delay: :now, check: false)
    data  =   case delay
                when nil, :now
                  build
                else
                  build[:sms].merge!({delay: delay})
                end
                
    url   =   "#{SmsFactor::Init.configuration.api_url}/send"
    url   =   "#{url}/simulate" if check
    
    SmsFactor::SmsResponse.new(
      RestClient.post(
        url,
        { data: data.to_json },
        content_type: :json,
        accept:       :json,
        verify_ssl:   false
      )
    )
  end
  
  def self.sms(message, recipients, sender = nil)
    sms = SmsFactor.new(message, recipients, sender)
    sms.deliver
  end
end

require 'sms_factor/configuration'
require 'sms_factor/init'
require 'sms_factor/sms_response'
