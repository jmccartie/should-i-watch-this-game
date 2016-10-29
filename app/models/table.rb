class Table < Resource

  def self.all
    Rails.cache.fetch("table", expires_in: 30.minutes) do
      resp = HTTParty.get("https://www.premierleague.com/tables")
      page = Nokogiri::HTML(resp)

      items = []
      page.css("table tbody tr").each do |row|
        begin
          items << {
            position: row.css("td")[1].css("span.value").text,
            movement: row.css("td")[1].css("span")[1].attributes["class"].value,
            team_name: row.css("td")[2].css("span")[1].text,
            crest_css: row.css("td")[2].css("span").first.attributes["class"].value,
            played: row.css("td")[3].text,
            wins: row.css("td")[4].text,
            draws: row.css("td")[5].text,
            losses: row.css("td")[6].text,
            goal_difference: row.css("td")[9].text.strip,
            points: row.css("td")[10].text

          }
        rescue Exception => e
          p "ERROR on row"
        end
      end
      items
    end
  end

  # returns array of team names
  def self.top_10
    self.all.slice(0, 10).map {|t| t["team_name"] }
  end

end