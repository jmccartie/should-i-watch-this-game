class Resource
  include HTTParty
  base_uri 'http://api.football-data.org/v1'
  headers 'X-Auth-Token' => ENV['API_TOKEN']

end