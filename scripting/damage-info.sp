#include <sourcemod>
#include <clientprefs>

#include "morecolors"

#pragma semicolon 1
#pragma newdecls required

#define HIT_GROUP_RIGHT_LEG 7
#define VECTOR_SIZE 3
#define METERS_PER_UNIT (2.54 / 100)
#define COOKIE_VALUE_MAX_SIZE 4
#define ITEM_INFO_MAX_SIZE 32
#define TEXT_BUFFER_MAX_SIZE (256 * 4)
#define NULL_CHARACTER '\0'

#define SHOW_DAMAGE_IN_CHAT_DEFAULT_VALUE true
#define SHOW_DAMAGE_ON_SCREEN_DEFAULT_VALUE true

#define SHOW_DAMAGE_ENABLED "1"
#define SHOW_DAMAGE_DISABLED "0"

#define MENU_ITEM_IN_CHAT "in_chat"
#define MENU_ITEM_ON_SCREEN "on_screen"

public Plugin myinfo = {
    name = "Damage info",
    author = "Dron-elektron",
    description = "Shows damage information in chat and on screen",
    version = "1.0.0",
    url = ""
}

char g_hitGroups[][] = {
    "Body",
    "Head",
    "Chest",
    "Stomach",
    "Left arm",
    "Right arm",
    "Left leg",
    "Right leg"
};

ConVar g_pluginEnabled = null;

Handle g_cookieShowDamageInChat = null;
Handle g_cookieShowDamageOnScreen = null;

bool g_showDamageInChat[MAXPLAYERS + 1];
bool g_showDamageOnScreen[MAXPLAYERS + 1];

int g_lastDamage[MAXPLAYERS + 1];
int g_lastHitGroup[MAXPLAYERS + 1];

public void OnPluginStart() {
    g_pluginEnabled = CreateConVar("sm_damageinfo_show", "1", "Enable (1) or disable (0) damage information");
    g_cookieShowDamageInChat = RegClientCookie("damageinfo_show_in_chat", "Show damage info in chat", CookieAccess_Private);
    g_cookieShowDamageOnScreen = RegClientCookie("damageinfo_show_on_screen", "Show damage info on screen", CookieAccess_Private);

    SetCookieMenuItem(MenuHandler_ShowDamage, 0, "Show damage info");
    CookiesLateLoad();
    HookEvent("player_hurt", Event_PlayerHurt);
    HookEvent("player_death", Event_PlayerDeath);
    LoadTranslations("damage-info.phrases");
    AutoExecConfig(true, "damage-info");
}

public void OnClientConnected(int client) {
    g_showDamageInChat[client] = SHOW_DAMAGE_IN_CHAT_DEFAULT_VALUE;
    g_showDamageOnScreen[client] = SHOW_DAMAGE_ON_SCREEN_DEFAULT_VALUE;
}

public void OnClientCookiesCached(int client) {
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

void CookiesLateLoad() {
    for (int i = 1; i <= MaxClients; i++) {
        if (AreClientCookiesCached(i)) {
            OnClientCookiesCached(i);
        }
    }
}

public void MenuHandler_ShowDamage(int client, CookieMenuAction action, any info, char[] buffer, int maxlen) {
    if (action == CookieMenuAction_SelectOption) {
        CreateSettingsMenu(client);
    } else {
        Format(buffer, maxlen, "%T", "Show damage", client);
    }
}

public void CreateSettingsMenu(int client) {
    Menu menu = new Menu(MenuHandler_Settings);

    menu.SetTitle("%T", "Show damage", client);

    AddBoolMenuItem(menu, MENU_ITEM_IN_CHAT, "Show damage in chat", client, g_showDamageInChat[client]);
    AddBoolMenuItem(menu, MENU_ITEM_ON_SCREEN, "Show damage on screen", client, g_showDamageOnScreen[client]);

    menu.ExitBackButton = true;
    menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandler_Settings(Menu menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        char info[ITEM_INFO_MAX_SIZE];

        menu.GetItem(param2, info, sizeof(info));

        if (StrEqual(info, MENU_ITEM_IN_CHAT)) {
            SetShowDamageInChat(param1, !g_showDamageInChat[param1]);
        } else if (StrEqual(info, MENU_ITEM_ON_SCREEN)) {
            SetShowDamageOnScreen(param1, !g_showDamageOnScreen[param1]);
        }

        CreateSettingsMenu(param1);
    } else if (action == MenuAction_Cancel) {
        if (param2 == MenuCancel_ExitBack) {
            ShowCookieMenu(param1);
        }
    } else if (action == MenuAction_End) {
        delete menu;
    }

    return 0;
}

void AddBoolMenuItem(Menu menu, char[] info, char[] phrase, int client, bool enabled) {
    char buffer[TEXT_BUFFER_MAX_SIZE];

    Format(buffer, sizeof(buffer), "%T", phrase, client, enabled ? "Enabled" : "Disabled", client);

    menu.AddItem(info, buffer);
}

void SetShowDamageInChat(int client, bool show) {
    SetClientCookie(client, g_cookieShowDamageInChat, show ? SHOW_DAMAGE_ENABLED : SHOW_DAMAGE_DISABLED);

    g_showDamageInChat[client] = show;
}

void SetShowDamageOnScreen(int client, bool show) {
    SetClientCookie(client, g_cookieShowDamageOnScreen, show ? SHOW_DAMAGE_ENABLED : SHOW_DAMAGE_DISABLED);

    g_showDamageOnScreen[client] = show;
}

public void Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast) {
    if (!IsPluginEnabled()) {
        return;
    }

    int hitGroup = event.GetInt("hitgroup");

    if (hitGroup > HIT_GROUP_RIGHT_LEG) {
        return;
    }

    int victimId = event.GetInt("userid");
    int victim = GetClientOfUserId(victimId);
    int attackerId = event.GetInt("attacker");
    int attacker = GetClientOfUserId(attackerId);

    if (victim == 0 || attacker == 0) {
        return;
    }

    if (victim == attacker) {
        return;
    }

    int damage = event.GetInt("damage");

    g_lastDamage[victim] = damage;
    g_lastHitGroup[victim] = hitGroup;

    if (damage == 0) {
        return;
    }

    ShowDamageInfo(victim, attacker);
}

public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast) {
    int victimId = event.GetInt("userid");
    int victim = GetClientOfUserId(victimId);
    int attackerId = event.GetInt("attacker");
    int attacker = GetClientOfUserId(attackerId);

    if (victim == 0 || attacker == 0 || g_lastDamage[victim] > 0) {
        return;
    }

    ShowDamageInfo(victim, attacker);
}

void ShowDamageInfo(int victim, int attacker) {
    float victimPos[VECTOR_SIZE];
    float attackerPos[VECTOR_SIZE];

    GetClientAbsOrigin(victim, victimPos);
    GetClientAbsOrigin(attacker, attackerPos);

    float distance = GetVectorDistance(victimPos, attackerPos, false) * METERS_PER_UNIT;
    int damage = max(g_lastDamage[victim], 1);
    int hitGroup = g_lastHitGroup[victim];

    if (g_showDamageInChat[victim]) {
        PrintDamageInfoInChat(victim, attacker, "Attacker", g_hitGroups[hitGroup], damage, distance);
    }

    if (g_showDamageInChat[attacker]) {
        PrintDamageInfoInChat(attacker, victim, "Target", g_hitGroups[hitGroup], damage, distance);
    }

    if (g_showDamageOnScreen[attacker]) {
        PrintDamageInfoOnScreen(attacker, damage);
    }
}

int max(int a, int b) {
    return a > b ? a : b;
}

void PrintDamageInfoInChat(int victim, int attacker, char[] prefix, char[] hitGroup, int damage, float distance) {
    CPrintToChat(victim, "%t", "Damage info in chat", prefix, attacker, hitGroup, damage, distance);
}

void PrintDamageInfoOnScreen(int attacker, int damage) {
    PrintCenterText(attacker, "%t", "Damage info on screen", damage);
}

bool IsPluginEnabled() {
    return g_pluginEnabled.IntValue == 1;
}
