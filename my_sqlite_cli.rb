require 'readline'
require_relative "my_sqlite_request"


def my_readline
  line = Readline.readline('my_sqlite_cli> ', true)
  return line
end

# Calls the respective class methods. Conforms to the method input formats.
def process_command(command, args, request)
  case command
  when "from"
    if args.length != 1
      puts "Example: FROM db.csv"
      return
    else
      request.from(*args)
    end
  when "select"
    if args.length < 1 || args[0].include?(",")
      puts "Example: SELECT name, age"
      return
    else
      request.select(*args)
    end
  when "insert"
    args = args[0].split(" ").drop(1) # Removes "INTO" .
    # Conforms columns for @predata.
    if args[1] != nil
      if args[1].include?(")") == false
        puts "Example: (name,age)"
      end
      args[1] = args[1].delete_prefix("(").chomp(")").split(",")
    end
    request.insert(*args)
  when "values"
    if args.length < 1
    puts "Provide data to insert. Example: (Bob, 30)"
    else
      # Conforms values for @data.
      args = args.join(" ").delete_prefix("(").chomp(")")
      args = args.split(",").map(&:strip)
      if args[0].include?(",")
        puts "Example: (Bob, 30)"
      end
      request.values(args)
    end
  when "delete"
    if args.length != 0
      puts "Example: DELETE FROM db.csv. Don't forget to use WHERE."
    else
      request.delete 
    end
  when "where"
    if args.length != 3
      puts "Example: WHERE age = '20'"
    else
      value = args[2].delete_prefix("'").chomp("'")
      request.where(args[0], value)
    end
  when "order"
    if args.length != 2
      puts "Example: ORDER age ASC"
    else
      col_name = args[0]
      sort_type = args[1].downcase.to_sym
      request.order(sort_type, col_name)
    end
  when "join"
    if args.length != 3
      puts "Example: JOIN table ON col_a=col_b"
    elsif args[1].upcase != "ON"
      puts "Provide ON statement. Example: JOIN table ON col_a=col_b"
      return
    else
      table = args[0]
      col_a, col_b = args[2].split("=")
      request.join(col_a, table, col_b)
    end
  when "update"
    if args.length != 1
      puts "Example: UPDATE db.csv"
    else
      request.update(*args)
    end
  when "set"
    if args.length < 1
      puts "Example: SET name=BOB. Use WHERE - otherwise WATCH OUT."
    else
      request.set(set_to_hash(args)) 
    end
  else
    puts "Please follow the syntax."
    puts "If you want to quit - type quit."
  end
end

# Splits the sql string, checks whether it contains commands from the
# valid_commands array and feeds the chunks to the process_command function.
def execute_request(sql)
  valid_commands = ["SELECT", "FROM", "JOIN", "WHERE", "ORDER", "INSERT", "VALUES", "UPDATE", "SET", "DELETE"]
  command = nil
  args = Array.new
  request = MySqliteRequest.new
  split_command = sql.split(" ")
  0.upto split_command.length - 1 do |arg|
    if valid_commands.include?(split_command[arg].upcase())
      if (command != nil) 
        if command != "join"
          args = args.join(" ").split(", ")
        end
        process_command(command, args, request)
        command = nil
        args = []
      end
      command = split_command[arg].downcase()
    else
      args << split_command[arg]
    end
  end
  if args[-1].end_with?(";")
    args[-1] = args[-1].chomp(";")
  end
  process_command(command, args, request)
  result = request.run
  print_select(result)
end

# Prints the result of SELECT statement.
def print_select(result)
  if !result
    return
  end
  if result.length == 0
    puts "No result."
  else
    header = result.first.keys.join('|') 
    puts header
    puts "-" * header.length
    result.each do | line |
      puts line.values.join('|')
    end
  end
end

# Conforms the arr to the SET methods format.
def set_to_hash(arr)
  result = Hash.new
  i = 0
  while i < arr.length 
    left, right = arr[i].split(" = ")
    result[left] = right.delete_prefix("'").chomp("'")
    i += 1
  end
  return result
end

def cli
  puts "MySQLite version 1.0 2023"
  while command = my_readline
    if command == 'quit'
      break
    elsif command == ''
      next
    else
      execute_request(command)
    end
  end
end

# Peer review questions.

# question_1()
# question_2()
# question_3()
# question_4()
# question_5()
# question_6()
# question_7()
cli()


