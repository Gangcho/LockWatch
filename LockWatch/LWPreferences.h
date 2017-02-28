//
//  LWPreferences.h
//  LockWatch
//
//  Created by Janik Schmidt on 28.02.17.
//
//

#import <Foundation/Foundation.h>

@interface LWPreferences : NSObject

+ (NSMutableDictionary*)preferences;
+ (void)setValue:(id)value forKey:(NSString*)key;
+ (void)savePreferences;

@end
