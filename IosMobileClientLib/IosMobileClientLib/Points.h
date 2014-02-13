//
//  Points.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////
// Describes a geographic point at the corners of a map.
////////////////////////////////////////////////////////////////////
@interface CamsGeoPoint : NSObject
@property (readonly, strong) NSNumber *latitude;
@property (readonly, strong) NSNumber *longitude;
@property (readwrite, strong) NSNumber *altitude;

- (id) initWithLat:(NSNumber *)latitudeValue long:(NSNumber *)longitudeValue alt:(NSNumber *)altitudeValue;
- (id) initWithLatStr:(NSString *)latitudeValue longStr:(NSString *)longitudeValue altStr:(NSString *)altitudeValue;
- (NSString *)description;
@end


////////////////////////////////////////////////////////////////////
// Describes a geographic point used for zone lines.
////////////////////////////////////////////////////////////////////
@interface ZoneLinePoint : CamsGeoPoint
@property (readonly, strong) NSNumber *parentId;
@property (readonly, strong) NSNumber *sequence;

- (id) initWithLat:(NSNumber *)latitudeValue long:(NSNumber *)longitudeValue alt:(NSNumber *)altitudeValue
parentId:(NSNumber *)parentId sequence:(NSNumber *)sequence;
- (id) initWithLatStr:(NSString *)latitudeValue longStr:(NSString *)longitudeValue altStr:(NSString *)altitudeValue
          parentIdStr:(NSString *)parentId sequenceStr:(NSString *)sequence;

@end


////////////////////////////////////////////////////////////////////
// Describes the geographic points that make up a sensor line.
////////////////////////////////////////////////////////////////////
@interface SensorLinePoint : ZoneLinePoint
@property (readonly, strong) NSNumber *cableDistance;
@property (readonly, strong) NSNumber *perimeterDistance;

- (id) initWithLat:(NSNumber *)latitudeValue long:(NSNumber *)longitudeValue alt:(NSNumber *)altitudeValue
          parentId:(NSNumber *)parentId sequence:(NSNumber *)sequence
     cableDistance:(NSNumber *)cableDistance perimeterDistance:(NSNumber *)perimeterDistance;
- (id) initWithLatStr:(NSString *)latitudeValue longStr:(NSString *)longitudeValue altStr:(NSString *)altitudeValue
          parentIdStr:(NSString *)parentId sequenceStr:(NSString *)sequence
     cableDistanceStr:(NSString *)cableDistance perimeterDistanceStr:(NSString *)perimeterDistance;
@end
