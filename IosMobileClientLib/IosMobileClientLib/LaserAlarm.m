//
//  LaserAlarm.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 17/03/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "LaserAlarm.h"

@implementation LaserAlarm

-(id) initWithAlarmId:(NSNumber *)alarmId
            alarmTime:(NSDate *)alarmTimeUtc
         acknowledged:(BOOL)acknowledged
            alarmType:(AlarmType)alarmType
         controllerId:(NSNumber*)controllerId
        validLocation:(BOOL)validLocation
             location:(CamsGeoPoint *)location
               isOTDR:(BOOL)isOTDR
            sensorIds:(NSArray*)sensorIds;
{
    self = [super initWithAlarmId:alarmId
                        alarmTime:alarmTimeUtc
                     acknowledged:acknowledged
                        alarmType:alarmType
                     controllerId:controllerId];
    
    if (self)
    {
        [self setValidLocation:validLocation];
        [self setLocation:location];
        [self setIsOTDR:isOTDR];
        [self setSensorIds:sensorIds];
    }
    return self;
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"LASER ALARM: Alarm ID: %@", [self alarmId]];
}

@end
