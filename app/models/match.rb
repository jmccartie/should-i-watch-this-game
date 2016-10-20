class Match < Resource

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    id_from_url data["_links"]["self"]["href"]
  end

  def self.since(days=3)
    Rails.cache.fetch("matches-#{days}", expires_in: 30.minutes) do
      self.get("/competitions/426/fixtures?timeFrame=p#{days}").parsed_response["fixtures"]
    end.map {|f| Match.new(f) }
  end

  def self.find(id)
    data = Rails.cache.fetch("match-#{id}") do
      self.get("/fixtures/#{id}").parsed_response
    end
    Match.new(data)
  end


  ["_links", "date", "status", "matchday", "homeTeamName", "awayTeamName", "result", "odds"].each do |attr|
    define_method attr.underscore do
      self.data[attr]
    end
  end

  def home_team
    Team.find team_id("home")
  end

  def away_team
    Team.find team_id("away")
  end

  def home_goals
    self.result["goalsHomeTeam"]
  end

  def away_goals
    self.result["goalsAwayTeam"]
  end

  def draw?
    home_goals == away_goals
  end

  def score
    "#{home_goals} - #{away_goals}"
  end

  def winner
    if draw?
      nil
    elsif home_goals > away_goals
      home_team_name
    else
      away_team_name
    end
  end

  def upset?
    (Table.top_10.include?(home_team_name) || Table.top_10.include?(away_team_name)) &&
        (self.odds["homeWin"] < 0 && winner == home_team_name)
  end

  def watch_score
    @_watch_score ||= begin
      score = 1
      score -= 1 if draw? # -1 for tie game

      score += 1 if home_goals + away_goals > 2  # +1 for high scoring game
      score += 1 if home_goals + away_goals >= 5 # +1 for very high scoring game

      # +1 for two teams in the top 10
      score +=1 if Table.top_10.include?(home_team_name) && Table.top_10.include?(away_team_name)

      # +1 for an upset
      score +=1 if upset?

      score
    end
  end


  private

    def team_id(home_or_away)
      id_from_url(data["_links"][home_or_away + "Team"]["href"])
    end

end