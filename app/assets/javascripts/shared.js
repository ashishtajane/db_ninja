function hideshow(id)
{
  //alert($(this).find('option:selected').text());
  if(id==undefined){
  }
  else if (id=="1"){
    document.getElementById('arg1').style.display = 'block';
    document.getElementById('arg2').style.display = 'none';
  }
  else if(id=="2"){
    document.getElementById('arg1').style.display = 'block';
    document.getElementById('arg2').style.display = 'block';
  }
  else{
    document.getElementById('arg1').style.display = 'none';
    document.getElementById('arg2').style.display = 'none'; 
  }
}

function string_manipulation(p,s)
{
  var newid=s.split("_");
  newid[p]= String(Number(newid[p])+1);
  s=newid[0];
  for (i=1;i<newid.length;i++)
  s= s+"_"+newid[i];
  return s;
}

ready = function(){


  $("#type_name").bind('click', function() {
    //alert($('#type_name').children(":selected").attr('value'));    
    //alert($(this).attr('data-arg'))
    hideshow($('#type_name').children(":selected").attr('data-arg'));
  });


  $("#type_name").bind('focusout', function() {
    //alert($('#type_name').children(":selected").attr('value'));
    hideshow($('#type_name').children(":selected").attr('data-arg'));
  });

  hideshow($('#type_name').children(":selected").attr('data-arg'));

 
  var remove_field_function = function(){
    console.log('Remove Field Function')
    $(this).parent().remove();
    console.log('Exiting Remove Function')
    bind_functions();
  }

  var remove_entity_function = function(){
    console.log('Remove Entity Function');
    $(this).parent().remove();
    console.log('Exiting Remove Function')
    bind_functions();
  }

  var plus_function = function(){
    //alert("Heel")
    console.log("plus_function")
    var curr= $(this);
    $(this).attr("disabled",true);
    var to_add=$(this).parent().clone();
    var first_select_tag = to_add.children('select:eq(0)');

    first_select_tag.attr("id",string_manipulation(3,first_select_tag.attr("id")));
    first_select_tag.attr("name",string_manipulation(3,first_select_tag.attr("name")));
    var constraint_div = to_add.find('.Constraints') ; 
    constraint_div.find('.check_blank').remove();
    constraint_div.attr('id',string_manipulation(2,constraint_div.attr('id')))
    to_add.attr("id",string_manipulation(2,to_add.attr("id")));
    $(this).parent().after(to_add);
    //curr.attr("class","remove_property"); 
    //curr.text('Remove');
    //$(this).parent().append('<button type="button" class="remove_property">Remove</button>')

    $(this).parent().find('.Constraints').before('<button type="button" class="remove_property">Remove</button>');
    // alert("Plus Function")
    //$('<button type="button" class="remove_property">Remove</button>').insertBefore();
    curr.remove();
    console.log("exiting plus_function")
    bind_functions();
  }

  var enable_function = function(evt){
    console.log("Enable Function") ;
    if($(this).parent().children('button:eq(0)').attr('class')=="add_property"){
      if($(this).val()!==""){
        //console.log($(this).parent().children('button:eq(0)').text())
        $(this).parent().children('button:eq(0)').removeAttr('disabled');
      //   alert("hey")
      }
      else{
        console.log("hi")
        $(this).parent().children('button:eq(0)').attr("disabled",true);
      }
    }
    console.log("Exiting Enable Function") ;

    //AJAX PART HERE
    if($(this).val()==""){
      alert("Enable Function")
      $(this).parent().find('.Constraints').find('.check_blank').remove();
      console.log("Empty Selected")
      $(this).parent().find('.field_above').remove();
      // $(this).find('field_above')
    }
    else{
      $.ajax({
        url: "/projects/"+ $("#query_form").data("id") + "/constraints_load",
        type: "POST",
        data: { "field_selected": $(this).find(":selected").data("arg") , "entity_counter": $(this).attr("name").split('_')[2], "field_counter": $(this).attr("name").split('_')[3]},
        success: function (data) { 
            //alert("succes")
            // $(that).parent().find('.entity_above').show();
            bind_functions();
          },
        error: function (data ) { 
          alert("error");
        }
      });
      console.log("Non Empty Selected")
    }

    bind_functions();
    //$(".property_dropdown").change(enable_function());    
  };

  var display_arguments_and_next_cons=function(){

    $(this).nextAll().remove()
    $(this).parent().nextAll().remove()

    if($(this).val()==""){
      console.log("Empty Selected")  
      //$(this).parent().find('.field_above').remove();
      // $(this).find('field_above')
    }
    else{
      $.ajax({
        url: "/projects/"+ $("#query_form").data("id") + "/arguments_load",
        type: "POST",
        data: { "constraint_selected": $(this).find(":selected").data("id") , "entity_counter": $(this).attr("name").split('_')[1], "field_counter": $(this).attr("name").split('_')[2],"constraint_counter": $(this).attr("name").split('_')[3],"return_value_above": $(this).find(":selected").data("retrurn-type")},
        success: function (data) { 
            //alert("succes")
            // $(that).parent().find('.entity_above').show();
            bind_functions();
          },
        error: function (data ) { 
          alert("error");
        }
      });
    }
    bind_functions();
  };


  

  var add_entity_function  = function(){
    console.log("Add Entity Function");
    var add = $(this).parent().clone();
    add.find('.Properties').remove();
    add.attr('id',string_manipulation(1,add.attr('id')));
    var sel_option= add.find('.model_select');
    sel_option.attr('name',string_manipulation(2,sel_option.attr('name')));
    sel_option.attr('id',string_manipulation(2,sel_option.attr('id')));
    add.find('.add_entity').attr("disabled",true);
    var div_option=add.find('.entity_above');
    div_option.attr('id',string_manipulation(2,div_option.attr('id')));
    $(this).parent().after(add);
    $(this).parent().find('.model_select').after('<button type="button" class="remove_entity">Remove</button>');
    $(this).remove();
    console.log("Exiting Entity Function");
    bind_functions();  
  }

  var select_model_change_field_function = function( ){
    console.log("Model Change Function");
    //console.log($(this).attr("name").split('_')[2]);
    if($(this).find(":selected").val()==""){
      $(this).parent().find('.entity_above').hide();
      $(this).parent().find('.add_entity').attr("disabled",true);
      //write the binding function
    }
    else{
      $(this).parent().find('.add_entity').removeAttr('disabled');
      var that = this;
      $.ajax({
        url: "/projects/"+ $("#query_form").data("id") + "/query_div",
        type: "POST",
        data: { "entity_selected": $(this).find(":selected").data("arg") , "entity_counter": $(this).attr("name").split('_')[2]},
        success: function (data) { 
            $(that).parent().find('.entity_above').show();
            bind_functions();
          },
        error: function (data ) { 
          alert("error");
        }
      });
    }
    console.log("Exiting Model select Function");
    bind_functions();
  }

  var add_argument_function = function(){

    var add = $(this).parent().find('.argument').last().clone()
    //console.log(add.attr('id'));
    add.attr('id',string_manipulation(2,add.attr('id')));
    var name = add.find('.arg_name');
    name.attr('name',string_manipulation(2,name.attr('name')))

    //console.log(name.attr('name'))

    var select = add.find('.arg_select');
    select.attr('name',string_manipulation(2,select.attr('name')))
    add.show()
    $(".add_arguments").before(add);
    bind_functions();
  }

  var show_fields_and_unhide_Entities = function(){

    $(".Entities").show();
    if($(this).val()==""){
      $(".function_field").remove();
      $(".Entities").hide();
    }
    else{
      var that = this;
      $.ajax({
        url: "/projects/"+ $("#query_form").data("id") + "/load_function_field_div",
        type: "POST",
        data: { "entity_selected": $(this).find(":selected").data("arg") },
        success: function (data) { 
            bind_functions();
          },
        error: function (data ) { 
          alert("error");
        }
      });
    }
    bind_functions();

  }

  var bind_functions = function(){

    $(".add_property").off("click").on("click", plus_function);;
    $(".remove_property").off("click").on("click", remove_field_function);
    $(".property_dropdown").off("change").on("change",enable_function);
    $(".model_select").off("change").on("change" , select_model_change_field_function);
    $(".add_entity").off("click").on("click",add_entity_function);
    $(".remove_entity").off("click").on("click",remove_entity_function);
    $(".add_arguments").off("click").on("click",add_argument_function);
    $(".field_above").off("change").on("change",display_arguments_and_next_cons);
    $(".Function_Model").off("change").on("change",show_fields_and_unhide_Entities)
    $( ".Datepicker" ).datepicker({dateFormat:'yy-mm-dd'});
    // $(".property_dropdown_cons").off("change").on("change",change_constraints_function);
    //$(".add_property").on("click", plus_function);
    //$(".remove_property").on("click", remove_function);
    //$(".property_dropdown").on("change",enable_function);
    //$("#model_select").on("change" , select_model_change_field_function);
    //$(".add_entity").on("click",add_entity_function)
  }



  bind_functions();


  //.change(enable_function);

  /*

  $(".remove_property").on("click",remove_function);*/

}
$(document).ready(ready)
$(document).on('page:load', ready)