#include "script_component.hpp"

params ["_unit", "", "_muzzle"];
if (!isPlayer _unit || {_muzzle != "HandGrenadeMuzzle"}) exitWith {};

private _proj = param [6, objNull];
if (isNull _proj) exitWith {};

// Clean up
if (count (GVAR(grenades) select {!(isNull (_x select 0))}) == 0) then {
  GVAR(grenades) = [];
};

// let any other EVs delete the nade first
[{
  params ["_proj"];
  if (isNull _proj) exitWith {};
  private _id = GVAR(grenades) pushBack [_proj, getPosATL _proj];

  private _check = {
    params ["_id", "_pfhId"];
    private _ele = GVAR(grenades) select _id;
    _ele params ["_proj", ["_pos", [0, 0]], "_type"];

    if (alive _proj) exitWith {
      GVAR(grenades) set [_id, [_proj, getPosATL _proj, typeOf _proj]];
    };

    [_pfhId] call CBA_fnc_removePerFrameHandler;

    private _near = allPlayers select {alive _x && {_x distance _pos < 40}};
    if (count _near > 0) then {
      private _names = _near apply {
        format ["%1 (%2m)%3",
          name _x,
          round (_x distance _pos),
          [", ", ""] select (_forEachIndex == ((count _near) -1 ))
        ];
      };

      (format ["%1 threw a grenade (%2) at %3. %4 player(s) were within 40m (%5)",
      name player,
      _type,
      _pos,
      count _near,
      _names
      ]) remoteExecCall ["FP_server_logs_fnc_log", 2];
    };
  };

  [_check, 0.1, _id] call CBA_fnc_addPerFrameHandler;
}, _proj] call ACE_common_fnc_execNextFrame;
