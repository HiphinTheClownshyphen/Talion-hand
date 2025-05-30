#define LINE_PROFILE_START ;PROFILE_STORE = list();PROFILE_SET;
#define LINE_PROFILE_STOP ;PROFILE_STORE = null;

#define PROFILE_SET ;PROFILE_TIME = TICK_USAGE_REAL; PROFILE_LINE = __LINE__; PROFILE_FILE = __FILE__; PROFILE_SLEEPCHECK = world.time;

#define PROFILE_TICK ;\
	if (PROFILE_STORE) {\
		var/PROFILE_TICK_USAGE_REAL = TICK_USAGE_REAL;\
		if (PROFILE_SLEEPCHECK == world.time) {\
			var/PROFILE_STRING = "[PROFILE_FILE]:[PROFILE_LINE] - [__FILE__]:[__LINE__]";\
			var/list/PROFILE_ITEM = PROFILE_STORE[PROFILE_STRING];\
			if (!PROFILE_ITEM) {\
				PROFILE_ITEM = new(PROFILE_ITEM_LEN);\
				PROFILE_STORE[PROFILE_STRING] = PROFILE_ITEM;\
				PROFILE_ITEM[PROFILE_ITEM_TIME] = 0;\
				PROFILE_ITEM[PROFILE_ITEM_COUNT] = 0;\
			};\
			PROFILE_ITEM[PROFILE_ITEM_TIME] += TICK_DELTA_TO_MS(PROFILE_TICK_USAGE_REAL-PROFILE_TIME);\
			var/PROFILE_INCR_AMOUNT = min(1, 2**round(PROFILE_ITEM[PROFILE_ITEM_COUNT]/SHORT_REAL_LIMIT));\
			if (prob(100/PROFILE_INCR_AMOUNT)) {\
				PROFILE_ITEM[PROFILE_ITEM_COUNT] += PROFILE_INCR_AMOUNT;\
			};\
		};\
		PROFILE_SET;\
	};

#define PROFILE_ITEM_LEN 2
#define PROFILE_ITEM_TIME 1
#define PROFILE_ITEM_COUNT 2

// Only enable this if you have a local copy of the byond-tracy DLL.
// DO NOT commit the DLL to the repo.
#ifdef TRACY_PROFILE
/proc/prof_init()
	var/lib

	switch(world.system_type)
		if(MS_WINDOWS) lib = "prof.dll"
		if(UNIX) lib = "libprof.so"
		else CRASH("unsupported platform")

	var/init = call_ext(lib, "init")()
	if("0" != init) CRASH("[lib] init error: [init]")

/world/New()
	prof_init()
	. = ..()
#endif
