messages <- 
[
    "Use /diepos on to spawn on the position where you got killed.",
    "Use /cmds to see a list of commands.",
    "Advertising is not allowed, please refrain from doing so.",
    "Have a look at the rules by /rules before playing.",
    "Caught a rule breaker? use /report <id> <reason> to notify all admins in game.",
    "Dont use public chat to report rule breakers. /report command is here for a reason!",
    "Press H to request help from your teammates.",
    "Toggle your vehicle's light with 2 key.",
    "Visit Ammu-Nation to buy special weapons!",
    "Use /we <weapon list> to get weapons!",
];

function RandomMessage()
{
    Message(COLOR_ORANGE + "-> "+ messages[Random(0, messages.len() - 1)]);
}

NewTimer( "RandomMessage", 75 * 1000, 0);