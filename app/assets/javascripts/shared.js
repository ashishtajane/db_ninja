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

  var change_graph_ajax_call = function(event){
    var parent = $(this).parent();
    var selected = parent.find("#operation");
    var input1 = parent.find("#graph1")
    var input2 = parent.find("#graph2")
    console.log(input1.val());
    console.log(selected.val());
    
    if ( selected.val()=="0" ){
      event.preventDefault();
      alert("You need to select some condition before executing")
    }
    else if ((selected.val()=="1" || selected.val()=="2") && input1.val()==""){
      event.preventDefault();
      alert("Please fill the input box to move further")
    }
    else if( selected.val()=="3"  && (input1.val()=="" || input2.val()=="")){
        event.preventDefault();
        alert("please fill both the input boxes")
    }
    else{
      //AJAX Call
      //alert("Moving to Ajax :D")
      // $.ajax({
      //   url: "/projects/"+ $("#project_id").val() + "/modify_graph",
      //   type: "POST",
      //   data: { "graph_data": $("#making_graph").val() ,"operation": $("#operation").val() , "graph1": $("#graph1").val(), "graph2": $("#graph2").val()}
      // });
      //$('#change_graph').unbind('click');
    }

    bind_functions(); 
  }

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
    var parameter = add.find(".Selection") ;
    parameter.attr('name',string_manipulation(1,parameter.attr('name')));
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
    $(".function_field").remove();
    if($(this).val()==""){
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
  var enable_disable_button = function(){
    var parent = $(this).parent()
    var id = $(this).attr('id')
    var counter = id.split('_')[1]
    var select1_value = parent.find("#join_"+counter).val()
    var select2_value = parent.find("#relate_"+counter).val()
    if(select1_value != "" && select2_value != "" ){
      parent.find(".join_add").removeAttr('disabled');
    }
    else{
      parent.find(".join_add").attr("disabled",true); 
    }
    bind_functions();
  }

  var add_join = function(){
    var to_add = $(this).parent().clone();
    var idval = to_add.attr('id')
    var counter = idval.split("_")[2]

    to_add.attr('id',string_manipulation(2,"join_div_"+counter));

    to_add.find("#join_"+counter).attr('name', string_manipulation(2,"join_tag_"+counter));
    to_add.find("#join_"+counter).attr('id', string_manipulation(1,"join_"+counter));

    to_add.find("#relate_"+counter).attr('name', string_manipulation(2,"relation_tag_"+counter));
    to_add.find("#relate_"+counter).attr('id', string_manipulation(1,"relate_"+counter));

    to_add.find(".join_add").attr("disabled",true);

    $(this).parent().after(to_add);
    var button = "<button class=\"remove_join\" type=\"button\"  >Remove</button>";
    $(this).replaceWith(button)
    bind_functions();

  }

  var add_select = function(){
    var to_add = $(this).parent().clone();
    var idval = to_add.attr('id')
    var counter = idval.split("_")[2]
    
    to_add.attr('id',string_manipulation(2,"join_div_"+counter)); 

    to_add.find("#select_"+counter).attr('name', string_manipulation(2,"select_tag_"+counter));
    to_add.find("#select_"+counter).attr('id', string_manipulation(1,"select_"+counter)); 
    to_add.find(".select_add").attr("disabled",true);

    $(this).parent().after(to_add);
    var button = "<button class=\"remove_select\" type=\"button\"  >Remove</button>";
    $(this).replaceWith(button)
    bind_functions();
  }

  var remove_join = function(){
    $(this).parent().remove()
    bind_functions();
  }

  var remove_select = function(){
    $(this).parent().remove()
    bind_functions(); 
  }

  var enable_select_plus = function(){
    var parent = $(this).parent()
    var id = $(this).attr('id')
    var counter = id.split('_')[1]
    var select_value = parent.find("#select_"+counter).val()
    if ( select_value != "" ){
      parent.find(".select_add").removeAttr('disabled');
    }
    else{
      parent.find(".select_add").attr("disabled",true);  
    }
    bind_functions();
  }

  var enable_graph_function = function(){
    var parent =  $(this).parent();
    var selected_value = parseInt($(this).val())
    if ( selected_value == 0 ){
      parent.find("#graph1").attr("disabled",true);
      parent.find("#graph2").attr("disabled",true);
    }
    else if (selected_value == 1 || selected_value == 2){
      parent.find("#graph1").removeAttr("disabled");
      parent.find("#graph2").attr("disabled",true);   
    }
    else{
      parent.find("#graph1").removeAttr("disabled");
      parent.find("#graph2").removeAttr("disabled");
    }
    bind_functions();
  }

  var get_mean = function(arr){
    //console.log(arr)
    var count = arr.length; 
    var sum = 0; 
    for (i=0 ;i<count;i++){
      sum = sum + arr[i]
    }
    var total = sum / count;
    return total;
  }

  var get_median = function(arr){
    arr.sort(); 
    var middle =Math.round(arr.length / 2); 
    var total = arr[middle-1];
    return total;
  }

  var get_mode = function(arr){
    var frequency = {};  // array of frequency.
    var max = 0;  // holds the max frequency.
    var result;   // holds the max frequency element.
    for(var v in arr) {
      frequency[arr[v]]=(frequency[arr[v]] || 0)+1; // increment frequency.
      if(frequency[arr[v]] > max) { // is this frequency > max so far ?
        max = frequency[arr[v]];  // update max.
        result = arr[v];          // update result.
      }
    }
    return result;
  }

  var get_height = function(arr){
    arr = arr.split('*&^%$#!@');
    var height=[];
    for (i = 0; i < arr.length; i++) {
      bucket = arr[i].split('!@#~%$@#!');
      //console.log(bucket)
      height.push(parseInt(bucket[bucket.length-1]));
    }
    //console.log(height)
    return height;
  }

  var get_mean_median_mode = function(){
    var selected = $(this).val()
    var parent = $(this).parent()
    //console.log(selected)
    var arr = parent.find("#making_graph").val()
    arr = get_height(arr)
    console.log(arr)
    if(selected == "1"){
      parent.find("#mmm").val(get_mean(arr))
    }
    else if(selected == "2"){
      parent.find("#mmm").val(get_median(arr))
    }
    else{
      parent.find("#mmm").val(get_mode(arr)) 
    }
    bind_functions()
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
    $(".Join").off("change").on("change",enable_disable_button);
    $(".join_add").off("click").on("click",add_join);
    $(".remove_join").off("click").on("click",remove_join);
    $(".Select").off("change").on("click",enable_select_plus);
    $(".select_add").off("click").on("click",add_select);
    $(".remove_select").off("click").on("click",remove_select);
    $("#operation").off("change").on("change",enable_graph_function);
    $(".change_graph").off("click").on("click",change_graph_ajax_call);
    $(".mean_median").off("change").on("change",get_mean_median_mode);
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