#import "LWPreferences.h"

#if TARGET_OS_SIMULATOR
#define PREFERENCE_LOCATION @"/opt/simject/FESTIVAL/LockWatch/ml.festival.lockwatch10.plist"
#else
#define PREFERENCE_LOCATION @"/var/mobile/Library/Preferences/ml.festival.lockwatch10.plist"
#endif

@implementation LWPreferences

static NSMutableDictionary* sharedPreferences;

+ (NSMutableDictionary*)preferences {
	sharedPreferences = [NSMutableDictionary dictionaryWithContentsOfFile:PREFERENCE_LOCATION];
	return sharedPreferences;
}

+ (void)setValue:(id)value forKey:(NSString*)key {
	[sharedPreferences setObject:value forKey:key];
	[sharedPreferences writeToFile:PREFERENCE_LOCATION atomically:YES];
}

+ (void)savePreferences {
	[sharedPreferences writeToFile:PREFERENCE_LOCATION atomically:YES];
}

- (id)init {
	self = [super init];
	
	if (self) {
		sharedPreferences = [NSMutableDictionary dictionaryWithContentsOfFile:PREFERENCE_LOCATION];
		
		if (!sharedPreferences) {
			sharedPreferences = [[NSMutableDictionary alloc] init];
			[sharedPreferences setValue:[NSNumber numberWithBool:YES] forKey:@"enabled"];
		}
		
		[sharedPreferences writeToFile:PREFERENCE_LOCATION atomically:YES];
	}
	
	return self;
}

@end
