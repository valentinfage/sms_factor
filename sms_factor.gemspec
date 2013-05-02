Gem::Specification.new do |s|
  s.name          = 'sms_factor'
  s.version       = '0.1.0'
  s.date          = '2013-05-02'
  s.summary       = "An easy way to send SMS through SmsFactor API"
  s.description   = "An easy way to use API SMS of http://www.smsfactor.com/ (http://www.smsfactor.com/SMS-integration-API-HTML)"
  s.authors       = ["Julien Séveno"]
  s.email         = 'juseveno@gmail.com'
  s.files         = [
                      "lib/sms_factor.rb",
                      "lib/sms_factor/configuration.rb",
                      "lib/sms_factor/init.rb",
                      "lib/sms_factor/sms_response.rb"
                    ]
  s.homepage      = 'https://github.com/juseveno/sms_factor'
  s.licenses      = ["MIT"]
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["LICENSE.txt", "README.rdoc"]
  s.add_runtime_dependency "faraday", [">= 0.8.6"]
  s.add_runtime_dependency "nokogiri", [">= 1.5.9"]
  s.required_ruby_version = '>= 2.0.0'
  s.requirements << 'faraday, >= 0.8.7'
  s.requirements << 'nokogiri, >= 1.5.9'
  s.requirements << 'An account on http://www.smsfactor.com/'
end