require 'csv'
require_relative './team'
require_relative './game'
require_relative './league_statistics_module'
require_relative './season_statistics_module'
require_relative './game_statistics'
require_relative './team_statistics'
require_relative './team_game'

class StatTracker
  include LeagueStatistics
  include SeasonStatistics
  include GameStatTracking
  include TeamStatTracking
  
  attr_accessor :games, :teams

  def initialize
    @games = Hash.new(0)
    @teams = Hash.new(0)
  end

  def self.from_csv(locations)
    stat_tracker = new
    team_csv_reader(locations, stat_tracker)
    game_csv_reader(locations, stat_tracker)
    game_teams_csv_reader(locations, stat_tracker)
    consolidate_team_data(stat_tracker)
    stat_tracker
  end

  def self.consolidate_team_data(stat_tracker)
    stat_tracker.games.each do |game_id, game_instance|
      stat_tracker.teams.each do |team_id, team_instance|
        if team_instance.team_games[game_id] != 0 && team_id == game_instance.away_team_id
          team_instance.team_games[game_id].opponent = game_instance.home_team_id
          team_instance.team_games[game_id].goals = game_instance.away_goals
          team_instance.team_games[game_id].result = game_instance.away_team[:result]
        elsif team_instance.team_games[game_id] != 0 && team_id == game_instance.home_team_id
          team_instance.team_games[game_id].opponent = game_instance.away_team_id
          team_instance.team_games[game_id].goals = game_instance.home_goals
          team_instance.team_games[game_id].result = game_instance.home_team[:result]
        end
      end
    end
  end

  def self.game_csv_reader(locations, stat_tracker)
    CSV.foreach locations[:games], headers: true, header_converters: :symbol do |row|
      stat_tracker.games[row[0].to_sym] = Game.new(row)
      stat_tracker.teams.each do |team_id, team_data|
        if team_id == stat_tracker.games[row[0].to_sym].away_team_id || team_id == stat_tracker.games[row[0].to_sym].home_team_id
          team_data.team_games[row[0].to_sym] = TeamGame.new(row)
        end
      end
    end
  end

  def self.game_teams_csv_reader(locations, stat_tracker)
    count = 0
    CSV.foreach locations[:game_teams], headers: true, header_converters: :symbol do |row|
      if count.even?
        stat_tracker.games[row[0].to_sym].import_away_team_data(row)
      elsif count.odd?
        stat_tracker.games[row[0].to_sym].import_home_team_data(row)
      end
      count += 1
    end
  end

  def self.team_csv_reader(locations, stat_tracker)
    CSV.foreach locations[:teams], headers: true, header_converters: :symbol do |row|
      stat_tracker.teams[row[0]] = Team.new(row)
    end
  end
  
end
