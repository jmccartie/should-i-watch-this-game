# {"name"=>"Arsenal", "club"=>{"name"=>"Arsenal", "shortName"=>"Arsenal", "abbr"=>"ARS", "id"=>1.0},
# "teamType"=>"FIRST", "grounds"=>[{"name"=>"Emirates Stadium", "city"=>"London", "capacity"=>60272.0,
# "location"=>{"latitude"=>51.5548, "longitude"=>-0.108533}, "id"=>52.0}], "shortName"=>"Arsenal", "id"=>1.0}

class Team < Resource

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    data["id"].to_i
  end

  def self.find(id)
    self.all.detect {|team| team.id == id }
  end

  def self.all
    self.get('/compseasons/54/teams').parsed_response.map {|t| Team.new(t) }
  end

  def crest_css
    data["altIds"]["opta"]
  end

  def short_name
    data["club"]["shortName"]
  end
  alias_method :name, :short_name

  def ranking
    @_ranking ||= Table.all.find {|item| item[:team_name] == data["club"]["name"] }[:position]
  end

end