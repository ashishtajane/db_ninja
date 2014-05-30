namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    add_db
    user_pop
    project_pop
    add_collaborators
    add_entity
    add_fields_to_entity
  end
end


def add_db
  Datatype.create(:name => "INT" , :arg=> 0)
  Datatype.create(:name => "TINYINT" , :arg=> 0)
  Datatype.create(:name => "SMALLINT"  , :arg=> 0)
  Datatype.create(:name => "MEDIUMINT" , :arg=> 0)
  Datatype.create(:name => "BIGINT" , :arg=> 0)
  Datatype.create(:name => "DATE" , :arg=> 0)
  Datatype.create(:name => "DATETIME" , :arg=> 0)
  Datatype.create(:name => "TIMESTAMP" , :arg=> 0)
  Datatype.create(:name => "TIME" , :arg=> 0)
  Datatype.create(:name => "BLOB or TEXT" , :arg=> 0)
  Datatype.create(:name => "TINYBLOB or TINYTEXT" , :arg=> 0)
  Datatype.create(:name => "MEDIUMBLOB or MEDIUMTEXT" , :arg=> 0)
  Datatype.create(:name => "LONGBLOB or LONGTEXT" , :arg=> 0)
  Datatype.create(:name => "ENUM" , :arg=> 0)

  Datatype.create(:name => "YEAR" , :arg=> 1)
  Datatype.create(:name => "CHAR" , :arg=> 1)
  Datatype.create(:name => "VARCHAR" , :arg=> 1)

  Datatype.create(:name => "FLOAT" , :arg=> 2)
  Datatype.create(:name => "DOUBLE" , :arg=> 2)
  Datatype.create(:name => "DECIMAL" , :arg=> 2)
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
    a1= Field.create!(:name => "#{counter}", :null_value => (rand(2)==1), :default => "dev", :entity_id => entity.id, :type_arg1 =>"" ,:type_arg2 =>"",:datatype_id =>find(1,14))
    counter+=1
    # rescue => e
    #   puts "ERROR: #{e.message}"
    #   debugger
    # end


    # begin
    b1=Field.create!(:name => "#{counter}", :null_value => (rand(2)==1), :default => "dev", :entity_id => entity.id, :type_arg1 =>"arg1" ,:type_arg2 =>"",:datatype_id =>find(15,17))
    counter+=1
    # rescue => e
    #   puts "ERROR: #{e.message}"
    #   debugger
    # end


    # begin
    c1=Field.create!(:name => "#{counter}", :null_value => (rand(2)==1), :default => "dev", :entity_id => entity.id, :type_arg1 => "arg1",:type_arg2 =>"arg2",:datatype_id =>find(18,20))
    counter+=1
    #   rescue => e
    #   puts "ERROR: #{e.message}"
    #   debugger
    # end
  end
end