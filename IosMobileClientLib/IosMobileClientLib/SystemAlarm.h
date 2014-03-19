//
//  SystemAlarm.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 17/03/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalSettings.h"

@interface SystemAlarm : NSObject

@property (readwrite, copy) NSNumber *alarmId;
@property (readwrite) NSDate *alarmTimeUtc;
@property (readwrite) BOOL acknowledged;
@property (readwrite) AlarmType alarmType;
@property (readwrite) NSNumber *controllerId;


-(id) initWithAlarmId:(NSNumber *)alarmId
            alarmTime:(NSDate *)alarmTimeUtc
         acknowledged:(BOOL)acknowledged
            alarmType:(AlarmType)alarmType
         controllerId:(NSNumber*)controllerId;

- (NSString*) description;

@end
