#include "script_component.hpp"

GVAR(grenades) = [];
GVAR(hitThrottle) = [0, objNull];

PREP(fired);
PREP(killed);
PREP(handleDamage);
