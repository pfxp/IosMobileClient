//
//  Sensor.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sensor : NSObject
@property (readonly, copy) NSString *sensorDescription;
@property (readonly, copy) NSNumber *sensorId;
@property (readonly, copy) NSNumber *channelNumber;
@property (readonly, copy) NSString *sensorGuid;
@property (readonly, strong) NSArray *points;

- (id) initWithDesc:(NSString*)desc
           sensorid:(NSNumber *)sId
      channelNumber:(NSNumber *)cNum
         sensorGuid:(NSString *)sguid
             points:(NSArray *)pointsArray;

- (NSString *)description;

@end