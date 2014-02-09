//
//  Sensor.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sensor : NSObject
@property (readwrite) NSString *sensorDescription;
@property (readwrite) NSNumber *sensorId;
@property (readwrite) NSNumber *channelNumber;
@property (readwrite) NSString *sensorGuid;
@property (readwrite) NSArray *points;

- (id) initWithDesc:(NSString*)desc
           sensorid:(NSNumber *)sId
      channelNumber:(NSNumber *)cNum
         sensorGuid:(NSString *)sguid;

- (NSString *)description;

@end