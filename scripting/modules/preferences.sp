static Handle g_cookieShowDamageInChat = null;
static Handle g_cookieShowDamageOnScreen = null;

static bool g_showDamageInChat[MAXPLAYERS + 1];
static bool g_showDamageOnScreen[MAXPLAYERS + 1];

void Preferences_Create() {
    g_cookieShowDamageInChat = RegClientCookie("damageinfo_show_in_chat", "Show damage info in chat", CookieAccess_Private);
    g_cookieShowDamageOnScreen = RegClientCookie("damageinfo_show_on_screen", "Show damage info on screen", CookieAccess_Private);
}

void Preferences_Reset(int client) {
    g_showDamageInChat[client] = SHOW_DAMAGE_IN_CHAT_DEFAULT_VALUE;
    g_showDamageOnScreen[client] = SHOW_DAMAGE_ON_SCREEN_DEFAULT_VALUE;
}

void Preferences_Refresh(int client) {
    char cookieValue[COOKIE_VALUE_MAX_SIZE];

    GetClientCookie(client, g_cookieShowDamageInChat, cookieValue, sizeof(cookieValue));

    if (cookieValue[0] != NULL_CHARACTER) {
        g_showDamageInChat[client] = view_as<bool>(StringToInt(cookieValue));
    } else {
        g_showDamageInChat[client] = SHOW_DAMAGE_IN_CHAT_DEFAULT_VALUE;
    }

    GetClientCookie(client, g_cookieShowDamageOnScreen, cookieValue, sizeof(cookieValue));

    if (cookieValue[0] != NULL_CHARACTER) {
        g_showDamageOnScreen[client] = view_as<bool>(StringToInt(cookieValue));
    } else {
        g_showDamageOnScreen[client] = SHOW_DAMAGE_ON_SCREEN_DEFAULT_VALUE;
    }
}

bool Preferences_IsShowDamageInChat(int client) {
    return g_showDamageInChat[client];
}

void Preferences_ToggleShowDamageInChat(int client) {
    g_showDamageInChat[client] = !g_showDamageInChat[client];

    SetClientCookie(client, g_cookieShowDamageInChat, g_showDamageInChat[client] ? SHOW_DAMAGE_ENABLED : SHOW_DAMAGE_DISABLED);
}

bool Preferences_IsShowDamageOnScreen(int client) {
    return g_showDamageOnScreen[client];
}

void Preferences_ToggleShowDamageOnScreen(int client) {
    g_showDamageOnScreen[client] = !g_showDamageOnScreen[client];

    SetClientCookie(client, g_cookieShowDamageOnScreen, g_showDamageOnScreen[client] ? SHOW_DAMAGE_ENABLED : SHOW_DAMAGE_DISABLED);
}
