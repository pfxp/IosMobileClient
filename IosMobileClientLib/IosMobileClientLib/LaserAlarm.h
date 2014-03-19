//
//  LaserAlarm.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 17/03/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SystemAlarm.h"

@class CamsGeoPoint;

@interface LaserAlarm : SystemAlarm

@property (readwrite) BOOL validLocation;
@property (readwrite) CamsGeoPoint *location;
@property (readwrite) BOOL isOTDR;
@property (readwrite) NSArray *sensorIds;

-(id) initWithAlarmId:(NSNumber *)alarmId
            alarmTime:(NSDate *)alarmTimeUtc
         acknowledged:(BOOL)acknowledged
            alarmType:(NSNumber*)alarmType
         controllerId:(NSNumber*)controllerId
         validLocation:(BOOL)validLocation
             location:(CamsGeoPoint *)location
               isOTDR:(BOOL)isOTDR
            sensorIds:(NSArray*)sensorIds;

- (NSString*) description;

@end
