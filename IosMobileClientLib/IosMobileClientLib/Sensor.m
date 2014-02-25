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
             points:(NSArray *)pointsArray
{
    self = [super init];
    
    if (self)
    {
        _sensorDescription=desc;
        _sensorId=sId;
        _channelNumber=cNum;
        _sensorGuid=sguid;
        _points=pointsArray;
    }
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"Desc=%@ SensorID=%@ Channel=%@",
            _sensorDescription, _sensorId, _channelNumber];
}

@end

