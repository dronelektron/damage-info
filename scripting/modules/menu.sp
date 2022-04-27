void Menu_AddToPreferences() {
    SetCookieMenuItem(MenuHandler_ShowDamage, 0, "Show damage info");
}

public void MenuHandler_ShowDamage(int client, CookieMenuAction action, any info, char[] buffer, int maxlen) {
    if (action == CookieMenuAction_SelectOption) {
        Menu_Settings(client);
    } else {
        Format(buffer, maxlen, "%T", "Show damage", client);
    }
}

public void Menu_Settings(int client) {
    Menu menu = new Menu(MenuHandler_Settings);

    menu.SetTitle("%T", "Show damage", client);

    Menu_AddBoolItem(menu, MENU_ITEM_IN_CHAT, "Show damage in chat", client, Preferences_IsShowDamageInChat(client));
    Menu_AddBoolItem(menu, MENU_ITEM_ON_SCREEN, "Show damage on screen", client, Preferences_IsShowDamageOnScreen(client));

    menu.ExitBackButton = true;
    menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandler_Settings(Menu menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        char info[ITEM_INFO_MAX_SIZE];

        menu.GetItem(param2, info, sizeof(info));

        if (StrEqual(info, MENU_ITEM_IN_CHAT)) {
            Preferences_ToggleShowDamageInChat(param1);
        } else if (StrEqual(info, MENU_ITEM_ON_SCREEN)) {
            Preferences_ToggleShowDamageOnScreen(param1);
        }

        Menu_Settings(param1);
    } else if (action == MenuAction_Cancel) {
        if (param2 == MenuCancel_ExitBack) {
            ShowCookieMenu(param1);
        }
    } else if (action == MenuAction_End) {
        delete menu;
    }

    return 0;
}

void Menu_AddBoolItem(Menu menu, char[] info, char[] phrase, int client, bool enabled) {
    char buffer[TEXT_BUFFER_MAX_SIZE];

    Format(buffer, sizeof(buffer), "%T", phrase, client, enabled ? "Enabled" : "Disabled", client);

    menu.AddItem(info, buffer);
}
