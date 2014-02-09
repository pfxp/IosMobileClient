//
//  Points.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
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



@interface ZoneLinePoint : CamsGeoPoint
@property (readwrite) NSNumber *parentId;
@property (readwrite) NSNumber *sequence;
@end

@interface SensorLinePoint : ZoneLinePoint
@property (readwrite) NSNumber *cableDistance;
@property (readwrite) NSNumber *perimeterDistance;
@end
