namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    add_function_return_types
    add_db
    user_pop
    project_pop
    add_collaborators
    add_entity
    add_fields_to_entity
    add_constraints
  end
end


def add_db
  Datatype.create(:name => "INT" , :arg=> 0 ,:function_return_type_id => FunctionReturnType.find_by_name("integer").id)
  Datatype.create(:name => "TINYINT" , :arg=> 0 ,:function_return_type_id => FunctionReturnType.find_by_name("integer").id)
  Datatype.create(:name => "SMALLINT"  , :arg=> 0 ,:function_return_type_id => FunctionReturnType.find_by_name("integer").id)
  Datatype.create(:name => "MEDIUMINT" , :arg=> 0 ,:function_return_type_id => FunctionReturnType.find_by_name("integer").id)
  Datatype.create(:name => "BIGINT" , :arg=> 0 ,:function_return_type_id => FunctionReturnType.find_by_name("integer").id)
  Datatype.create(:name => "DATE" , :arg=> 0 ,:function_return_type_id => FunctionReturnType.find_by_name("date").id)
  Datatype.create(:name => "DATETIME" , :arg=> 0 ,:function_return_type_id => FunctionReturnType.find_by_name("datetime").id)
  Datatype.create(:name => "TIMESTAMP" , :arg=> 0 ,:function_return_type_id => FunctionReturnType.find_by_name("time").id)
  # Datatype.create(:name => "TIME" , :arg=> 0)
  # Datatype.create(:name => "BLOB or TEXT" , :arg=> 0)
  # Datatype.create(:name => "TINYBLOB or TINYTEXT" , :arg=> 0)
  # Datatype.create(:name => "MEDIUMBLOB or MEDIUMTEXT" , :arg=> 0)
  # Datatype.create(:name => "LONGBLOB or LONGTEXT" , :arg=> 0)
  # Datatype.create(:name => "ENUM" , :arg=> 0)

  # Datatype.create(:name => "YEAR" , :arg=> 1)
  Datatype.create(:name => "CHAR" , :arg=> 1 , :function_return_type_id => FunctionReturnType.find_by_name("string").id)
  Datatype.create(:name => "VARCHAR" , :arg=> 1 ,:function_return_type_id => FunctionReturnType.find_by_name("string").id)

  # Datatype.create(:name => "FLOAT" , :arg=> 2)
  # Datatype.create(:name => "DOUBLE" , :arg=> 2)
  Datatype.create(:name => "DECIMAL" , :arg=> 2,:function_return_type_id => FunctionReturnType.find_by_name("integer").id)
end

def user_pop
  password = "password"
  49.times do |n|
    User.create :name => "User#{n}", :email => "user#{n}@example.com", :password => "alfonso#{n}"
  end
end

def project_pop
  counter = 0
  6.times do |user|
    2.times do |project|
      Project.create(:name => "project#{user}#{project}" , :description => "project#{user}#{project} for demo" , :user_id => user+1 , :host =>"100.23.142.12",:adapter => "mysql2" ,:dbusername => "db#{user}#{project}" ,:dbpassword =>"password#{user}#{project}" , :dbname => "name#{user}#{project}")
    end
  end
end


def add_collaborators
  12.times do  |user|
    12.times do |project|
      Collaboration.create(:user_id => user+1 , :project_id => project+1)
    end
  end
end

def add_entity
  12.times do |project|
    project = project + 1
    2.times do
      Entity.create(:project_id => project , :model_name => "model0#{project}",:table_name=>"entity0#{project}")
      Entity.create(:project_id => project , :model_name => "model1#{project}",:table_name=>"entity1#{project}")
    end
  end
end

def find(a,b)
  a + rand(1000000) % (b-a+1)
end

def add_fields_to_entity
  counter = 0
  entities = Entity.all
  entities.each do |entity|
    #begin
    a1= Field.create!(:name => "field#{counter}", :null_value => (rand(2)==1), :default => "dev", :entity_id => entity.id, :type_arg1 =>"" ,:type_arg2 =>"",:datatype_id =>find(1,8))
    counter+=1
    # rescue => e
    #   puts "ERROR: #{e.message}"
    #   debugger
    # end


    # begin
    b1=Field.create!(:name => "field#{counter}", :null_value => (rand(2)==1), :default => "dev", :entity_id => entity.id, :type_arg1 =>"arg1" ,:type_arg2 =>"",:datatype_id =>find(9,10))
    counter+=1
    # rescue => e
    #   puts "ERROR: #{e.message}"
    #   debugger
    # end


    # begin
    c1=Field.create!(:name => "field#{counter}", :null_value => (rand(2)==1), :default => "dev", :entity_id => entity.id, :type_arg1 => "arg1",:type_arg2 =>"arg2",:datatype_id =>find(11,11))
    counter+=1
    #   rescue => e
    #   puts "ERROR: #{e.message}"
    #   debugger
    # end
  end
end

def add_function_return_types
  array=["boolean","integer","string","date","datetime","time"]
  array.each do |a|
    FunctionReturnType.create!(:name => a)
  end
end

def add_constraints
  c=Constraint.create(display_content: "Enter Regular Expression", function_type: -1,sql_syntax: "REGEXP",function_return_type_id: FunctionReturnType.find_by_name("boolean").id)
  c=Constraint.create(display_content: "is less than", function_type: -1,sql_syntax: "<",function_return_type_id: FunctionReturnType.find_by_name("boolean").id)
  c=Constraint.create(display_content: "is less than or equal to", function_type: -1,sql_syntax: "<=",function_return_type_id: FunctionReturnType.find_by_name("boolean").id)
  c=Constraint.create(display_content: "is greater than", function_type: -1,sql_syntax: ">",function_return_type_id: FunctionReturnType.find_by_name("boolean").id)
  c=Constraint.create(display_content: "is greater than or equal to", function_type: -1,sql_syntax: ">=",function_return_type_id: FunctionReturnType.find_by_name("boolean").id)
  c=Constraint.create(display_content: "is equal to", function_type: -1,sql_syntax: "=",function_return_type_id: FunctionReturnType.find_by_name("boolean").id)
  c=Constraint.create(display_content: "is not equal to", function_type: -1,sql_syntax: "!=",function_return_type_id: FunctionReturnType.find_by_name("boolean").id)

  c=Constraint.create(display_content: "get length", function_type: FunctionReturnType.find_by_name("string").id,sql_syntax: "length",function_return_type_id: FunctionReturnType.find_by_name("integer").id)
  c=Constraint.create(display_content: "trim begining and end spaces", function_type: FunctionReturnType.find_by_name("string").id,sql_syntax: "ltrim",function_return_type_id: FunctionReturnType.find_by_name("string").id)

  c=Constraint.create(display_content: "get right x characters", function_type: FunctionReturnType.find_by_name("string").id,sql_syntax: "RIGHT",function_return_type_id: FunctionReturnType.find_by_name("string").id)
  Argument.create!(:name => "length x",:type => FunctionReturnType.find_by_name("integer").id , :constraint_id =>c.id)

  

end