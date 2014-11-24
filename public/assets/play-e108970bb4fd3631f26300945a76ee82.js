$(window).load(function()
{
    var c = document.getElementById("charhealthbar");
    var ctx = c.getContext("2d");
    var health = 5;
    ctx.fillStyle = "#FF0000";
    ctx.fillRect(0, 0, (health / 100) * 140, 25);
});

