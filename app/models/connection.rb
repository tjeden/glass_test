class Connection
  def test(token)
    conn = Faraday.new(:url => 'https://cookbyhand.appspot.com/') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    response = conn.post do |req|
      req.url '_ah/api/mirror/v1/timeline'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{token}"
      req.body = { "text" =>  "Hello again"}.to_json
    end
  end
end
