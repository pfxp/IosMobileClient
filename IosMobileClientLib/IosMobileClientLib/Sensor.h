//
//  Sensor.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sensor : NSObject
@property (readwrite, copy) NSString *sensorDescription;
@property (readwrite, copy) NSNumber *sensorId;
@property (readwrite, copy) NSNumber *channelNumber;
@property (readwrite, copy) NSString *sensorGuid;
@property (readwrite, copy) NSArray *points;

- (id) initWithDesc:(NSString*)desc
           sensorid:(NSNumber *)sId
      channelNumber:(NSNumber *)cNum
         sensorGuid:(NSString *)sguid
             points:(NSArray *)pointsArray;

- (NSString *)description;

@end