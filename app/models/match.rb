class Match < Resource

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def self.since(days=3)
    Rails.cache.fetch("standings-#{days}", expires_in: 30.minutes) do
      self.get("/competitions/426/fixtures?timeFrame=p#{days}").parsed_response["fixtures"]
    end.map {|f| Match.new(f) }
  end

  ["_links", "date", "status", "matchday", "homeTeamName", "awayTeamName", "result", "odds"].each do |attr|
    define_method attr.underscore do
      self.data[attr]
    end
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

  def winner
    if draw?
      nil
    elsif home_goals > away_goals
      home_team_name
    else
      away_team_name
    end
  end

  def watch_score
    @_watch_score ||= begin
      score = 1
      score += 1 if home_goals + away_goals > 2  # +1 for high scoring game
      score -= 1 if draw? # -1 for tie game
      score += 1 if home_goals + away_goals > 5 # +1 for very high scoring game

      # +1 for two teams in the top 10
      score +=1 if Table.top_10.include?(home_team_name) && Table.top_10.include?(away_team_name)

      # +1 for an upset
      score +=1 if (Table.top_10.include?(home_team_name) || Table.top_10.include?(away_team_name)) &&
        (self.odds["homeWin"] < 0 && winner == home_team_name)

      score
    end
  end

end