class Resource
  include HTTParty
  base_uri 'http://api.football-data.org/v1'
  headers 'X-Auth-Token' => ENV['API_TOKEN']

  def id_from_url(url)
    url.match(/.*?\/(\d+)$/)[1]
  end

end