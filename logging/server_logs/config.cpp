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
  class ADDON {
    serverInit = QUOTE(call COMPILE_FILE(XEH_serverPreInit));
  };
};

class Extended_PostInit_EventHandlers {
  class ADDON {
    serverInit = QUOTE(call COMPILE_FILE(XEH_serverPostInit));
  };
};
