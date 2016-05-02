#include "script_component.hpp"

params ["_unit", "_killer"];
if (!isPlayer _unit) exitWith {};
  private _posUnit = getPosATL _unit;
if (_posUnit distance2D [0,0] < 100) exitWith {};

if (_unit == _killer || {!isPlayer _killer}) exitWith {

  private _lasthit = _unit getVariable [QGVAR(lasthit), []];
  private _extra = "";
  if (count _lasthit > 0) then {
    _extra = format [" Last hit by %1, %2s ago.",
      _lasthit select 0,
      time - (_lasthit select 1)
    ];
    if (count (_lasthit select 2) > 0) then {
      _extra = _extra + ' (Projectile: )' + (_lasthit select 2);
    };
  };
  _unit setVariable [QGVAR(lasthit), nil];

  private _extra2 = "";
  if (_unit == _killer) then {
    private _near = (nearestObjects [_posUnit, ["LandVehicle"], 10]) select {isPlayer (driver _x)};
    if (count _near > 0) then {
      _extra2 = format [" Nearby drivers: %1",
        [_near, {format ["%1 (%2, pos: %3, speed: %4, dir: %5, dist: %6m)%7",
          name (driver _x),
          typeOf _x,
          getPosATL _x,
          round speed _x,
          round getDir _x,
          round (_x distance _unit),
          [", ", ""] select (_forEachIndex == ((count _near) -1 ))
        ]}] call ACE_common_fnc_map
      ];
    };
  };

  (format ["%1 died at %2.%3%4",
    name _unit,
    _posUnit,
    _extra,
    _extra2
  ]) remoteExecCall ["FP_server_logs_fnc_log", 2];
};

private _posKiller = getPosATL _killer;

private _crew = [];
if (!(_killer isKindOf "Man")) then {
  private _plrs = (fullCrew _killer) select {isPlayer (_x select 0)};
  _crew = _plrs apply {
    _x params ["_unit", "_role", "", "_turretPath"];
    (format ["%1 - %2(%3)", name _unit, _role, _turretPath])
  };
};

(format ["%1 was killed at %2 by %3(%4), from a distance of %5m (Killer's dir: %6).%7",
  name _unit,
  _posUnit,
  name _killer,
  _posKiller,
  round (_unit distance _killer),
  round (getDir _killer),
  [
    " " + name _killer + "'s muzzle:" + str (currentMuzzle _killer),
    " NOTE: " + name _killer + " was in a vehicle! (" + typeOf (vehicle _killer) + "). Crew: " + str _crew
  ] select (!(_killer isKindOf "Man"))
]) remoteExecCall ["FP_server_logs_fnc_log", 2];
