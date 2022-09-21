module LeagueStatistics

  def count_of_teams
    @teams.size
  end

  def best_offense
    teams_hash = total_goals_by_team
    teams_hash.update(teams_hash) do |team_id, total_goals|
      total_goals / ((games.values.find_all {|game| game.away_team_id == team_id.to_s}).count +
      (games.values.find_all {|game| game.home_team_id == team_id.to_s}).count)
    end
    best_offense_team_id = teams_hash.key(teams_hash.values.max)
    teams[best_offense_team_id].team_name
  end

  def worst_offense
    teams_hash = total_goals_by_team
    teams_hash.update(teams_hash) do |team_id, total_goals|
      total_goals / ((games.values.find_all {|game| game.away_team_id == team_id.to_s}).count +
      (games.values.find_all {|game| game.home_team_id == team_id.to_s}).count)
    end
    best_offense_team_id = teams_hash.key(teams_hash.values.min)
    teams[best_offense_team_id].team_name
  end

  def total_goals_by_team
    teams_hash = Hash.new(0.0)
    teams.keys.each do |team|
      games.values.each do |game|
        teams_hash[team] += game.away_goals if game.away_team_id == team.to_s
        teams_hash[team] += game.home_goals if game.home_team_id == team.to_s
      end
    end
    teams_hash
  end
  
  def total_goals_by_team_by_at(at)
    teams_hash = Hash.new(0.0)
    @teams.keys.each do |team|
      @games.each do |game, game_object|
        teams_hash[team] += game_object.home_goals if at == 'home' && game_object.home_team_id == team
        teams_hash[team] += game_object.away_goals if at == 'away' && game_object.away_team_id == team
      end
    end
    teams_hash
  end
  
  def highest_scoring_home_team
    teams_hash = total_goals_by_team_by_at('home')
    teams_hash.update(teams_hash) do |team_id, goals|
      goals / @games.select {|game_id, game_object| team_id == game_object.home_team_id}.count
    end
    highest_scoring_home_team_id = teams_hash.key(teams_hash.values.max)
    @teams[highest_scoring_home_team_id].team_name
  end
  
  def lowest_scoring_home_team
    teams_hash = total_goals_by_team_by_at('home')
    teams_hash.update(teams_hash) do |team_id, goals|
      goals / @games.select {|game_id, game_object| team_id == game_object.home_team_id}.count
    end
    lowest_scoring_home_team_id = teams_hash.key(teams_hash.values.min)
    @teams[lowest_scoring_home_team_id].team_name
  end
  
  def highest_scoring_visitor
    teams_hash = total_goals_by_team_by_at('away')
    teams_hash.update(teams_hash) do |team_id, goals|
      goals / @games.select {|game_id, game_object| team_id == game_object.away_team_id}.count
    end
    highest_scoring_away_team_id = teams_hash.key(teams_hash.values.max)
    @teams[highest_scoring_away_team_id].team_name
  end
  
  def lowest_scoring_visitor
    teams_hash = total_goals_by_team_by_at('away')
    teams_hash.update(teams_hash) do |team_id, goals|
      goals / @games.select {|game_id, game_object| team_id == game_object.away_team_id}.count
    end
    lowest_scoring_away_team_id = teams_hash.key(teams_hash.values.min)
    @teams[lowest_scoring_away_team_id].team_name
  end
end





















