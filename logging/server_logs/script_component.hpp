#define COMPONENT server_logs
#include "script_mod.hpp"

#ifdef DEBUG_ENABLED_LOGS
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_LOGS
    #define DEBUG_SETTINGS DEBUG_SETTINGS_LOGS
#endif

#include "script_macros.hpp"
