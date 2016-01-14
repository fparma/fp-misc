#include "script_component.hpp"

class CfgPatches
{
	class ADDON
	{
		units[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"ACE_main"};
	};
};

class Extended_PreInit_EventHandlers {
  ADDON = QUOTE(call COMPILE_FILE(XEH_preInit));
};

class Extended_Init_EventHandlers {
  class CAManBase {
    class ADDON {
      clientInit = QUOTE(call COMPILE_FILE(XEH_init));
    };
  };
};

class Extended_FiredBIS_EventHandlers {
  class CAManBase {
    class ADDON {
      firedBIS = QUOTE(if (local (_this select 0)) then {_this call FUNC(fired);};);
    };
  };
};

class Extended_Killed_EventHandlers {
  class CAManBase {
    class ADDON {
      killed = QUOTE(if (local (_this select 0)) then {_this call FUNC(killed);};);
    };
  };
};
