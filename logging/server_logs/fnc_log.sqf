#include "script_component.hpp"

if (!isMultiplayer) exitWith {};

if (!params [["_args", "", [""]]] || {!isServer} || {GVAR(disabled)}) exitWith {};
["log", [GVAR(id), time, _args]] call sock_rpc;
