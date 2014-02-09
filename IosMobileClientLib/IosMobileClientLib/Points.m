//
//  Points.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "Points.h"

@implementation CamsGeoPoint

- (id) initWithPeter
{
    self = [super init];
    if (self != nil)
    {
        
    }
    return self;
}

- (id) initWithLatLongAlt:(NSNumber *)latitudeValue long:(NSNumber *)longitudeValue alt:(NSNumber *)altitudeValue
{
    //self = [self initWithLatLong:latitudeValue long:longitudeValue];
    if (self != NULL)
    {
        self.altitude = altitudeValue;
    }
    return self;
}

- (NSString *) toString
{
    return [NSString stringWithFormat:@"Lat: %@ Long: %@ Alt: %@", self.latitude, self.longitude, self.altitude];
}

@end


@implementation ZoneLinePoint

@end

@implementation SensorLinePoint

@end

