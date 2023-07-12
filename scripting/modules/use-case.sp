static int g_lastDamage[MAXPLAYERS + 1];
static int g_lastHitGroup[MAXPLAYERS + 1];

void UseCase_PlayerHurt(int victim, int attacker, int hitGroup, int damage) {
    if (!Variable_IsPluginEnabled() || hitGroup > HIT_GROUP_RIGHT_LEG || attacker == WORLD) {
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
    if (!Variable_IsPluginEnabled() || g_lastDamage[victim] > 0 || attacker == WORLD) {
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

    if (Cookie_IsShowDamage(victim, MessageSource_Chat)) {
        Message_DamageInfoInChat(victim, attacker, ATTACKER, hitGroup, damage, distance);
    }

    if (Cookie_IsShowDamage(attacker, MessageSource_Chat)) {
        Message_DamageInfoInChat(attacker, victim, TARGET, hitGroup, damage, distance);
    }

    if (Cookie_IsShowDamage(attacker, MessageSource_Screen)) {
        Message_DamageInfoOnScreen(attacker, damage);
    }
}

int UseCase_GetEnemyOrAlly(int client1, int client2) {
    int team1 = GetClientTeam(client1);
    int team2 = GetClientTeam(client2);

    return team1 == team2 ? ALLY : ENEMY;
}
