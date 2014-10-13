//Change id to switch css styling for sprite sheet
//So butterfly pics will change to corresponding radio buttons
function pictureChange(pic) {
    if (document.getElementById("redPicButterfly")) {
        document.getElementById("redPicButterfly").setAttribute("id", pic);
    }
    else if (document.getElementById("purplePicButterfly")) {
        document.getElementById("purplePicButterfly").setAttribute("id", pic);
    }
    else {
        document.getElementById("blackPicButterfly").setAttribute("id", pic);
    }
}
//Display correct tooltip for corresponding ability
function changeToolTip(ability, category) {
    var abilities = document.querySelectorAll(category);

    for (var i = 0; i < abilities.length; i++) {
        abilities[i].style.display = "none";
    }
    document.getElementById(ability).style.display = "inline-block";
}

//Collect selected creation choices when user hits submit
function submitData(){
        console.log($("input:checked").val() + " is checked!" );

    //redirect to play page
}