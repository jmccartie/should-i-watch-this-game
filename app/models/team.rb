class Team < Resource

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def self.find(id)
    Rails.cache.fetch("teams-#{id}") do
      resp = self.get("/teams/#{id}").parsed_response
      Team.new(resp)
    end
  end

  def crest_url
    data["crestUrl"]
  end

  def ranking
    @_ranking ||= Table.all.find {|item| item["teamName"] == data["name"] }["position"]
  end

end