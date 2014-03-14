//
//  ZoneEvent.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 28/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "ZoneEvent.h"

@implementation ZoneEvent

-(id) initWithEventId:(NSNumber *)eventId
            eventTime:(NSDate *)eventTime
         acknowledged:(BOOL)acknowledged
               active:(BOOL)active
              dynamic:(BOOL)dynamic
               zoneId:(NSNumber*)zoneId
         controllerId:(NSNumber*)controller
             sensorId:(NSNumber*)sensor
        cableDistance:(NSNumber*)cableDistance
         locationGeoPoint:(CamsGeoPoint*)camsGeoPoint
    perimeterDistance:(NSNumber*)perimeterDistance
       locationWeight:(NSNumber*)locationWeight
locationWeightThreshold:(NSNumber*)locationWeightThreshold;
{
    self = [super init];
    if (self)
    {
        [self setEventId:eventId];
        [self setEventTimeUtc:eventTime];
        [self setAcknowledged:acknowledged];
        [self setActive:active];
        [self setDynamic:dynamic];
        [self setZoneId:zoneId];
        [self setControllerId:controller];
        [self setSensorId:sensor];
        [self setCableDistance:cableDistance];
        [self setCamsGeoPoint:camsGeoPoint];
        [self setPerimeterDistance:perimeterDistance];
        [self setLocationWeight:locationWeight];
        [self setLocationWeightThreshold:locationWeightThreshold];
    }
    return self;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"EVENT EventID: %@ Event time: %@", [self eventId], [self eventTimeUtc]];
}

@end
