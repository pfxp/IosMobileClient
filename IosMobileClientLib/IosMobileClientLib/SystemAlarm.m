//
//  SystemAlarm.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 17/03/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "SystemAlarm.h"

@implementation SystemAlarm

-(id) initWithAlarmId:(NSNumber *)alarmId
            alarmTime:(NSDate *)alarmTimeUtc
         acknowledged:(BOOL)acknowledged
            alarmType:(NSNumber*)alarmType
         controllerId:(NSNumber*)controllerId
{
    self = [super init];
    if (self)
    {
        [self setAlarmId:alarmId];
        [self setAlarmTimeUtc:alarmTimeUtc];
        [self setAcknowledged:acknowledged];
        [self setAlarmType:alarmType];
        [self setControllerId:controllerId];
    }
    return self;
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"SYSTEM ALARM: Alarm ID: %@", [self alarmId]];
}

@end
