//
//  Sensor.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "Sensor.h"

@implementation Sensor
- (id) initWithDesc:(NSString*)desc
           sensorid:(NSNumber *)sId
      channelNumber:(NSNumber *)cNum
         sensorGuid:(NSString *)sguid
{
    self = [super init];
    
    if (self)
    {
        [self setSensorDescription:desc];
        [self setSensorId:sId];
        [self setChannelNumber:cNum];
        [self setSensorGuid:sguid];
    }
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"Desc=%@ SensorID=%@ Channel number=%@ Sensor GUID=%@", self.sensorDescription, self.sensorId,
            self.channelNumber, self.sensorGuid];
}

@end

