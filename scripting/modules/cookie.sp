static Handle g_showDamageCookie[DamageMessage_Size];
static bool g_showDamage[MAXPLAYERS + 1][DamageMessage_Size];

void Cookie_Create() {
    g_showDamageCookie[DamageMessage_Chat] = RegClientCookie("damageinfo_show_in_chat", "Show damage info in chat", CookieAccess_Private);
    g_showDamageCookie[DamageMessage_Screen] = RegClientCookie("damageinfo_show_on_screen", "Show damage info on screen", CookieAccess_Private);
}

void Cookie_Reset(int client) {
    g_showDamage[client][DamageMessage_Chat] = true;
    g_showDamage[client][DamageMessage_Screen] = true;
}

void Cookie_Load(int client) {
    Cookie_LoadShowDamage(client, DamageMessage_Chat);
    Cookie_LoadShowDamage(client, DamageMessage_Screen);
}

void Cookie_LoadShowDamage(int client, DamageMessage damageMessage) {
    char cookieValue[COOKIE_VALUE_SIZE];

    GetClientCookie(client, g_showDamageCookie[damageMessage], cookieValue, sizeof(cookieValue));

    if (cookieValue[0] != NULL_CHARACTER) {
        bool showDamage = StrEqual(cookieValue, VALUE_ENABLED);

        g_showDamage[client][damageMessage] = showDamage;
    }
}

bool Cookie_ShowDamage(int client, DamageMessage damageMessage) {
    return g_showDamage[client][damageMessage];
}

void Cookie_ToggleValue(int client, DamageMessage damageMessage) {
    Handle cookie = g_showDamageCookie[damageMessage];

    g_showDamage[client][damageMessage] = !g_showDamage[client][damageMessage];

    SetClientCookie(client, cookie, g_showDamage[client][damageMessage] ? VALUE_ENABLED : VALUE_DISABLED);
}
