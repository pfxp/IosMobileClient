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
@property (readwrite) NSNumber *zoneId;
@property (readwrite) NSNumber *controllerId;
@property (readwrite) NSNumber *sensorId;
@property (readwrite) NSNumber *cableDistance;
@property (readwrite, strong) CamsGeoPoint* camsGeoPoint;
@property (readwrite) NSNumber *perimeterDistance;
@property (readwrite) NSNumber *locationWeight;
@property (readwrite) NSNumber *locationWeightThreshold;


-(id) initWithEventId:(NSNumber *)eventId
            eventTime:(NSDate *)eventTime
         acknowledged:(BOOL)acknowledged
               active:(BOOL)active
              dynamic:(BOOL)dynamic
               zoneId:(NSNumber*)zoneId
         controllerId:(NSNumber*)controllerId
             sensorId:(NSNumber*)sensorId
        cableDistance:(NSNumber*)cableDistance
         camsGeoPoint:(CamsGeoPoint*)camsGeoPoint
    perimeterDistance:(NSNumber*)perimeterDistance
       locationWeight:(NSNumber*)locationWeight
locationWeightThreshold:(NSNumber*)locationWeightThreshold;

- (NSString*) description;

@end
