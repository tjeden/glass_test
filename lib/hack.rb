require 'google/api_client'

module Google
  class APIClient
     include Google::APIClient::Logging

     def initialize(options={})
       options[:host] = 'www.googleapis.com'
       super(options)
     end
  end
end

