static int g_lastDamage[MAXPLAYERS + 1];
static int g_lastHitGroup[MAXPLAYERS + 1];

void UseCase_PlayerHurt(int victim, int attacker, int hitGroup, int damage) {
    if (!Variable_IsPluginEnabled() || hitGroup > HIT_GROUP_RIGHT_LEG || attacker == 0) {
        return;
    }

    g_lastDamage[victim] = damage;
    g_lastHitGroup[victim] = hitGroup;

    if (damage == 0) {
        return;
    }

    UseCase_ShowDamageInfo(victim, attacker);
}

void UseCase_PlayerDeath(int victim, int attacker) {
    if (!Variable_IsPluginEnabled() || g_lastDamage[victim] > 0 || attacker == 0) {
        return;
    }

    UseCase_ShowDamageInfo(victim, attacker);
}

void UseCase_ShowDamageInfo(int victim, int attacker) {
    if (victim == attacker) {
        return;
    }

    float distance = Math_CalculateDistance(victim, attacker);
    int damage = Math_Max(g_lastDamage[victim], 1);
    int hitGroup = g_lastHitGroup[victim];

    if (Preferences_IsShowDamageInChat(victim)) {
        Message_DamageInfoInChat(victim, attacker, "Attacker", hitGroup, damage, distance);
    }

    if (Preferences_IsShowDamageInChat(attacker)) {
        Message_DamageInfoInChat(attacker, victim, "Target", hitGroup, damage, distance);
    }

    if (Preferences_IsShowDamageOnScreen(attacker)) {
        Message_DamageInfoOnScreen(attacker, damage);
    }
}
