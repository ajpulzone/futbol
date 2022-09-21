require 'rspec'
require './lib/stat_tracker'
require './lib/team'
require './lib/game'
require './lib/game_statistics'
require './lib/team_statistics'
require './lib/team_game'

RSpec.describe StatTracker do
  dummy_filepath1 = {teams: "./data/teams.csv",
                    games: './data/games_dummy1.2.csv',
                    game_teams: './data/game_teams_dummy1.2.csv'
                    }
  dummy_filepath = {teams: './data/teams.csv',
                    games: './data/games_dummy_final.csv',
                    game_teams: './data/game_teams_dummy_final.csv'
                    }
  let(:stat_tracker) {StatTracker.from_csv(dummy_filepath)}
  let(:stat_tracker1) {StatTracker.from_csv(dummy_filepath1)}

  it "1. exists" do
    expect(stat_tracker).to be_a(StatTracker)
  end

  it "2. has readable attributes 'games' and 'teams' that are hashes by" do
    expect(stat_tracker.teams).to be_a(Hash)
    expect(stat_tracker.games).to be_a(Hash)
    
  end
  it "#count_of_teams: returns the total number of teams in the data set" do
    expect(stat_tracker1.count_of_teams).to eq(32)
  end

  it "#best_offense: Name of the team with the highest average number of goals
  scored per game across all seasons" do
    expect(stat_tracker1.best_offense).to eq("Toronto FC")
  end
  
  it "#worst_offense name of the team with the lowest average number of goals
  scored per game across all seasons." do
    expect(stat_tracker1.worst_offense).to eq('Orlando City SC')
  end

  it "#average_goals_per_game returns the average number of goals scored in a
  game across all seasons including both home and away goals (rounded to the
  nearest 100th)" do
    expect(stat_tracker.average_goals_per_game).to eq(3.64)
  end

  it "#average_goals_by_season returns the average number of goals scored in a
  game organized in a hash with season names as keys and a float representing
  the average number of goals in a game for that season as values" do
    result = {
      '20122013' => 3.64,
    }
    expect(stat_tracker.average_goals_by_season).to eq(result)
  end

  it "#total_goals_by_team: returns a hash with team_id as the key, and total
  goals at away or home depending on the argument passed" do
  result = {"6"=>4.0, "3"=>6.0, "5"=>5.0, "30"=> 1.0, "24"=>6.0, "20"=>7.0,
    "21"=>2.0}
    expect(stat_tracker1.total_goals_by_team).to eq(result)
  end
  
  it "#highest_scoring_home_team returns name of the team with the highest
  average score per game across all seasons when they are home." do
    expect(stat_tracker1.highest_scoring_home_team).to eq('Real Salt Lake')
  end

  it "#lowest_scoring_home_team returns name of the team with the lowest
  average score per game across all seasons when they are home." do
  expect(stat_tracker1.lowest_scoring_home_team).to eq('Toronto FC')
  end


  it "#highest_scoring_visitor returns name of the team with the highest
  average score per game across all seasons when they are away." do
  expect(stat_tracker1.highest_scoring_visitor).to eq('Toronto FC')
  end

  it "#lowest_scoring_visitor returns name of the team with the lowest
  average score per game across all seasons when they are away." do
  expect(stat_tracker1.lowest_scoring_visitor).to eq('Sporting Kansas City')
  end

  it "#coach_results" do
    result = {'Claude Julien' => 2, 'Dan Bylsma' => 0, 'John Tortorella' => 0}
    expect(stat_tracker1.coach_results("20122013")).to eq(result)
    result = {'Mike Yeo' => 1, 'Patrick Roy' => 0}
    expect(stat_tracker1.coach_results("20132014")).to eq(result)
  end
  
  it "#games_played_in_season" do
    result = {'Claude Julien' => 2, 'Dan Bylsma' => 1, 'John Tortorella' => 1.0}
    expect(stat_tracker1.games_played_in_season('20122013')).to eq(result)
  end
  
  it "#winningest_coach returns the name of the Coach with the best win 
  percentage for the season" do
    expect(stat_tracker1.winningest_coach('20122013')).to eq('Claude Julien')
    expect(stat_tracker1.winningest_coach('20162017')).to eq('Randy Carlyle')
  end
  
  it "#worst_coach returns the name of the Coach with the worst win 
  percentage for the season" do
    expect(stat_tracker1.worst_coach('20122013')).to eq('John Tortorella')
    expect(stat_tracker1.worst_coach('20162017')).to eq('Glen Gulutzan')
  end
  
  it "#most_accurate_team returns the name of the Team with the best ratio of 
  shots to goals for the season" do
    expect(stat_tracker1.most_accurate_team('20122013')).to eq('Houston Dynamo')
  end
  
  it "#least_accurate_team returns the name of the Team with the worst ratio of 
  shots to goals for the season" do
    expect(stat_tracker1.least_accurate_team('20122013')).to eq('Sporting Kansas City')
  end
  
  it "#most_tackles name of the Team with the most tackles in the season" do
    expect(stat_tracker1.most_tackles('20122013')).to eq('FC Dallas')
  end
  
  it "#fewest_tackles name of the Team with the most tackles in the season" do
    expect(stat_tracker1.fewest_tackles('20122013')).to eq('Sporting Kansas City')
  end

  it "#. highest_total_score" do
    expect(stat_tracker.highest_total_score).to eq(5)
  end

  it "#. lowest_total_score" do
    expect(stat_tracker.lowest_total_score).to eq(1)
  end

  it "#. total_number_of_games" do
    expect(stat_tracker.total_number_of_games).to eq(11)
  end

  it "#. percentage_home_wins" do
    expect(stat_tracker.percentage_home_wins).to eq(0.55)
  end

  it "#. percentage_visitor_wins" do
    expect(stat_tracker.percentage_visitor_wins).to eq(0.45) 
  end

  it "#. percentage_ties" do
    expect(stat_tracker.percentage_ties).to eq(0.00)
  end

  it "#. can calculate average win percentage" do
    expect(stat_tracker.average_win_percentage("17")).to eq(0.5)
  end

  it "#. count_of_games_by_season" do
    expect(stat_tracker.count_of_games_by_season).to eq({"20122013" => 11})
  end

  it "7. can calculate the most goals scored for a team" do
    expect(stat_tracker.most_goals_scored("3")).to eq(2)
  end

  it "8. can calculate the least goals scored for a team" do
    expect(stat_tracker.fewest_goals_scored("3")).to eq(1)
  end

  it "#. games_by_team_by_result" do
    expect(stat_tracker.games_by_team_by_result("3", "WIN")).to eq({"6" => 0})
    expect(stat_tracker.games_by_team_by_result("3", "LOSS")).to eq({"6" => 5})
    expect(stat_tracker.games_by_team_by_result("6", "WIN")).to eq({"3" => 5, "5" => 4})
  end

  it "total_games_by_opponent" do
    expect(stat_tracker.total_games_by_opponent("6")).to eq({"3" => 5, "5" => 4})
  end

  it "finds team name by giving team id" do
    expect(stat_tracker.team_finder("3")).to eq("Houston Dynamo")
  end

  it "#. can determine favorite opponent" do
    expect(stat_tracker.favorite_opponent("6")).to eq("Houston Dynamo")
  end

  it "#. can determine rival" do
    expect(stat_tracker.rival("3")).to eq("FC Dallas")
  end

  it "#. can determine best season for a team" do
    expect(stat_tracker.best_season("6")).to eq("20122013")
  end
  
  it "#. can determine best season for a team" do
    expect(stat_tracker.worst_season("3")).to eq("20122013")
  end

  it "#. can list team info" do
    expect(stat_tracker.team_info("1")).to eq({"team_id" => "1",
    "franchise_id" => "23",
    "team_name" => "Atlanta United",
    "abbreviation" => "ATL",
    "link" => "/api/v1/teams/1"
    })
  end
  
end
