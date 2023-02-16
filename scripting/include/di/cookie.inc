#if defined _di_cookie_included
 #endinput
#endif
#define _di_cookie_included

#define COOKIE_VALUE_SIZE 2
#define NULL_CHARACTER '\0'

#define VALUE_ENABLED "1"
#define VALUE_DISABLED "0"

enum DamageMessage {
    DamageMessage_Chat,
    DamageMessage_Screen,

    DamageMessage_Size
};
