require 'google/api_client'

module Google
  class APIClient2
    include Google::APIClient::Logging
    def initialize(options={})
      logger.debug { "#{self.class} - Initializing client with options #{options}" }

      # Normalize key to String to allow indifferent access.
      options = options.inject({}) do |accu, (key, value)|
        accu[key.to_sym] = value
      accu
      end
      # Almost all API usage will have a host of 'www.googleapis.com'.
      self.host = options[:host] || 'www.googleapis.com'
      self.port = options[:port] || 443
      self.discovery_path = options[:discovery_path] || '/discovery/v1'

      # Most developers will want to leave this value alone and use the
      # application_name option.
      if options[:application_name]
        app_name = options[:application_name]
        app_version = options[:application_version]
        application_string = "#{app_name}/#{app_version || '0.0.0'}"
      else
        logger.warn { "#{self.class} - Please provide :application_name and :application_version when initializing the client" }
      end
      self.user_agent = options[:user_agent] || (
        "#{application_string} " +
        "google-api-ruby-client/#{Google::APIClient::VERSION::STRING} #{ENV::OS_VERSION} (gzip)"
      ).strip
      # The writer method understands a few Symbols and will generate useful
      # default authentication mechanisms.
      self.authorization =
        options.key?(:authorization) ? options[:authorization] : :oauth_2
      self.auto_refresh_token = options.fetch(:auto_refresh_token) { true }
      self.key = options[:key]
      self.user_ip = options[:user_ip]
      @discovery_uris = {}
      @discovery_documents = {}
      @discovered_apis = {}
      ca_file = options[:ca_file] || File.expand_path('../../cacerts.pem', __FILE__)
      self.connection = Faraday.new do |faraday|
        faraday.response :gzip
        faraday.options.params_encoder = Faraday::FlatParamsEncoder
        faraday.adapter Faraday.default_adapter
      end      
      return self
    end

  end
end


require 'glass/client'

module Glass
  class Client
    def initialize(opts)
      self.api_keys = opts[:api_keys] || ::Glass::ApiKeys.new
      self.google_client = ::Google::APIClient.new(host: 'cookbyhand.appspot.com') #www.googleapis.com
      self.mirror_api = google_client.discovered_api("mirror", "v1")
      self.google_account = opts[:google_account]

      ## this isn't functional yet but this is an idea for
      ### an api for those who wish to opt out of passing in a
      ### google account, by passing in a hash of options
      ###
      ###
      ### the tricky aspect of this is how to handle the update
      ### of the token information if the token is expired.

      self.access_token = opts[:access_token] || google_account.try(:token)
      self.refresh_token = opts[:refresh_token] || google_account.try(:refresh_token)
      self.has_expired_token = opts[:has_expired_token] || google_account.has_expired_token?

      setup_with_our_access_tokens
      setup_with_user_access_token
      self
    end
  end
end

if Rails.env.development?
  ##
  ## if you've set this elsewhere you may want 
  ## to comment this out. 
  ##
  ## Glass requires this to be defined for callback url 
  ## purposes.
  ##
  Rails.application.routes.default_url_options[:host] = 'localhost:3000'
elsif Rails.env.test?

  ## setup whatever you want for default url options for your test env.
end

Glass.setup do |config|
  ## you can override the logo here
  ## config.brandname = "examplename"



  ## manually override your glass views path here.
  config.glass_template_path = "app/views/glass"

end
