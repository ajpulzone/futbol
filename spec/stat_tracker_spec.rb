require "rspec"
require './lib/stat_tracker'
require "./lib/team"
require './lib/game'

RSpec.describe StatTracker do
  let(:stat_tracker) {StatTracker.new}
  dummy_filepath = {teams: "./data/teams.csv",
                    games: './data/games_dummy1.2.csv',
                    game_teams: './data/game_teams_dummy1.2.csv'

  }
  let(:stat_tracker1) {StatTracker.from_csv(dummy_filepath)}

  it "1. exists" do
    expect(stat_tracker).to be_a(StatTracker)
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

  it "#total_goals_by_team_by_at returns hash with each team as a key
  and total goals for the argument passed as values" do
  home = {'6' => 4.0, '24' => 3.0, '20' => 0.0, '5' => 5.0, '21' => 2.0}
  expect(stat_tracker1.total_goals_by_team_by_at('home')).to eq(home)

  away = {'3' => 6.0, '5' => 0.0, '20' => 7.0, '24' => 3.0, '30' => 1.0}
  expect(stat_tracker1.total_goals_by_team_by_at('away')).to eq(away)
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

end
