$(window).load(function()
{

//    Health bar ideas from http://jsfiddle.net/jessefreeman/mXUEx/
    var c = document.getElementById("phealthbar");
    var ctx = c.getContext("2d");
    var p_cur_health = parseInt(document.getElementById("p_cur_health").innerHTML);
    var p_max_health = parseInt(document.getElementById("p_max_health").innerHTML);
    var percent = p_cur_health / p_max_health;
    var fill = 300 * percent;
    ctx.fillStyle = "#32cd32";
    ctx.fillRect(0,0,fill, 150);

    console.log(percent);
    console.log(p_cur_health);
    console.log(p_max_health);
    console.log(200);



    var npcc = document.getElementById("npchealthbar");
    var npcctx = npcc.getContext("2d");
    var npc_cur_health = parseInt(document.getElementById("npc_cur_health").innerHTML);
    var npc_max_health = parseInt(document.getElementById("npc_max_health").innerHTML);
    var npcpercent = npc_cur_health / npc_max_health;
    var npcfill = 300 * npcpercent;
    npcctx.fillStyle = "#32cd32";

    npcctx.fillRect(0,0,npcfill, 150);
    console.log(npc_cur_health);
    console.log(npc_max_health);
    console.log(npcfill);
    console.log(npcpercent);
//    ctx.fillRect(0, 0, (npchealth / 140) * 140, 150);
});

