function pictureChange(e){document.getElementById("redPicButterfly")?document.getElementById("redPicButterfly").setAttribute("id",e):document.getElementById("purplePicButterfly")?document.getElementById("purplePicButterfly").setAttribute("id",e):document.getElementById("blackPicButterfly").setAttribute("id",e)}function changeToolTip(e,t){for(var l=document.querySelectorAll(t),n=0;n<l.length;n++)l[n].style.display="none";document.getElementById(e).style.display="inline-block"}function submitData(){console.log($("input:checked").val()+" is checked!")}