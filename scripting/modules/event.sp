void Event_Create() {
    HookEvent("player_hurt", Event_PlayerHurt);
    HookEvent("player_death", Event_PlayerDeath);
}

public void Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast) {
    int victimId = event.GetInt("userid");
    int victim = GetClientOfUserId(victimId);
    int attackerId = event.GetInt("attacker");
    int attacker = GetClientOfUserId(attackerId);
    int hitGroup = event.GetInt("hitgroup");
    int damage = event.GetInt("damage");

    UseCase_PlayerHurt(victim, attacker, hitGroup, damage);
}

public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast) {
    int victimId = event.GetInt("userid");
    int victim = GetClientOfUserId(victimId);
    int attackerId = event.GetInt("attacker");
    int attacker = GetClientOfUserId(attackerId);

    UseCase_PlayerDeath(victim, attacker);
}
