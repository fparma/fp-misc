#include "\x\cba\addons\main\script_macros_common.hpp"

#ifndef DFUNC
	#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)
#endif

#ifndef QFUNC
	#define QFUNC(var1) QUOTE(DFUNC(var1))
#endif
