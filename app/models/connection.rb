class Connection
  def initialize(token)
    @conn = Faraday.new(:url => 'https://cookbyhand.appspot.com/') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    @token = token
  end

  def text(msg)
    response = @conn.post do |req|
      req.url '_ah/api/mirror/v1/timeline'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{@token}"
      req.body = { "text" =>  msg}.to_json
    end
    response.status
  end

  def create_subscription
    response = @conn.post do |req|
      req.url '_ah/api/mirror/v1/subscriptions'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{@token}"
      req.body = { "callbackUrl" =>  "https://localhost:3000", "collection" => "timeline"}.to_json
    end
    response.status
  end

  # Junk
  def test
    payload = { :media => Faraday::UploadIO.new(Rails.root + 'pulbic/image.jpg', 'image/jpeg') }
    #headers['Content-Type'] = 'application/json'
    #headers['Authorization'] = "Bearer #{token}"
    response = conn.post '_ah/api/mirror/v1/timeline', payload, 'Authorization' => "Bearer #{token}"
    #payload = Faraday::UploadIO.new(Rails.root + 'public/image.jpg', 'image/jpeg')
  end
end
