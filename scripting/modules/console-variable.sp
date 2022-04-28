static ConVar g_pluginEnabled = null;

void Variable_Create() {
    g_pluginEnabled = CreateConVar("sm_damageinfo_show", "1", "Enable (1) or disable (0) damage information");
}

bool Variable_IsPluginEnabled() {
    return g_pluginEnabled.IntValue == 1;
}
