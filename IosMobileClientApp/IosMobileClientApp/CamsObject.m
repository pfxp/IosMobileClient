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

- (id) initWithAllValues:(BOOL)conn description:(NSString *)desc hostname:(NSString *)host
ctrlid:(NSNumber *)cId locator:(BOOL)loc name:(NSString*)nm
{
    self = [super init];
    if (self)
    {
        [self setConnected:conn];
        [self setControllerDescription:desc];
        [self setHostname:host];
        [self setCtrlId:cId];
        [self setLocator:loc];
        [self setName:nm];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@" Name=%@ Desc=%@ Conn=%@ Hostname=%@ CtrlID=%@ Locator=%@", self.name, self.controllerDescription, self.connected ? @"YES" : @"NO",
            self.hostname, self.ctrlId, self.locator ? @"YES" : @"NO"];
}

- (void) doSomething
{
    
}

@end

@implementation Zone

@end

