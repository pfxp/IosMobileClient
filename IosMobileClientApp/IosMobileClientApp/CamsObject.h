//
//  CamsObject.h
//  MobileClientLibrary
//
//  Created by Peter Pellegrini on 5/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CamsGeoPoint : NSObject
@property (readwrite) NSNumber *latitude;
@property (readwrite) NSNumber *longitude;
@property (readwrite) NSNumber *altitude;

- (id) initWithPeter;
- (id) initWithLatLongAlt:(NSNumber *)latitudeValue long:(NSNumber *)longitudeValue alt:(NSNumber *)altitudeValue;
- (NSString *) toString;
@end


@interface Map : NSObject
@property (readwrite) NSString *displayName;
@property (readwrite) NSString *mapId;
@property (readwrite) CamsGeoPoint *topLeftCorner;
@property (readwrite) CamsGeoPoint *topRightCorner;
@property (readwrite) CamsGeoPoint *bottomLeftCorner;
@property (readwrite) CamsGeoPoint *bottomCorner;
@end


@interface ZoneLinePoint : CamsGeoPoint
@property (readwrite) NSNumber *parentId;
@property (readwrite) NSNumber *sequence;
@end

@interface SensorLinePoint : ZoneLinePoint
@property (readwrite) NSNumber *cableDistance;
@property (readwrite) NSNumber *perimeterDistance;
@end

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

@interface Controller : NSObject
@property (readwrite) BOOL connected;
@property (readwrite, copy) NSString *controllerDescription;
@property (readwrite, copy) NSString *hostname;
@property (readwrite) NSNumber *ctrlId;
@property (readwrite) BOOL locator;
@property (readwrite, copy) NSString *name;

- (id) initWithAllValues:(BOOL)conn
            description:(NSString*)desc
            hostname:(NSString *)host
            ctrlid:(NSNumber *)cId
            locator:(BOOL)loc
            name:(NSString*)nm;

- (NSString *)description;
- (void) doSomething;
@end

@interface Zone : NSObject
@property (readwrite) NSNumber *zoneId;
@property (readwrite) NSString *name;
@property (readwrite) NSString *description;
@property (readwrite) NSArray *points;
@end

