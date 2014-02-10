//
//  Points.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CamsGeoPoint : NSObject
@property (readwrite, copy) NSNumber *latitude;
@property (readwrite, copy) NSNumber *longitude;
@property (readwrite, copy) NSNumber *altitude;

- (id) initWithLat:(NSNumber *)latitudeValue long:(NSNumber *)longitudeValue alt:(NSNumber *)altitudeValue;
- (id) initWithLatStr:(NSString *)latitudeValue longStr:(NSString *)longitudeValue altStr:(NSString *)altitudeValue;
@end



@interface ZoneLinePoint : CamsGeoPoint
@property (readwrite, copy) NSNumber *parentId;
@property (readwrite, copy) NSNumber *sequence;

- (id) initWithLat:(NSNumber *)latitudeValue long:(NSNumber *)longitudeValue alt:(NSNumber *)altitudeValue
parentId:(NSNumber *)parentId sequence:(NSNumber *)sequence;
- (id) initWithLatStr:(NSString *)latitudeValue longStr:(NSString *)longitudeValue altStr:(NSString *)altitudeValue
          parentIdStr:(NSString *)parentId sequenceStr:(NSString *)sequence;

@end

@interface SensorLinePoint : ZoneLinePoint
@property (readwrite, copy) NSNumber *cableDistance;
@property (readwrite, copy) NSNumber *perimeterDistance;

- (id) initWithLat:(NSNumber *)latitudeValue long:(NSNumber *)longitudeValue alt:(NSNumber *)altitudeValue
          parentId:(NSNumber *)parentId sequence:(NSNumber *)sequence
     cableDistance:(NSNumber *)cableDistance perimeterDistance:(NSNumber *)perimeterDistance;
- (id) initWithLatStr:(NSString *)latitudeValue longStr:(NSString *)longitudeValue altStr:(NSString *)altitudeValue
          parentIdStr:(NSString *)parentId sequenceStr:(NSString *)sequence
     cableDistanceStr:(NSString *)cableDistance perimeterDistanceStr:(NSString *)perimeterDistance;
@end
