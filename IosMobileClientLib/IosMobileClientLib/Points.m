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

+ (CLLocationCoordinate2D) convertCamsGeoPointToCoordinate:(CamsGeoPoint*)camsGeoPoint
{
    CLLocationCoordinate2D coord;
    coord.latitude = [camsGeoPoint.latitude doubleValue];
    coord.longitude = [camsGeoPoint.longitude doubleValue];
    return coord;
}

@end

// Zone line point.
@implementation ZoneLinePoint

- (id) initWithLat:(NSNumber *)latitudeValue long:(NSNumber *)longitudeValue alt:(NSNumber *)altitudeValue
          pointId:(NSNumber *)pointId sequence:(NSNumber *)sequence
{
    self = [super initWithLat:latitudeValue long:longitudeValue alt:altitudeValue];
    if (self)
    {
        _pointId = pointId;
        _sequence = sequence;
    }
    return self;
}

- (id) initWithLatStr:(NSString *)latitudeValue longStr:(NSString *)longitudeValue altStr:(NSString *)altitudeValue
          pointIdStr:(NSString *)pointId sequenceStr:(NSString *)sequence
{
    self = [super initWithLatStr:latitudeValue longStr:longitudeValue altStr:altitudeValue];
    if (self)
    {
        NSNumber *pointIdNumber = [NSNumber numberWithInt:[pointId intValue]];
        NSNumber *sequenceNumber = [NSNumber numberWithInt:[sequence intValue]];
        
        _pointId = pointIdNumber;
        _sequence = sequenceNumber;
    }
    return self;
}

- (NSString *)description {
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendFormat:@"%@ PointID: %@ Sequence: %@\n", [super description], [self pointId], [self sequence]];
    return result;
}

@end

// Sensor line point.
@implementation SensorLinePoint

- (id) initWithLat:(NSNumber *)latitudeValue long:(NSNumber *)longitudeValue alt:(NSNumber *)altitudeValue
          pointId:(NSNumber *)pointId sequence:(NSNumber *)sequence
     cableDistance:(NSNumber *)cableDistance perimeterDistance:(NSNumber *)perimeterDistance
{
    self = [super initWithLat:latitudeValue long:longitudeValue alt:altitudeValue pointId:pointId sequence:sequence];
    
    if (self)
    {
        _cableDistance = cableDistance;
        _perimeterDistance = perimeterDistance;
    }
    return self;
}

- (id) initWithLatStr:(NSString *)latitudeValue longStr:(NSString *)longitudeValue altStr:(NSString *)altitudeValue
          pointIdStr:(NSString *)pointId sequenceStr:(NSString *)sequence
     cableDistanceStr:(NSString *)cableDistance perimeterDistanceStr:(NSString *)perimeterDistance
{
    self = [super initWithLatStr:latitudeValue longStr:longitudeValue altStr:altitudeValue
                     pointIdStr:pointId sequenceStr:sequence];
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

