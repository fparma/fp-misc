#include "script_component.hpp"


GVAR(disabled) = false;
GVAR(id) = format ["%1///%2///%3///%4", worldName, briefingName, dateToNumber date, random 10000];

call COMPILE_FILE(sock);
PREP(log);
PREP(onUnconscious);
