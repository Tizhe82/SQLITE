require 'csv'

# The main class with all the methods. Select, order, insert and run.
class MySqliteRequest
  def initialize
    @table_name = nil
    @request = nil
    return self    
  end

  def values(data)
    if @predata != nil
      @data = two_arrays_to_hash(@predata, data)
    else
      @data = data
    end
    return self
  end
  def set(data)
    @data = data
    return self
  end

  def from(table_name)
    @table_name = table_name
    return self
  end
  # Class method if user forgets to use .new method.
  def self.from(table_name)
    request = MySqliteRequest.new
    request.from(table_name)
  end

  def where(column, value)
    if @where == nil
      @where = {column=>value}
    else
      @where.merge!({column=>value})
    end
    return self
  end

  def join(column_on_db_a, filename_db_b, column_on_db_b)
    @join = {column_a: column_on_db_a, column_b: column_on_db_b}
    @filename_to_join = filename_db_b
    return self
  end
# Helper for the "join" request, called for "select" in "run".  
  def combine_tables
    hashed_csv_a = csv_to_hash(@table_name)
    hashed_csv_b = csv_to_hash(@filename_to_join)
    hashed_csv_b.each do |row|
      rule = {@join[:column_a] => row[@join[:column_b]]}
      row.delete(@join[:column_b])
      update_function(hashed_csv_a, rule, row)
    end
    return hashed_csv_a
  end

  def order(order, column_name)
    @order_request = {order: order, column_name: column_name}
    return self
  end

# "Requests" section.

  def insert(*args)
    @request = 'insert'
    @table_name = args[0]
    if args[1] != nil
      @predata = args[1]
    end
    return self
  end
  def self.insert(table_name)
    request = MySqliteRequest.new
    request.insert(table_name)
  end

  def update(table_name)
    @request = 'update'
    @table_name = table_name
    return self
  end
  def self.update(table_name)
    request = MySqliteRequest.new
    request.update(table_name)
  end

  def select(*columns)
    @request = 'select'
    @columns = columns
    return self
  end

  def delete
    @request = 'delete'
    return self
  end

# The final, "run" request. 
  def run
    if @table_name != nil
      hashed_csv = csv_to_hash(@table_name)
    else
      puts "Please, gimme table."
      return
    end
    
    if @order_request != nil
      hashed_csv = order_function(hashed_csv, @order_request[:order], @order_request[:column_name])
    end

    if @request == 'insert'
      if @data != nil
        hashed_csv = insert_function(hashed_csv, @data)
      end
      write_to_file(hashed_csv, @table_name)
    end

    if @request == 'update'
      hashed_csv = update_function(hashed_csv, @where, @data)
      write_to_file(hashed_csv, @table_name)
    end
  
    if @request == 'select'
      if @join != nil
        hashed_csv = combine_tables
      end
      if @order_request != nil
        hashed_csv = order_function(hashed_csv, @order_request[:order], @order_request[:column_name])
      end
      if @where != nil
        hashed_csv = where_function(hashed_csv, @where)
      end
      if @columns != nil && @table_name != nil
        result = select_function(hashed_csv, @columns)
        return result
      else
        puts "Please, gimme columns."
        return
      end
    end

    if @request == 'delete'
      hashed_csv = delete_function(hashed_csv, @where)
      write_to_file(hashed_csv, @table_name)
    end

# Setting instance variables to zero after the run.
    @predata = nil
    @data = nil
    @join = nil
    @where = nil
    @request = nil
    @table_name = nil
  end
end

# Helper functions section.

# Helper of the "run" method fot the "insert" request.
# Appends a new row to the database.
def insert_function(hashes, new_hash)
  result = []
  hashes.each do |row|
    result.push(row)
  end
  result.push(new_hash)
  return result
end

# Helper of the "run" method fot the "where" request.
# Returns rows where certain columns are set to a certain value.
def where_function(hashes, rules)
  result = []
  hashes.each do |row|
    if check_rule(row, rules)
      result << row
    end
  end
  return result
end

# Helper of the "run" method fot the "update" request.
# Goes down the list, changes the values of the columns defined by the rule
# to the ones in the update_hash. 
# Returns the updated database.
def update_function(hashes, rule, update_hash)
  result = []
  hashes.each do |row|
    if check_rule(row, rule)
      updated_row = blend(row, update_hash)
      result << updated_row
    else
      result << row
    end
  end 
  return result
end

# Helper of the "run" method fot the "select" request.
# Creates a new array of hashes skipping the ones defined
# by the rule.
def delete_function(hashes, rule)
  result = []
  if rule != nil
    hashes.each do |row|
      if check_rule(row, rule)
        next
      else
        result << row
      end
    end
  end
  return result
end

# Helper of the "run" method fot the "select" request.
# Picks specific columns from the hashes, puts them in an array and 
# returns the resulting list.
def select_function(hashes, columns)
  if !hashes
    return
  else
    result = []
    hashes.each do |hash|
      new_hash = {}
      if columns[0] == "*"  # Shorthand for "all columns".
        result << hash
      else 
        columns.each do |column|
          new_hash[column] = hash[column]
        end
        result << new_hash
      end
    end
    return result
  end
end

# Helper of the "run" method fot the "order" request.
# Goes down the lisr of hashes, compares and swaps the values according to
# the symbol of the direction variable.
# Returns ordered database.
def order_function(hashes, direction, column)
  #p hashes
  #p direction
  #p column
  0.upto hashes.length - 1 do |i|
    i.upto hashes.length - 1 do |j|
      row_i = hashes[i]
      row_j = hashes[j]
      value_i = row_i[column]
      value_j = row_j[column]
      if direction == :asc
        if value_i > value_j
          swap = hashes[i]
          hashes[i] = hashes[j]
          hashes[j] = swap
        end
      elsif direction == :desc
        if value_i < value_j
          swap = hashes[i]
          hashes[i] = hashes[j]
          hashes[j] = swap
        end
      end
    end
  end
  return hashes
end

# Reads database from a file to memory. Creates empty database if file
# doesn't exist.
def csv_to_hash(name)
  if(!File.exist?(name))
    hashes = CSV.open(name, "w+", headers: true).map(&:to_hash)
  else
    hashes = CSV.open(name, "r+", headers: true).map(&:to_hash)
  end
  return hashes
end

# Saves database to the persistent memory.
# Deals with VALUES with no keys.
def write_to_file(hashes, name)
  CSV.open(name, "w", :headers => true) do |csv|
    if hashes.length == 0
      return
    end
    if hashes[0].class == Hash
      csv << hashes[0].keys
    end
    hashes.each do |hash|
      if hash.class == Hash
        csv << CSV::Row.new(hash.keys, hash.values)
      else        
        csv << hash
      end
    end
  end
end

# Used by "update", "where" and "delete" to select columns from a row
# according to a rule.
def check_rule(row, rules)
  if rules == nil
    return true
  end
  flag = 0  # False flag.
  rules.each do |key, value|
    if value != row[key]
      flag = 1
    end
  end
  if flag == 0
    return true
  end
  return false
end

# Used by "update" to inmix the new values.
def blend(row, update_hash)
  update_hash.each do |key, value|
    row[key] = value
  end
  return row           
end

# Used by "values" to append columns from "insert into".
def two_arrays_to_hash(arr_1, arr_2)
  result = Hash.new
  i = 0
  while i < arr_1.length 
    result[arr_1[i]] = arr_2[i] 
    i += 1
  end
  return result
end

