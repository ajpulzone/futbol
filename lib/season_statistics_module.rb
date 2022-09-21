module SeasonStatistics
  
  def coaches_by_season(season)
    coaches_array = []
    @games.each do |game_id, game_object|
      if game_object.season == season
        coaches_array << game_object.home_team[:head_coach]
        coaches_array << game_object.away_team[:head_coach]
      end
    end
    coaches_hash = Hash.new
    coaches_array.uniq.each do |coach|
      coaches_hash[coach] = 0
    end
    coaches_hash
  end
  
  def coach_results(season)
    coach_wins_hash = coaches_by_season(season) #Hash.new { |hash, key| hash[key] = 0.0 }
    @games.each do |game_id, game|
      if game.season == season
        coach_wins_hash[game.home_team[:head_coach]] += 1 if game.home_team[:result] == "WIN"
        coach_wins_hash[game.away_team[:head_coach]] += 1 if game.away_team[:result] == "WIN"
      end
    end
    coach_wins_hash
  end
  
  def games_played_in_season(season)
    team_games_hash = Hash.new { |hash, key| hash[key] = 0.0 }
    @games.each do |game_id, game|
      if game.season == season
        team_games_hash[game.home_team[:head_coach]] += 1
        team_games_hash[game.away_team[:head_coach]] += 1
      end
    end
    team_games_hash
  end
  
  def winningest_coach(season)
    team_wins_hash = coach_results(season)
    team_games_hash = games_played_in_season(season)
    team_wins_hash.merge!(team_games_hash) do |team_id, wins, games|
      wins / games
    end
    winning_team_id = team_wins_hash.key(team_wins_hash.values.max)
  end
  
  def worst_coach(season)
    team_wins_hash = coach_results(season)
    team_games_hash = games_played_in_season(season)
    team_wins_hash.merge!(team_games_hash) do |team_id, wins, games|
      wins / games
    end
    losing_team_id = team_wins_hash.key(team_wins_hash.values.min)
  end
  
  def total_shots_by_team_season(season)
    shots_by_team = Hash.new(0.0)
    @games.each do |game_id, game_object|
      if game_object.season == season
        shots_by_team[game_object.home_team_id] += game_object.home_team[:shots]
        shots_by_team[game_object.away_team_id] += game_object.away_team[:shots]
      end
    end
    shots_by_team
  end
  
  def goals_by_team(season)
    goals_by_team = Hash.new(0.0)
    @games.each do |game_id, game_object|
      if game_object.season == season
        goals_by_team[game_object.home_team_id] += game_object.home_goals
        goals_by_team[game_object.away_team_id] += game_object.away_goals
      end
    end
    goals_by_team
  end
  
  def most_accurate_team(season)
    shots_by_team = total_shots_by_team_season(season)
    goals_by_team = goals_by_team(season)
    goals_by_team.merge!(shots_by_team) do |team_id, goals, shots|
      goals / shots
    end
    winning_team_id = goals_by_team.key(goals_by_team.values.max)
    winning_team = @teams.find  {|team_id, team_object| team_id == winning_team_id}
    winning_team.last.team_name
  end
  
  def least_accurate_team(season)
    shots_by_team = total_shots_by_team_season(season)
    goals_by_team = goals_by_team(season)
    goals_by_team.merge!(shots_by_team) do |team_id, goals, shots|
      goals / shots
    end
    losing_team_id = goals_by_team.key(goals_by_team.values.min)
    losing_team = @teams.find  {|team_id, team_object| team_id == losing_team_id}
    losing_team.last.team_name
  end
  
  def most_tackles(season)
    tackles_by_team = Hash.new(0)
    @games.each do |game_id, game_object|
      if game_object.season == season
        tackles_by_team[game_object.home_team_id] += game_object.home_team[:tackles]
        tackles_by_team[game_object.away_team_id] += game_object.away_team[:tackles]
      end
    end
    most_tackles_team_id = tackles_by_team.key(tackles_by_team.values.max)
    most_tackles_team = @teams.find  {|team_id, team_object| team_id == most_tackles_team_id}
    most_tackles_team.last.team_name
  end
  
  def fewest_tackles(season)
    tackles_by_team = Hash.new(0)
    @games.each do |game_id, game_object|
      if game_object.season == season
        tackles_by_team[game_object.home_team_id] += game_object.home_team[:tackles]
        tackles_by_team[game_object.away_team_id] += game_object.away_team[:tackles]
      end
    end
    fewest_tackles_team_id = tackles_by_team.key(tackles_by_team.values.min)
    fewest_tackles_team = @teams.find  {|team_id, team_object| team_id == fewest_tackles_team_id}
    fewest_tackles_team.last.team_name
  end
end













