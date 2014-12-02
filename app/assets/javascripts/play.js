//Samantha Holloway
//play.js
//Senior Project Nov 2014

//Executed when page is finished loading
$(window).load(function()
{

//    Health bar ideas from http://jsfiddle.net/jessefreeman/mXUEx/
//    Player Health Bar
    var c = document.getElementById("phealthbar");
    var ctx = c.getContext("2d");
    var p_cur_health = parseInt(document.getElementById("p_cur_health").innerHTML);
    var p_max_health = parseInt(document.getElementById("p_max_health").innerHTML);
    var percent = p_cur_health / p_max_health;
    var fill = 300 * percent;
    ctx.fillStyle = "#32cd32";
//    Fill player health bar according to percent health left
    ctx.fillRect(0,0,fill, 150);


//    NPC Health Bar
    var npcc = document.getElementById("npchealthbar");
    var npcctx = npcc.getContext("2d");
    var npc_cur_health = parseInt(document.getElementById("npc_cur_health").innerHTML);
    var npc_max_health = parseInt(document.getElementById("npc_max_health").innerHTML);
    var npcpercent = npc_cur_health / npc_max_health;
    var npcfill = 300 * npcpercent;
    npcctx.fillStyle = "#32cd32";
//    Fill NPC health bar according to percent health left
    npcctx.fillRect(0,0,npcfill, 150);


});

