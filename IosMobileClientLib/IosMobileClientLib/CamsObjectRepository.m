//
//  CamsObjectRepository.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "GlobalSettings.h"
#import "CamsObjectRepository.h"
#import "Controller.h"
#import "Sensor.h"
#import "Zone.h"
#import "Points.h"
#import "Map.h"
#import "ZoneEvent.h"


@implementation CamsObjectRepository

- (id) init
{
    self = [super init];
    if (self)
    {
        _controllers = [NSMutableDictionary new];
        _sensors = [NSMutableDictionary new];
        _zones = [NSMutableDictionary new];
        _maps = [NSMutableDictionary new];
        _zoneEvents = [NSMutableDictionary new];
    }
    
    return self;
}

// Parses the JSON dictionary.
-(void) parseJsonDictionary:(NSDictionary *)dict
{
    if (dict==nil)
    {
        NSLog(@"Dictionary passed to parseJsonDictionary is null.");
        return;
    }
    
    if ([dict objectForKey:@"GetControllersResult"] != nil)
        [self parseJsonDictionary:dict command:GetControllers];
    else if ([dict objectForKey:@"GetSensorsResult"] != nil)
        [self parseJsonDictionary:dict command:GetSensors];
    else if ([dict objectForKey:@"GetZonesResult"] != nil)
        [self parseJsonDictionary:dict command:GetZones];
    else if ([dict objectForKey:@"GetMapsResult"] != nil)
        [self parseJsonDictionary:dict command:GetMaps];
    else if ([dict objectForKey:@"GetZoneEventsResult"] != nil)
        [self parseJsonDictionary:dict command:GetZoneEvents];

    else
    {
        NSLog(@"UNKNOWN Parsing JSON dictionary. %@", dict);
    }
}

// Parses the JSON dictionary.
-(void) parseJsonDictionary:(NSDictionary *)dict command:(CamsWsRequest)req
{
    NSArray *jsonArray;
     bool alreadyShownLogMessage=false;
    
    switch(req)
    {
        case GetControllers:
            jsonArray = [dict objectForKey:@"GetControllersResult"];
            if (!jsonArray)
                return;
            
            for (NSDictionary *item in jsonArray)
            {
                Controller *controller = [CamsObjectRepository parseControllerJsonDictionary:item];
                if (controller==nil)
                    continue;
                
                if (!alreadyShownLogMessage)
                    NSLog(@"%@", controller);
                
                alreadyShownLogMessage=true;
                
                if (controller)
                    self.controllers[[controller ctrlId]] = controller;
            }
            break;
            
        case GetSensors:
            jsonArray = [dict objectForKey:@"GetSensorsResult"];
            if (!jsonArray)
                return;
            
            for (NSDictionary *sensorDict in jsonArray)
            {
                Sensor *sensor = [CamsObjectRepository parseSensorJsonDictionary:sensorDict];
                if (sensor==nil)
                    continue;
                
                if (!alreadyShownLogMessage)
                    NSLog(@"%@", sensor);
                
                alreadyShownLogMessage=true;
                
                if (sensor)
                    self.sensors[[sensor sensorId]] = sensor;
            }
            break;
            
        case GetZones:
            jsonArray = [dict objectForKey:@"GetZonesResult"];
            
            if (!jsonArray)
                return;
            
            for (NSDictionary *zoneDict in jsonArray)
            {
                NSString *zoneIdAsString = [zoneDict objectForKey:@"ZoneId"];
                NSString *name = [zoneDict objectForKey:@"Name"];
                NSString *description = [zoneDict objectForKey:@"Description"];
                NSNumber *zoneIdNumber = [NSNumber numberWithInteger:[zoneIdAsString integerValue]];
                
                Zone *zone = [[Zone alloc] initWithZoneId:zoneIdNumber name:name zoneDescription:description];
                
                if (!alreadyShownLogMessage)
                    NSLog(@"%@", zone);
                
                alreadyShownLogMessage=true;
                
                if (zone)
                    self.zones[zoneIdNumber] = zone;
            }
            break;
            
        case GetMaps:
            jsonArray = [dict objectForKey:@"GetMapsResult"];
            
            if (!jsonArray)
                return;
            
            for (NSDictionary *item in jsonArray)
            {
                NSString *displayName = [item objectForKey:@"DisplayName"];
                NSString *idString = [item objectForKey:@"Id"];
                
                NSDictionary *topLeftCorner = [item objectForKey:@"TopLeftCorner"];
                CamsGeoPoint *topLeftPoint = [[CamsGeoPoint alloc] initWithLatStr:[topLeftCorner objectForKey:@"Lat"]
                                                                          longStr:[topLeftCorner objectForKey:@"Long"]
                                                                           altStr:[topLeftCorner objectForKey:@"Alt"]];
                
                NSDictionary *topRightCorner = [item objectForKey:@"TopRightCorner"];
                CamsGeoPoint *topRightPoint = [[CamsGeoPoint alloc] initWithLatStr:[topRightCorner objectForKey:@"Lat"]
                                                                           longStr:[topRightCorner objectForKey:@"Long"]
                                                                            altStr:[topRightCorner objectForKey:@"Alt"]];
                
                NSDictionary *bottomLeftCorner = [item objectForKey:@"BottomLeftCorner"];
                CamsGeoPoint *bottomLeftPoint = [[CamsGeoPoint alloc] initWithLatStr:[bottomLeftCorner objectForKey:@"Lat"]
                                                                             longStr:[bottomLeftCorner objectForKey:@"Long"]
                                                                              altStr:[bottomLeftCorner objectForKey:@"Alt"]];
                
                NSDictionary *bottomRightCorner = [item objectForKey:@"BottomRightCorner"];
                CamsGeoPoint *bottomRightPoint = [[CamsGeoPoint alloc] initWithLatStr:[bottomRightCorner objectForKey:@"Lat"]
                                                                              longStr:[bottomRightCorner objectForKey:@"Long"]
                                                                               altStr:[bottomRightCorner objectForKey:@"Alt"]];
                
                
                Map *map = [[Map alloc] initWithDisplayName:displayName
                                                      mapId:idString
                                                    topLeft:topLeftPoint
                                                   topRight:topRightPoint
                                                 bottomLeft:bottomLeftPoint
                                                bottomRight:bottomRightPoint];
                
                if (!alreadyShownLogMessage)
                    NSLog(@"%@", map);
                
                alreadyShownLogMessage=true;
                
                if (map)
                    self.maps[idString] = map;
            }
            
            break;
            
        case GetZoneEvents:
            jsonArray = [dict objectForKey:@"GetZoneEventsResult"];
            
            if (!jsonArray)
                return;
            
            for (NSDictionary *zoneEventDict in jsonArray)
            {
                NSString *eventIdAsString = [zoneEventDict objectForKey:@"EventId"];
                NSString *eventTimeUtc1970sec = [zoneEventDict objectForKey:@"EventTimeUtc1970sec"];
                NSString *acknowledged = [zoneEventDict objectForKey:@"Acknowledged"];
                NSString *active = [zoneEventDict objectForKey:@"Active"];
                NSString *dynamic = [zoneEventDict objectForKey:@"Dynamic"];
                NSDictionary *controllerDict = [zoneEventDict objectForKey:@"Controller"];
                NSDictionary *sensorDict = [zoneEventDict objectForKey:@"Sensor"];
                
                Controller *controller = [CamsObjectRepository parseControllerJsonDictionary:controllerDict];
                Sensor *sensor = [CamsObjectRepository parseSensorJsonDictionary:sensorDict];
                
                NSNumber *epoch = [NSNumber numberWithLongLong:[eventTimeUtc1970sec longLongValue]];
                
                NSDate *eventTime = [NSDate dateWithTimeIntervalSince1970:[epoch doubleValue]];
                NSNumber *eventId = [NSNumber numberWithInteger:[eventIdAsString integerValue]];
                ZoneEvent *zoneEvent = [[ZoneEvent alloc] initWithEventId:eventId
                                                                eventTime:eventTime
                                                             acknowledged:[acknowledged boolValue]
                                                                   active:[active boolValue]
                                                                  dynamic:[dynamic boolValue]
                                                               controller:controller
                                                                   sensor:sensor];
                
                if (!alreadyShownLogMessage)
                    NSLog(@"%@", zoneEvent);
                
                alreadyShownLogMessage=true;

                if (zoneEvent)
                    self.zoneEvents[eventId] = zoneEvent;
            }
            
            break;
            
        case SetAPNSToken:
            NSLog(@"APNS: %@", @"Set the APNS token.");
            break;
    }
}

#pragma mark CAMS object desierializers
//
// Returns a controller from a JSON dictionary
//
+ (Controller *) parseControllerJsonDictionary:(NSDictionary *) dict
{
    
    NSString *connected = [dict objectForKey:@"Connected"];
    NSString *description = [dict objectForKey:@"Description"];
    NSString *hostname = [dict objectForKey:@"Hostname"];
    NSString *idString = [dict objectForKey:@"Id"];
    NSString *isLocator = [dict objectForKey:@"Locator"];
    NSString *name = [dict objectForKey:@"Name"];
    
    BOOL connectedAsBool = [connected boolValue];
    NSNumber *idNumber = [NSNumber numberWithInteger:[idString integerValue]];
    BOOL locatorAsBool = [isLocator boolValue];
    
    Controller *controller = [[Controller alloc] initWithAllValues:connectedAsBool description:description hostname:hostname
                                                            ctrlid:idNumber locator:locatorAsBool name:name];
    
    return controller;
}

//
// Returns a sensor from a JSON dictionary
//
+ (Sensor *) parseSensorJsonDictionary:(NSDictionary *) dict
{
    NSString *latitude;
    NSString *longitude;
    NSString *altitude;
    NSString *parentId;
    NSString *sequence;
    NSString *cableDistance;
    NSString *perimeterDistance;
    
    NSString *description = [dict objectForKey:@"Description"];
    NSString *sensorId = [dict objectForKey:@"SensorId"];
    NSString *channelNumber = [dict objectForKey:@"ChannelNumber"];
    NSString *sensorGuid = [dict objectForKey:@"SensorGuid"];
    NSString *pointCount = [dict objectForKey:@"PointCount"];
    NSNumber *sensorIdNumber = [NSNumber numberWithInteger:[sensorId integerValue]];
    NSNumber *channelNumberNumber = [NSNumber numberWithInteger:[channelNumber integerValue]];
    
    NSMutableArray *pointsForSensor = [NSMutableArray arrayWithCapacity:[pointCount intValue]];
    
    NSArray *pointsJSONArray = [dict objectForKey:@"Points"];
    for (NSDictionary *pointDict in pointsJSONArray)
    {
        latitude = [pointDict objectForKey:@"Lat"];
        longitude = [pointDict objectForKey:@"Long"];
        altitude = [pointDict objectForKey:@"Alt"];
        parentId = [pointDict objectForKey:@"ParentId"];
        sequence = [pointDict objectForKey:@"Seq"];
        cableDistance = [pointDict objectForKey:@"CabDist"];
        perimeterDistance = [pointDict objectForKey:@"PerDist"];
        
        SensorLinePoint *sensorLinePoint = [[SensorLinePoint alloc] initWithLatStr:latitude longStr:longitude altStr:altitude parentIdStr:parentId sequenceStr:sequence cableDistanceStr:cableDistance perimeterDistanceStr:perimeterDistance];
        
        [pointsForSensor addObject:sensorLinePoint];
    }
    
    Sensor *sensor = [[Sensor alloc] initWithDesc:description sensorid:sensorIdNumber channelNumber:channelNumberNumber sensorGuid:sensorGuid points:pointsForSensor];
    
    return sensor;
}


@end
