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

void Message_DamageInfoInChat(int victim, int attacker, char[] prefix, int hitGroup, int damage, float distance) {
    CPrintToChat(victim, "%t", "Damage info in chat", prefix, attacker, g_hitGroups[hitGroup], damage, distance);
}

void Message_DamageInfoOnScreen(int attacker, int damage) {
    PrintCenterText(attacker, "%t", "Damage info on screen", damage);
}
