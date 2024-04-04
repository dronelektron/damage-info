#include <sourcemod>
#include <clientprefs>

#include "di/cookie"
#include "di/math"
#include "di/menu"
#include "di/message"
#include "di/use-case"

#include "modules/console-variable.sp"
#include "modules/cookie.sp"
#include "modules/event.sp"
#include "modules/math.sp"
#include "modules/menu.sp"
#include "modules/message.sp"
#include "modules/use-case.sp"

#define AUTO_CREATE_YES true

public Plugin myinfo = {
    name = "Damage info",
    author = "Dron-elektron",
    description = "Shows damage information in chat and on screen",
    version = "1.1.2",
    url = "https://github.com/dronelektron/damage-info"
};

public void OnPluginStart() {
    Variable_Create();
    Cookie_Create();
    Event_Create();
    Menu_AddToPreferences();
    CookiesLateLoad();
    LoadTranslations("damage-info.phrases");
    AutoExecConfig(AUTO_CREATE_YES, "damage-info");
}

public void OnClientCookiesCached(int client) {
    Cookie_Load(client);
}

void CookiesLateLoad() {
    for (int i = 1; i <= MaxClients; i++) {
        if (AreClientCookiesCached(i)) {
            OnClientCookiesCached(i);
        }
    }
}
