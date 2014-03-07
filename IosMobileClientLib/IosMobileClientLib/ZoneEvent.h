//
//  ZoneEvent.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 28/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Controller;
@class Sensor;
@class CamsGeoPoint;

@interface ZoneEvent : NSObject

@property (readwrite, copy) NSNumber *eventId;
@property (readwrite) NSDate *eventTimeUtc;
@property (readwrite) BOOL acknowledged;
@property (readwrite) BOOL active;
@property (readwrite) BOOL dynamic;
@property (readwrite) int zoneId;
@property (readwrite) int controllerId;
@property (readwrite) int sensorId;
@property (readwrite) double cableDistance;
@property (readwrite, strong) CamsGeoPoint* camsGeoPoint;
@property (readwrite) double perimeterDistance;
@property (readwrite) double locationWeight;
@property (readwrite) double locationWeightThreshold;


-(id) initWithEventId:(NSNumber *)eventId
            eventTime:(NSDate *)eventTime
         acknowledged:(BOOL)acknowledged
               active:(BOOL)active
              dynamic:(BOOL)dynamic
               zoneId:(int)zoneId
         controllerId:(int)controllerId
             sensorId:(int)sensorId
        cableDistance:(double)cableDistance
         camsGeoPoint:(CamsGeoPoint*)camsGeoPoint
    perimeterDistance:(double)perimeterDistance
       locationWeight:(double)locationWeight
locationWeightThreshold:(double)locationWeightThreshold;

- (NSString*) description;

@end
