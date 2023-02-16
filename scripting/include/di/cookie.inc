#if defined _di_cookie_included
 #endinput
#endif
#define _di_cookie_included

#define COOKIE_VALUE_SIZE 2
#define NULL_CHARACTER '\0'

#define VALUE_ENABLED "1"
#define VALUE_DISABLED "0"

enum MessageSource {
    MessageSource_Chat,
    MessageSource_Screen,

    MessageSource_Size
};
