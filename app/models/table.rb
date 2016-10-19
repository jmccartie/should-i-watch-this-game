class Table < Resource

  def self.all
    @_all ||= begin
      Rails.cache.fetch("league-table") do
        self.get("/competitions/426/leagueTable").parsed_response["standing"]
      end
    end
  end

  # returns array of team names
  def self.top_10
    self.all.slice(0, 10).map {|t| t["teamName"] }
  end

end