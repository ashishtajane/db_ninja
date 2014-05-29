function hideshow(id)
{
  alert(id)
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
function test(idval)
{
  alert(idval)
}