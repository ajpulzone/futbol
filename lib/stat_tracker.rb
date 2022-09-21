require "csv"
require_relative './team'
require_relative './game'
require_relative './league_statistics_module'
require_relative './season_statistics_module'

class StatTracker
  include LeagueStatistics
  include SeasonStatistics

  attr_accessor :games, :teams

  def initialize
    @games = Hash.new(0)
    @teams = Hash.new(0)
  end

  def self.from_csv(locations)
    stat_tracker = new
    game_csv_reader(locations, stat_tracker)
    game_teams_csv_reader(locations, stat_tracker)
    team_csv_reader(locations, stat_tracker)
    stat_tracker
  end

  def self.game_csv_reader(locations, stat_tracker)
    CSV.foreach locations[:games], headers: true, header_converters: :symbol do |row|
      stat_tracker.games[row[0].to_sym] = Game.new(row)
    end
  end

  def self.game_teams_csv_reader(locations, stat_tracker)
    count = 0
    CSV.foreach locations[:game_teams], headers: true, header_converters: :symbol do |row|
      if count.even?
        stat_tracker.games[row[0].to_sym].import_away_team_data(row)
      else count.odd?
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
