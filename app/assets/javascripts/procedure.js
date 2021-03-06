var hideShowParents = function() 
{
  var currentId = $(this).attr('id');
  var select = "#" + currentId.replace("check","select");
  var classification = "#" + currentId.replace("check","classification");
  var swaittime = "#" + currentId.replace("check","swaittime");
  var cwaittime = "#" + currentId.replace("check","cwaittime");
  
  if ( $(this).is(":checked") )
  {
    //we have indicated that this area of practice belongs to this specializatios, so let us pick a parent and type
    $(select).show();
    $(classification).show();
    $(swaittime).show();
    $(cwaittime).show();
  }
  else
  {
    //we have indicated that this area of practice does not belong to this specialization, so hide parents and type
    $(select).hide();
    $(classification).hide();
    $(swaittime).hide();
    $(cwaittime).hide();
  }
}

$(".aop_active").live("change", hideShowParents );