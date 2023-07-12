static Handle g_showDamageCookie[MessageSource_Size];
static bool g_showDamage[MAXPLAYERS + 1][MessageSource_Size];

void Cookie_Create() {
    g_showDamageCookie[MessageSource_Chat] = RegClientCookie("damageinfo_show_in_chat", "Show damage info in chat", CookieAccess_Private);
    g_showDamageCookie[MessageSource_Screen] = RegClientCookie("damageinfo_show_on_screen", "Show damage info on screen", CookieAccess_Private);
}

void Cookie_Load(int client) {
    Cookie_LoadShowDamage(client, MessageSource_Chat);
    Cookie_LoadShowDamage(client, MessageSource_Screen);
}

void Cookie_LoadShowDamage(int client, MessageSource source) {
    char showDamage[COOKIE_VALUE_SIZE];

    GetClientCookie(client, g_showDamageCookie[source], showDamage, sizeof(showDamage));

    if (showDamage[0] == NULL_CHARACTER) {
        Cookie_SetShowDamage(client, source, COOKIE_VALUE_ENABLED);
    } else {
        Cookie_UpdateShowDamage(client, source, showDamage);
    }
}

bool Cookie_IsShowDamage(int client, MessageSource source) {
    return g_showDamage[client][source];
}

void Cookie_ToggleValue(int client, MessageSource source) {
    bool showDamage = !Cookie_IsShowDamage(client, source);

    Cookie_SetShowDamage(client, source, showDamage ? COOKIE_VALUE_ENABLED : COOKIE_VALUE_DISABLED);
}

static void Cookie_SetShowDamage(int client, MessageSource source, const char[] showDamage) {
    Handle cookie = g_showDamageCookie[source];

    SetClientCookie(client, cookie, showDamage);
    Cookie_UpdateShowDamage(client, source, showDamage);
}

static void Cookie_UpdateShowDamage(int client, MessageSource source, const char[] showDamage) {
    g_showDamage[client][source] = StrEqual(showDamage, COOKIE_VALUE_ENABLED);
}
