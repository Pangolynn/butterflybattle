//Samantha Holloway Senior Project Oct 2014
//creation.js
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

function statChange(statPic) {
    if (document.getElementById("Strength")) {
        document.getElementById("Strength").setAttribute("id", statPic);
    }
    else if (document.getElementById("Defense")) {
        document.getElementById("Defense").setAttribute("id", statPic);
    }
    else if (document.getElementById("Speed")) {
        document.getElementById("Speed").setAttribute("id", statPic);
    }
    else
        document.getElementById("Stamina").setAttribute("id", statPic);

}


;
