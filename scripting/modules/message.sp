static char g_enemyOrAlly[][] = {
    "Enemy",
    "Ally"
};

static char g_targetOrAttacker[][] = {
    "Target",
    "Attacker"
};

static char g_hitGroups[][] = {
    "Body",
    "Head",
    "Chest",
    "Stomach",
    "Left arm",
    "Right arm",
    "Left leg",
    "Right leg"
};

void Message_DamageInfoInChat(int client1, int client2, int targetOrAttacker, int hitGroup, int damage, float distance) {
    int enemyOrAlly = UseCase_GetEnemyOrAlly(client1, client2);

    PrintToChat(client1, COLOR_DEFAULT ... "%t", "Damage info in chat",
        g_enemyOrAlly[enemyOrAlly],
        g_targetOrAttacker[targetOrAttacker],
        client2,
        g_hitGroups[hitGroup],
        damage,
        distance
    );
}

void Message_DamageInfoOnScreen(int attacker, int damage) {
    PrintCenterText(attacker, "%t", "Damage info on screen", damage);
}
