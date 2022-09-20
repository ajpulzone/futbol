module LeagueStatistics

  def count_of_teams
    @teams.size.to_s
  end

  def best_offense
    teams_hash = total_goals_by_team
    teams_hash.update(teams_hash) do |team_id, total_goals|
      total_goals / ((games.values.find_all {|game| game.away_team[:team_id] == team_id.to_s}).count +
      (games.values.find_all {|game| game.home_team[:team_id] == team_id.to_s}).count)
    end
    best_offense_team_id = teams_hash.key(teams_hash.values.max).to_sym
    teams[best_offense_team_id].team_name
  end

  def total_goals_by_team
    teams_hash = Hash.new(0.0)
    teams.keys.each do |team|
      games.values.each do |game|
        if game.away_team[:team_id] == team.to_s
          teams_hash[team] += game.away_goals
        elsif game.home_team[:team_id] == team.to_s
          teams_hash[team] += game.home_goals
        end
      end
    end
    teams_hash
  end


end
