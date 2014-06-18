class ConstraintsController < ApplicationController
  def new
    @constraint = Constraint.new();
  end
  def create 
    var = params
    if (var[:function_type]=="all")
      var[:function_type] = -1
    else
      var[:function_type] = FunctionReturnType.find_by_name(params[:function_type])
    end
    var[:function_return_type] = FunctionReturnType.find_by_name(params[:function_type])
    constraint = Constraint.new(display_content: var["display_content"], function_type: var["function_type"],sql_syntax: var["sql_function_name"],function_return_type_id: var["function_return_type"])
    if(constraint.save)
      ans = add_arguments (params)
      ans.each do |key,value|
        Argument.create!(:name => key,:type => FunctionReturnType.find_by_name(value).id , :constraint_id =>constraint.id)
      end
      flash['success'] = "Added"
    else
      flash['error'] = "Error in Form"
    end
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
