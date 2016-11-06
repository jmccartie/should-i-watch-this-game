class Match < Resource

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    data["id"].to_i
  end

  def self.all(days_ago: 3)
    Rails.cache.fetch("matches-", expires_in: 30.minutes) do
      self.get('/fixtures?comps=1&compSeasons=54&page=0&pageSize=40&sort=desc&statuses=C&altIds=true').parsed_response["content"]
    end.map {|f| Match.new(f) }.select {|match| match.finished? && DateTime.parse(match.date) > days_ago.days.ago}
  end

  ["gameweek", "kickoff", "teams", "replay", "ground", "neutralGround", "status", "phase", "outcome", "clock", "goals"].each do |attr|
    define_method attr.underscore do
      self.data[attr]
    end
  end

  def date
    kickoff["label"]
  end

  def finished?
    status == "C"
  end

  def home_team
    @_home_team ||= Team.new(data["teams"].first["team"])
  end

  def away_team
    @_away_team ||= Team.new(data["teams"].last["team"])
  end

  def home_goals
    data["teams"].first["score"].to_i
  end

  def away_goals
    data["teams"].last["score"].to_i
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
      home_team
    else
      away_team
    end
  end

  def close?
    (home_goals-away_goals).abs == 1
  end

  def watch_score
    @_watch_score ||= begin
      score = 1
      score -= 1 if draw? # -1 for tie game

      score += 1 if home_goals + away_goals > 2  # +1 for high scoring game
      score += 1 if home_goals + away_goals >= 5 # +1 for very high scoring game

      # +1 for two teams in the top 10
      score +=1 if Table.top_10.include?(home_team.long_name) && Table.top_10.include?(away_team.long_name)

      score +=1 if close?

      score
    end
  end


end