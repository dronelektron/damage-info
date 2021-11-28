#include <sourcemod>

#include "morecolors"

#pragma semicolon 1
#pragma newdecls required

#define HIT_GROUP_RIGHT_LEG 7
#define COLOR_MAX_LENGTH 16
#define WEAPON_NAME_MAX_LENGTH 32
#define VECTOR_SIZE 3
#define METERS_PER_UNIT (2.54 / 100)

public Plugin myinfo = {
    name = "Damage info",
    author = "Dron-elektron",
    description = "Shows damage information in chat",
    version = "0.1.0",
    url = ""
}

enum {
    Team_Allies = 2,
    Team_Axis
};

char g_teamColor[][] = {
    "{allies}",
    "{axis}"
};

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

public void OnPluginStart() {
    g_pluginEnabled = CreateConVar("sm_damageinfo_show", "1", "Enable (1) or disable (0) damage information");

    HookEvent("player_hurt", Event_PlayerHurt);
    LoadTranslations("damage-info.phrases");
    AutoExecConfig(true, "damage-info");
}

public Action Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast) {
    if (!IsPluginEnabled()) {
        return Plugin_Handled;
    }

    int hitGroup = event.GetInt("hitgroup");

    if (hitGroup > HIT_GROUP_RIGHT_LEG) {
        return Plugin_Handled;
    }

    int userId = event.GetInt("userid");
    int attackerId = event.GetInt("attacker");
    int victim = GetClientOfUserId(userId);
    int attacker = GetClientOfUserId(attackerId);

    if (victim == 0 || attacker == 0) {
        return Plugin_Handled;
    }

    if (victim == attacker) {
        return Plugin_Handled;
    }

    float damage = event.GetFloat("damage");
    float victimPos[VECTOR_SIZE];
    float attackerPos[VECTOR_SIZE];
    char targetColor[COLOR_MAX_LENGTH];
    char attackerColor[COLOR_MAX_LENGTH];
    char weapon[WEAPON_NAME_MAX_LENGTH];

    GetClientAbsOrigin(victim, victimPos);
    GetClientAbsOrigin(attacker, attackerPos);

    FormatTeamColor(victim, targetColor);
    FormatTeamColor(attacker, attackerColor);

    float distance = GetVectorDistance(victimPos, attackerPos, false) * METERS_PER_UNIT;

    event.GetString("weapon", weapon, sizeof(weapon));

    CPrintToChat(victim, "%t", "Damage info", "Attacker", attackerColor, attacker, damage, g_hitGroups[hitGroup], distance, weapon);
    CPrintToChat(attacker, "%t", "Damage info", "Target", targetColor, victim, damage, g_hitGroups[hitGroup], distance, weapon);

    return Plugin_Handled;
}

void FormatTeamColor(int client, char[] color) {
    int clientTeam = GetClientTeam(client);

    strcopy(color, COLOR_MAX_LENGTH, g_teamColor[clientTeam - 2]);
}

bool IsPluginEnabled() {
    return g_pluginEnabled.IntValue == 1;
}
