#include "script_component.hpp"

params ["_unit", "_dmgedPart", "", "_shooter", "_proj"];
if (!local _unit || {!isPlayer _unit}) exitWith {nil};

if (!isPlayer _shooter) then {
  _unit setVariable [QGVAR(lasthit), nil];
};

if (!alive _unit ||
  {!isPlayer _shooter} ||
  {_unit getVariable ["ACE_isUnconscious", false]} ||
  {(time < (GVAR(hitThrottle) select 0) && _shooter == (GVAR(hitThrottle) select 1))}
) exitWith {nil};

_unit setVariable [QGVAR(lasthit), [name _shooter, time, _proj]];

GVAR(hitThrottle) = [time + 2, _shooter];
(format ["%1 was hit by %2.%3%4",
  name _unit,
  name _shooter,
  ["", " Damaged part: " + _dmgedPart + "."] select (count _dmgedPart > 0),
  ["", " (Projectile: " + _proj + ")."] select (count _proj > 0)
]) remoteExecCall ["FP_server_logs_fnc_log", 2];

nil
