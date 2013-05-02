require 'faraday'
require 'nokogiri'

class SmsFactor
  
  def initialize(message, recipients, from = nil)
    raise "The configuration is not complete. Please define api_url, api_login, api_password and api_default_from" unless SmsFactor::Init.configuration.is_valid?
    
    @from       = (from.nil? ? SmsFactor::Init.configuration.api_default_from : from)
    @message    = message
    @recipients = recipients.kind_of?(Array) ? recipients : [recipients]
  end
  
  def send_alert
    conn = Faraday.new(:url => SmsFactor::Init.configuration.api_url, :ssl => {:verify => false}) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
    
    infos = "<sms><authentification><username>#{SmsFactor::Init.configuration.api_login}</username><password>#{SmsFactor::Init.configuration.api_password}</password></authentification><message><sender>#{@from}</sender><text>#{@message}</text></message><recipients>"
    @recipients.each do |recipient|
      infos << "<gsm gsmsmsid='#{Time.now.to_i}'>#{recipient}</gsm>"
    end
    infos << "</recipients></sms>"
    
    result = conn.post(
      '/API/apiV2.php',
      "XML=#{infos}"
    )
    
    r = Nokogiri::XML(result.body)
    
    code, msg, cred = if r.at_css('response/status')
      [
        false,
        "Unable to connect to SMS Factor",
        nil
      ]
    else
      [
        r.at_css('response/status').text,
        r.at_css('response/message').text,
        (r.at_css('response/credits') ? r.at_css('response/credits').text : nil)
      ]
    end
    
    return SmsFactor::SmsResponse.new(code == "1", cred.to_i, msg)
  end
  
  def self.alert(message, recipients, from = nil)
    alert = SmsFactor.new(message, recipients, from)
    return alert.send_alert
  end
end

require 'sms_factor/configuration'
require 'sms_factor/init'
require 'sms_factor/sms_response'