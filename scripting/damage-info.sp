#include <sourcemod>
#include <clientprefs>

#include "morecolors"

#pragma semicolon 1
#pragma newdecls required

#include "di/math"
#include "di/menu"
#include "di/preferences"
#include "di/use-case"

#include "modules/console-variable.sp"
#include "modules/math.sp"
#include "modules/menu.sp"
#include "modules/message.sp"
#include "modules/preferences.sp"
#include "modules/use-case.sp"

public Plugin myinfo = {
    name = "Damage info",
    author = "Dron-elektron",
    description = "Shows damage information in chat and on screen",
    version = "1.0.6",
    url = "https://github.com/dronelektron/damage-info"
};

public void OnPluginStart() {
    Variable_Create();
    Preferences_Create();
    Menu_AddToPreferences();
    CookiesLateLoad();
    HookEvent("player_hurt", Event_PlayerHurt);
    HookEvent("player_death", Event_PlayerDeath);
    LoadTranslations("damage-info.phrases");
    AutoExecConfig(true, "damage-info");
}

public void OnClientConnected(int client) {
    Preferences_Reset(client);
}

public void OnClientCookiesCached(int client) {
    Preferences_Refresh(client);
}

public void Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast) {
    int victimId = event.GetInt("userid");
    int victim = GetClientOfUserId(victimId);
    int attackerId = event.GetInt("attacker");
    int attacker = GetClientOfUserId(attackerId);
    int hitGroup = event.GetInt("hitgroup");
    int damage = event.GetInt("damage");

    UseCase_PlayerHurt(victim, attacker, hitGroup, damage);
}

public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast) {
    int victimId = event.GetInt("userid");
    int victim = GetClientOfUserId(victimId);
    int attackerId = event.GetInt("attacker");
    int attacker = GetClientOfUserId(attackerId);

    UseCase_PlayerDeath(victim, attacker);
}

void CookiesLateLoad() {
    for (int i = 1; i <= MaxClients; i++) {
        if (AreClientCookiesCached(i)) {
            OnClientCookiesCached(i);
        }
    }
}
