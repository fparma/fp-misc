/*
///////////////////////////
	ARMA 3 Police car script
	Author: Cuel
	Credits: max
	Created: 2014-02-02
	Purpose: Make the offroad like a police car.
	@param [offroad_object]
	Example:
	0 =  [this] execVM "fp_misc\scripts\police_car.sqf";
	Version: 0.1
///////////////////////////
*/
_veh = [_this,0,objNull] call BIS_fnc_param;
if (isNull _veh) exitWith {};

_veh setVariable ["BIS_enableRandomization", false];

if (isServer) then {
	_veh  animate ["HideConstruction", 0];
	_veh  animate ["HidePolice", 0];
	_veh  animate ["HideBackpacks", 1];
	_veh  animate ["HideDoor3", 0];
	_veh  animate ["HideBumper1", 1];
	_veh  animate ["HideBumper2", 0];
	_veh setObjectTextureGlobal [0,"fp_misc\img\police_offroad.paa"];
};

if (isDedicated) exitWith {};

/*
	Siren
*/
 _veh addAction ["<t color='#ffff00'>[ Siren ON ]</t>",
 {
 	_veh = _this select 0;
 	_activate = !(_veh getVariable ["CUL_siren", false]);
 	_veh setVariable ["CUL_siren", _activate, true];
 	_text = format ["<t color='#ffff00'>[ Siren %1 ]</t>", if _activate then {"OFF"} else {"ON"}];
 	_veh setUserActionText [_this select 2, _text];
 	if (_activate) then {
		[[_veh],'CUL_policeSirenActivate',true,true] call BIS_fnc_MP;
	};
},0, 100, false, false,"","driver _target == player"];

if (isNil "CUL_policeSirenActivate") tHen {
	CUL_policeSirenActivate = {
		_vehicle = [_this,0,objNull] call BIS_fnc_param;
		if (!alive _vehicle) exitWith {};

		_speakobject= "Land_HelipadEmpty_F" createVehicleLocal [0,0,0];
		_speakobject attachTo [_vehicle,[0,-2,-1.5]];

		while{alive _vehicle && (_vehicle getVariable ["CUL_siren",false])} do {
			_speakobject say3d "fp_siren";
			sleep 5.4;
		};

		sleep 1;
		deleteVehicle _speakobject;
	};
};


/*
	Lightbar
*/
 _veh addAction ["<t color='#ffff00'>[ Lightbar ON ]</t>",
 {
 	_veh = _this select 0;
 	_activate = !(_veh getVariable ["CUL_lightbar", false]);
 	_veh setVariable ["CUL_lightbar", _activate, true];
 	_text = format ["<t color='#ffff00'>[ Lightbar %1 ]</t>", if _activate then {"OFF"} else {"ON"}];
 	_veh setUserActionText [_this select 2, _text];
 	if (_activate) then {
		[[_veh],'CUL_policeLightbarActivate',true,true] call BIS_fnc_MP;
	};
},0, 100, false, false,"","driver _target == player"];

if (isNil "CUL_policeLightbarActivate") then {
	CUL_policeLightbarActivate = {
		_vehicle = [_this,0,objNull] call BIS_fnc_param;
		if (!alive _vehicle) exitWith {};

		_lightRed = [5, 0.5, 0.5];
		_lightBlue = [0.5, 0.5, 5];

		_lightleft = "#lightpoint" createVehicleLocal getpos _vehicle;
		_lightleft setLightColor _lightRed;
		_lightleft setLightBrightness 0.3;
		_lightleft setLightAmbient _lightRed;
		_lightleft lightAttachObject [_vehicle, [-3, 0.8, 0]];
		_lightleft setLightAttenuation [3, 0, 0, 0.6];

		_lightright = "#lightpoint" createVehicleLocal getpos _vehicle;
		_lightright setLightColor _lightBlue;
		_lightright setLightBrightness 0.3;
		_lightright setLightAmbient _lightBlue;
		_lightright lightAttachObject [_vehicle, [3, 0.8, 0]];
		_lightright setLightAttenuation [3, 0, 0, 0.6];

		_leftRed = true;
		while{alive _vehicle && (_vehicle getVariable ["CUL_lightbar",false])} do
		{
			  if(_leftRed) then
			 {
				_leftRed = false;
				_lightleft setLightColor _lightRed;
				_lightleft setLightAmbient _lightRed;
				_lightright setLightColor _lightBlue;
				_lightright setLightAmbient _lightBlue;

			 }
			 else
			 {
				_leftRed = true;
				_lightleft setLightColor _lightBlue;
				_lightleft setLightAmbient _lightBlue;
				_lightright setLightColor _lightRed;
				_lightright setLightAmbient _lightRed;
			 };
			 sleep 1;
		};
		sleep 1;
		{deleteVehicle _x } forEach [_lightleft,_lightright];

	};
};



/*
if (isNil "CUL_police_siren") then {
	CUL_police_siren =
	{
		_vehicle = [_this,0,objNull] call BIS_fnc_param;
		if (!alive _vehicle) exitWIth {};
		_lightRed = [5, 0.5, 0.5];
		_lightBlue = [0.5, 0.5, 5];
 		_speakobject= "Land_HelipadEmpty_F" createVehicleLocal [0,0,0];
		_speakobject attachTo [_vehicle,[0,-2,-1.5]];

		_lightleft = "#lightpoint" createVehicleLocal getpos _vehicle;
		_lightleft setLightColor _lightRed;
		_lightleft setLightBrightness 0.3;
		_lightleft setLightAmbient _lightRed;
		_lightleft lightAttachObject [_vehicle, [-3, 0.8, 0]];
		_lightleft setLightAttenuation [3, 0, 0, 0.6];

		_lightright = "#lightpoint" createVehicleLocal getpos _vehicle;
		_lightright setLightColor _lightBlue;
		_lightright setLightBrightness 0.3;
		_lightright setLightAmbient _lightBlue;
		_lightright lightAttachObject [_vehicle, [3, 0.8, 0]];
		_lightright setLightAttenuation [3, 0, 0, 0.6];

		[_speakobject,_vehicle] spawn {
			_speakobject = _this select 0;
			_vehicle = _this  select 1;
			while{alive _vehicle && (_vehicle getVariable ["CUL_siren",false])} do {
				_speakobject say3d "fp_siren";
				sleep 5.4;
			};
		};

		_leftRed = true;
		while{alive _vehicle && (_vehicle getVariable ["CUL_siren",false])} do
		{
			  if(_leftRed) then
			 {
				_leftRed = false;
				_lightleft setLightColor _lightRed;
				_lightleft setLightAmbient _lightRed;
				_lightright setLightColor _lightBlue;
				_lightright setLightAmbient _lightBlue;

			 }
			 else
			 {
				_leftRed = true;
				_lightleft setLightColor _lightBlue;
				_lightleft setLightAmbient _lightBlue;
				_lightright setLightColor _lightRed;
				_lightright setLightAmbient _lightRed;
			 };
			 sleep 1;
		};
		sleep 1;
		{deleteVehicle _x } forEach [_lightleft,_lightright,_speakobject];
	};
};

*/
