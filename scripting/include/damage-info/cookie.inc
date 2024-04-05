#if defined _damage_info_cookie_included
 #endinput
#endif
#define _damage_info_cookie_included

#define NULL_CHARACTER '\0'

#define COOKIE_VALUE_ENABLED "1"
#define COOKIE_VALUE_DISABLED "0"
#define COOKIE_VALUE_SIZE 2

enum MessageSource {
    MessageSource_Chat,
    MessageSource_Screen,

    MessageSource_Size
};
