require_relative 'my_sqlite_request'

def question_1
  request = MySqliteRequest.new
  request = request.from('nba_player_data.csv')
  request = request.select('name')
  request = request.run
  p request
end

def question_2
  request = MySqliteRequest.new
  request = request.from('nba_player_data.csv')
  request = request.select('name')
  request = request.where('college', 'University of California')
  request = request.run
  p request
end

def question_3
  request = MySqliteRequest.new
  request = request.from('nba_player_data.csv')
  request = request.select('name')
  request = request.where('college', 'University of California')
  request = request.where('year_start', '1997')
  request = request.run
  p request
end

def question_4
  request = MySqliteRequest.new
  request = request.insert('nba_player_data.csv')
  request = request.values('name' => 'Alaa Abdelnaby', 'year_start' => '1991', 'year_end' => '1995', 'position' => 'F-C', 'height' => '6-10', 'weight' => '240', 'birth_date' => "June 24, 1968", 'college' => 'Duke University')
  request.run
  request = MySqliteRequest.new
  request = request.from('nba_player_data.csv')
  request = request.select('*')
  request = request.where('name', 'Alaa Abdelnaby')
  request = request.run
  p request
end

def question_5
  request = MySqliteRequest.new
  request = request.update('nba_player_data.csv')
  request = request.values('name' => 'Alaa Renamed')
  request = request.where('name', 'Alaa Abdelnaby')
  request.run
  request = MySqliteRequest.new
  request = request.from('nba_player_data.csv')
  request = request.select('*')
  request = request.where('name', 'Alaa Renamed')
  request = request.run
  p request
end

def question_6
  request = MySqliteRequest.new
  request = request.delete()
  request = request.from('nba_player_data.csv')
  request = request.where('name', 'Alaa Abdelnaby')
  request.run
  request = MySqliteRequest.new
  request = request.from('nba_player_data.csv')
  request = request.select('*')
  request = request.where('name', 'Alaa Abdelnaby')
  request = request.run
  p request
end

def question_7
  execute_request("SELECT * FROM students")
end

