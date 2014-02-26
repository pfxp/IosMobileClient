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
        _latitude = latitudeValue;
        _longitude = longitudeValue;
        _altitude = altitudeValue;
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
    return [NSString stringWithFormat:@"(Lat: %@ Long: %@ Alt: %@)", self.latitude, self.longitude, self.altitude];
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
        _parentId = parentId;
        _sequence = sequence;
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
        
        _parentId = parentIdNumber;
        _sequence = sequenceNumber;
    }
    return self;
}

- (NSString *)description {
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendFormat:@"%@ ParentID: %@ Sequence: %@\n", [super description], [self parentId], [self sequence]];
    return result;
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
        _cableDistance = cableDistance;
        _perimeterDistance = perimeterDistance;
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
        
        _cableDistance = cableDistNumber;
        _perimeterDistance = perimDistNumber;
    }
    return self;
}

- (NSString *)description {
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendFormat:@"%@ Cable distance: %d Perimeter distance: %d\n", [super description], [[self cableDistance] intValue], [[self perimeterDistance] intValue]];
    return result;
}

@end

