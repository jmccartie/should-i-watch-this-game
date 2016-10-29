class Resource
  include HTTParty
  base_uri 'https://footballapi.pulselive.com/football'
  headers 'Origin' => 'https://www.premierleague.com'

  def id_from_url(url)
    url.match(/.*?\/(\d+)$/)[1]
  end

end



#matches
# curl 'https://footballapi.pulselive.com/football/fixtures?comps=1&compSeasons=54&page=0&pageSize=40&sort=desc&statuses=C&altIds=true' -H 'Origin: https://www.premierleague.com' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-US,en;q=0.8,es;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: */*' -H 'Referer: https://www.premierleague.com/results' -H 'Connection: keep-alive' --compressed