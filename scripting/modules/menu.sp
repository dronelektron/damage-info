void Menu_AddToPreferences() {
    SetCookieMenuItem(MenuHandler_ShowDamage, 0, SHOW_DAMAGE);
}

public void MenuHandler_ShowDamage(int client, CookieMenuAction action, any info, char[] buffer, int maxlen) {
    if (action == CookieMenuAction_SelectOption) {
        Menu_Settings(client);
    } else {
        Format(buffer, maxlen, "%T", SHOW_DAMAGE, client);
    }
}

public void Menu_Settings(int client) {
    Menu menu = new Menu(MenuHandler_Settings);

    menu.SetTitle("%T", SHOW_DAMAGE, client);

    Menu_AddShowDamageItem(menu, client, ITEM_SHOW_DAMAGE_IN_CHAT, Cookie_IsShowDamage(client, MessageSource_Chat));
    Menu_AddShowDamageItem(menu, client, ITEM_SHOW_DAMAGE_ON_SCREEN, Cookie_IsShowDamage(client, MessageSource_Screen));

    menu.ExitBackButton = true;
    menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandler_Settings(Menu menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        char info[ITEM_SIZE];

        menu.GetItem(param2, info, sizeof(info));

        if (StrEqual(info, ITEM_SHOW_DAMAGE_IN_CHAT)) {
            Cookie_ToggleValue(param1, MessageSource_Chat);
        } else if (StrEqual(info, ITEM_SHOW_DAMAGE_ON_SCREEN)) {
            Cookie_ToggleValue(param1, MessageSource_Screen);
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

void Menu_AddShowDamageItem(Menu menu, int client, const char[] phrase, bool enabled) {
    char item[ITEM_SIZE];

    SetGlobalTransTarget(client);
    Format(item, sizeof(item), "%t", phrase, enabled ? ITEM_ENABLED : ITEM_DISABLED);

    menu.AddItem(phrase, item);
}
