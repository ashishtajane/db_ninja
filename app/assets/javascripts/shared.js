function hideshow(id)
{
  //alert($(this).find('option:selected').text());
  if (id=="1"){
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

}
$(document).ready(ready)
$(document).on('page:load', ready)