namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    add_db
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