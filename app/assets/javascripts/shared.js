function hideshow(idvalue)
{
  alert(idvalue)
  if (idvalue=="1"){
    document.getElementById('arg1').style.display = 'block';
  }
  else if(idvalue=="2"){
    document.getElementById('arg1').style.display = 'block';
    document.getElementById('arg2').style.display = 'block';
  }
  else{
    document.getElementById('arg1').style.display = 'none';
    document.getElementById('arg2').style.display = 'none'; 
  }
}