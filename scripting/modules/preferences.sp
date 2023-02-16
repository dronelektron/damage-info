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

void Preferences_Load(int client) {
    Preferences_LoadCookie(client, g_cookieShowDamageInChat, g_showDamageInChat);
    Preferences_LoadCookie(client, g_cookieShowDamageOnScreen, g_showDamageOnScreen);
}

void Preferences_LoadCookie(int client, Handle cookie, bool[] value) {
    char cookieValue[COOKIE_VALUE_SIZE];

    GetClientCookie(client, cookie, cookieValue, sizeof(cookieValue));

    if (cookieValue[0] != NULL_CHARACTER) {
        value[client] = StrEqual(cookieValue, VALUE_ENABLED);
    }
}

bool Preferences_IsShowDamageInChat(int client) {
    return g_showDamageInChat[client];
}

void Preferences_ToggleShowDamageInChat(int client) {
    Preferences_ToggleCookieValue(client, g_cookieShowDamageInChat, g_showDamageInChat);
}

bool Preferences_IsShowDamageOnScreen(int client) {
    return g_showDamageOnScreen[client];
}

void Preferences_ToggleShowDamageOnScreen(int client) {
    Preferences_ToggleCookieValue(client, g_cookieShowDamageOnScreen, g_showDamageOnScreen);
}

void Preferences_ToggleCookieValue(int client, Handle cookie, bool[] value) {
    value[client] = !value[client];

    SetClientCookie(client, cookie, value[client] ? VALUE_ENABLED : VALUE_DISABLED);
}
