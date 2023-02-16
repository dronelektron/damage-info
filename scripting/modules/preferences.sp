static Handle g_showDamageCookie[DamageMessage_Size];
static bool g_showDamage[MAXPLAYERS + 1][DamageMessage_Size];

void Preferences_Create() {
    g_showDamageCookie[DamageMessage_Chat] = RegClientCookie("damageinfo_show_in_chat", "Show damage info in chat", CookieAccess_Private);
    g_showDamageCookie[DamageMessage_Screen] = RegClientCookie("damageinfo_show_on_screen", "Show damage info on screen", CookieAccess_Private);
}

void Preferences_Reset(int client) {
    g_showDamage[client][DamageMessage_Chat] = true;
    g_showDamage[client][DamageMessage_Screen] = true;
}

void Preferences_Load(int client) {
    Preferences_LoadCookie(client, DamageMessage_Chat);
    Preferences_LoadCookie(client, DamageMessage_Screen);
}

void Preferences_LoadCookie(int client, DamageMessage damageMessage) {
    char cookieValue[COOKIE_VALUE_SIZE];

    GetClientCookie(client, g_showDamageCookie[damageMessage], cookieValue, sizeof(cookieValue));

    if (cookieValue[0] != NULL_CHARACTER) {
        bool enabled = StrEqual(cookieValue, VALUE_ENABLED);

        g_showDamage[client][damageMessage] = enabled;
    }
}

bool Preferences_IsShowDamage(int client, DamageMessage damageMessage) {
    return g_showDamage[client][damageMessage];
}

void Preferences_ToggleValue(int client, DamageMessage damageMessage) {
    Handle cookie = g_showDamageCookie[damageMessage];

    g_showDamage[client][damageMessage] = !g_showDamage[client][damageMessage];

    SetClientCookie(client, cookie, g_showDamage[client][damageMessage] ? VALUE_ENABLED : VALUE_DISABLED);
}
