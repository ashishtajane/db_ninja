class ConstraintsController < ApplicationController
  def new
    @constraint = Constraint.new();
  end
  def create 
    constraint = Constraint.create!(display_content: params["display_content"], function_type: params["function_type"],sql_syntax: params["sql_function_name"],function_return_type_id: params["function_return_type"])
    ans = add_arguments (params)
    ans.each do |key,value|
      Argument.create!(:name => key,:type => FunctionReturnType.find_by_name(value).id , :constraint_id =>constraint.id)
    end
    flash['success'] = "Added"
    redirect_to new_constraint_path
  end

  private 
    def add_arguments(a)
      ans={}
      b = a.select{ |x,y| x.include? "arg_name"}
      puts b
      b.map{ 
        | key , val| 
        if (val!="")
          ans[val] = a["argument_type_#{key.split('_').last}"]
        end
      }
    return ans
    end
end
