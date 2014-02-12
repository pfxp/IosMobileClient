//
//  Points.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "Points.h"

@implementation CamsGeoPoint

- (id) initWithLat:(NSNumber *)latitudeValue long:(NSNumber *)longitudeValue alt:(NSNumber *)altitudeValue
{
    self = [super init];
    if (self)
    {
        self.latitude = latitudeValue;
        self.longitude = longitudeValue;
        self.altitude = altitudeValue;
    }
    return self;
}

// TODO Check for bad arguments
- (id) initWithLatStr:(NSString *)latitudeValue longStr:(NSString *)longitudeValue altStr:(NSString *)altitudeValue
{
    NSNumber *latitudeNumber = [NSNumber numberWithDouble:[latitudeValue doubleValue]];
    NSNumber *longitudeNumber = [NSNumber numberWithDouble:[longitudeValue doubleValue]];
    NSNumber *altitudeNumber = [NSNumber numberWithDouble:[altitudeValue doubleValue]];
    
    return [self initWithLat:latitudeNumber long:longitudeNumber alt:altitudeNumber];
}


- (NSString *)description {
   return [NSString stringWithFormat:@"Lat: %@ Long: %@ Alt: %@", self.latitude, self.longitude, self.altitude];
}

@end

// Zone line point.
@implementation ZoneLinePoint

- (id) initWithLat:(NSNumber *)latitudeValue long:(NSNumber *)longitudeValue alt:(NSNumber *)altitudeValue
          parentId:(NSNumber *)parentId sequence:(NSNumber *)sequence
{
    self = [super initWithLat:latitudeValue long:longitudeValue alt:altitudeValue];
    if (self)
    {
        self.parentId = parentId;
        self.sequence = sequence;
    }
    return self;
}

- (id) initWithLatStr:(NSString *)latitudeValue longStr:(NSString *)longitudeValue altStr:(NSString *)altitudeValue
          parentIdStr:(NSString *)parentId sequenceStr:(NSString *)sequence
{
    self = [super initWithLatStr:latitudeValue longStr:longitudeValue altStr:altitudeValue];
    if (self)
    {
        NSNumber *parentIdNumber = [NSNumber numberWithInt:[parentId intValue]];
        NSNumber *sequenceNumber = [NSNumber numberWithInt:[sequence intValue]];
        
        self.parentId = parentIdNumber;
        self.sequence = sequenceNumber;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ ParentID: %@ Sequence: %@", super.description, self.parentId, self.sequence];
}

@end

// Sensor line point.
@implementation SensorLinePoint

- (id) initWithLat:(NSNumber *)latitudeValue long:(NSNumber *)longitudeValue alt:(NSNumber *)altitudeValue
          parentId:(NSNumber *)parentId sequence:(NSNumber *)sequence
     cableDistance:(NSNumber *)cableDistance perimeterDistance:(NSNumber *)perimeterDistance
{
    self = [super initWithLat:latitudeValue long:longitudeValue alt:altitudeValue parentId:parentId sequence:sequence];
    
    if (self)
    {
        self.cableDistance = cableDistance;
        self.perimeterDistance = perimeterDistance;
    }
    return self;
}

- (id) initWithLatStr:(NSString *)latitudeValue longStr:(NSString *)longitudeValue altStr:(NSString *)altitudeValue
          parentIdStr:(NSString *)parentId sequenceStr:(NSString *)sequence
     cableDistanceStr:(NSString *)cableDistance perimeterDistanceStr:(NSString *)perimeterDistance
{
    self = [super initWithLatStr:latitudeValue longStr:longitudeValue altStr:altitudeValue
                     parentIdStr:parentId sequenceStr:sequence];
    if (self)
    {
        NSNumber *cableDistNumber = [NSNumber numberWithDouble:[cableDistance doubleValue]];
        NSNumber *perimDistNumber = [NSNumber numberWithDouble:[perimeterDistance doubleValue]];
        
        self.cableDistance = cableDistNumber;
        self.perimeterDistance = perimDistNumber;
    }
    return self;

}
@end

