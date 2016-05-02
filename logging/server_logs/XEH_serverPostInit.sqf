#include "script_component.hpp"

[QGVAR(connected), "onPlayerConnected", {
  if (_name == "__SERVER__") exitWith {};
  [{
    if (!(["FP_logs"] call ACE_common_fnc_isModLoaded)) then {
      (format ["%1: not running FP logs", profileName]) remoteExecCall ["systemChat", 0];
    };
  }] remoteExecCall ["BIS_fnc_call", _owner];
  (format ["%1 (%2) connected", _name, _uid]) call FUNC(log);
}] call BIS_fnc_addStackedEventHandler;

[QGVAR(disconnected), "onPlayerDisconnected", {
  if (_name == "__SERVER__") exitWith {};
  (format ["%1 (%2) disconnected", _name, _uid]) call FUNC(log);
}] call BIS_fnc_addStackedEventHandler;

["medical_onUnconscious", {
  _this call FUNC(onUnconscious);
}] call ACE_common_fnc_addEventHandler;

["ace_explosives_place", {
  params ["_exp", "", "", "_unit"];
  (format ["%1 placed an explosive (%2) at %3", name _unit, typeOf _exp, getPosATL _exp]) call FUNC(log);
}] call ACE_common_fnc_addEventHandler;

["ace_explosives_defuse", {
  params ["_exp", "_unit"];
  (format ["%1 defused an explosive (%2) at %3", name _unit, typeOf _exp, getPosATL _exp]) call FUNC(log);
}] call ACE_common_fnc_addEventHandler;

["ace_explosives_explodeOnDefuse", {
  params ["_exp", "_unit"];
  (format ["%1 tried to defuse an explosive (%2) at %3, and failed", name _unit, typeOf _exp, getPosATL _exp]) call FUNC(log);
}] call ACE_common_fnc_addEventHandler;

["ace_explosives_detonated", {
  params ["_exp", "_unit", "_pos"];
  private _plrs = allPlayers select {_x distance _pos < 50};
  _plrs = _plrs apply {format ["%1 (%2)m, ", name _x, round (_x distance _pos)]};

  (format ["%1 detonated an explosive (%2) at %3.%4",
    name _unit,
    typeOf _exp,
    _pos,
    ["", format ["%1 players nearby. %2", count _plrs, _plrs]] select (count _plrs > 0)
  ]) call FUNC(log);
}] call ACE_common_fnc_addEventHandler;

(format ["Loaded mission: %1", briefingName]) call FUNC(log);

[{time > 0.5}, {
  (format ["Mission started. %1 players", count allPlayers]) call FUNC(log);
}, []] call ace_common_fnc_waitUntilAndExecute;

addMissionEventHandler ["Ended", {
  params ["_type"];
  format ["Mission ended. (%1)", _type] call FUNC(log);
}];
