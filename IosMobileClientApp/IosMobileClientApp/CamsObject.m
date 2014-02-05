//
//  CamsObject.m
//  MobileClientLibrary
//
//  Created by Peter Pellegrini on 5/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "CamsObject.h"

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


@implementation Map

@end



@implementation ZoneLinePoint

@end

@implementation SensorLinePoint

@end

@implementation Sensor

@end

@implementation Controller

@end

@implementation Zone

@end

