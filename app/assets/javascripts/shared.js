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

 
  var remove_function = function(){
    $(this).parent().remove();
    $(".remove_property").on("click", remove_function); 
  }

  var plus_function = function(){
    var curr= $(this);
    $(this).attr("disabled",true);
    var to_add=$(this).parent().clone();
    var first_select_tag = to_add.children('select:eq(0)');

    first_select_tag.attr("id",string_manipulation(3,first_select_tag.attr("id")));
    first_select_tag.attr("name",string_manipulation(3,first_select_tag.attr("name")));

    to_add.attr("id",string_manipulation(2,to_add.attr("id")));
    $(this).parent().after(to_add);
    //curr.attr("class","remove_property"); 
    //curr.text('Remove');
    $(this).parent().append('<button type="button" class="remove_property">Remove</button>')
    curr.remove();
    $(".add_property").on("click", plus_function);
    $(".remove_property").on("click", remove_function);
    $(".property_dropdown").on("change",enable_function);
  }

  var enable_function = function(evt){
    //console.log($(this).val()) ;
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
    //$(".property_dropdown").change(enable_function());    
  };

  $(".add_property").on("click",plus_function);

  var test_function = function( ){
    //console.log($(this).attr("name").split('_')[2]);
    $.ajax({
        url: "/projects/"+ $("#query_form").data("id") + "/query_div",
        type: "POST",
        data: { "entity_selected": $(this).find(":selected").data("arg") , "counter_value": $(this).attr("name").split('_')[2]},
        success: function (data) { 
            // append data to your page
           // console.log(data);
            //alert(data);
            $(".add_property").on("click", plus_function);
            $(".remove_property").on("click", remove_function);
            $(".property_dropdown").on("change",enable_function);
          },
           error: function (data , textStatus) { 
            // append data to your page
                      alert("error");

            console.log(textStatus);
          }
    });

  }

  $(".property_dropdown").on("click", enable_function);
  $("#model_select").on("change" , test_function);

  
  //.change(enable_function);

  /*

  $(".remove_property").on("click",remove_function);*/

}
$(document).ready(ready)
$(document).on('page:load', ready)