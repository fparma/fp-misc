#include "script_component.hpp"

params ["_unit", "_state"];
if (!alive _unit || {!isPlayer _unit}) exitWith {};

private _str = ["woke up", "is unconcious"] select _state;
(format ["%1 %2 at %3", name _unit, _str, getPosATL _unit]) call FUNC(log);
