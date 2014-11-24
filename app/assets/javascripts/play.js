$(window).load(function()
{

//    Health bar ideas from http://jsfiddle.net/jessefreeman/mXUEx/
    var c = document.getElementById("charhealthbar");
    var ctx = c.getContext("2d");
    var health = 50;
    var maxhealth = 300;
    ctx.fillStyle = "#32cd32";

    ctx.fillRect(0,0,health, 150);


    var npcc = document.getElementById("npchealthbar");
    var npcctx = npcc.getContext("2d");
    var npchealth = 50;
    var npcmaxhealth = 300;
    npcctx.fillStyle = "#32cd32";

    npcctx.fillRect(0,0,npchealth, 150);
    console.log(health);
//    ctx.fillRect(0, 0, (npchealth / 140) * 140, 150);
});

