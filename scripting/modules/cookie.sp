static Handle g_showDamageCookie[MessageSource_Size];
static bool g_showDamage[MAXPLAYERS + 1][MessageSource_Size];

void Cookie_Create() {
    g_showDamageCookie[MessageSource_Chat] = RegClientCookie("damageinfo_show_in_chat", "Show damage info in chat", CookieAccess_Private);
    g_showDamageCookie[MessageSource_Screen] = RegClientCookie("damageinfo_show_on_screen", "Show damage info on screen", CookieAccess_Private);
}

void Cookie_Reset(int client) {
    g_showDamage[client][MessageSource_Chat] = true;
    g_showDamage[client][MessageSource_Screen] = true;
}

void Cookie_Load(int client) {
    Cookie_LoadShowDamage(client, MessageSource_Chat);
    Cookie_LoadShowDamage(client, MessageSource_Screen);
}

void Cookie_LoadShowDamage(int client, MessageSource source) {
    char cookieValue[COOKIE_VALUE_SIZE];

    GetClientCookie(client, g_showDamageCookie[source], cookieValue, sizeof(cookieValue));

    if (cookieValue[0] != NULL_CHARACTER) {
        bool showDamage = StrEqual(cookieValue, VALUE_ENABLED);

        g_showDamage[client][source] = showDamage;
    }
}

bool Cookie_ShowDamage(int client, MessageSource source) {
    return g_showDamage[client][source];
}

void Cookie_ToggleValue(int client, MessageSource source) {
    Handle cookie = g_showDamageCookie[source];

    g_showDamage[client][source] = !g_showDamage[client][source];

    SetClientCookie(client, cookie, g_showDamage[client][source] ? VALUE_ENABLED : VALUE_DISABLED);
}
