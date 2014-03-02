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
           controllerId:(int)controller
               sensorId:(int)sensor
{
    self = [super init];
    if (self)
    {
        [self setEventId:eventId];
        [self setEventTimeUtc:eventTime];
        [self setAcknowledged:acknowledged];
        [self setActive:active];
        [self setDynamic:dynamic];
        [self setControllerId:controller];
        [self setSensorId:sensor];
    }
    return self;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"EVENT EventID: %@ Event time: %@", [self eventId], [self eventTimeUtc]];
}

@end
