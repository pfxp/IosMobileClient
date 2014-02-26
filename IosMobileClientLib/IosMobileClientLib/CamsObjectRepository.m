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
    else
    {
        NSLog(@"UNKNOWN Parsing JSON dictionary. %@", dict);
    }
}

// Parses the JSON dictionary.
-(void) parseJsonDictionary:(NSDictionary *)dict command:(CamsWsRequest)req
{
    NSArray *jsonArray;
    NSString *latitude;
    NSString *longitude;
    NSString *altitude;
    NSString *parentId;
    NSString *sequence;
    NSString *cableDistance;
    NSString *perimeterDistance;
    bool alreadyShownLogMessage=false;
    
    switch(req)
    {
        case GetControllers:
            
            jsonArray = [dict objectForKey:@"GetControllersResult"];
            if (!jsonArray)
                return;
            
            for (NSDictionary *item in jsonArray)
            {
                NSString *connected = [item objectForKey:@"Connected"];
                NSString *description = [item objectForKey:@"Description"];
                NSString *hostname = [item objectForKey:@"Hostname"];
                NSString *idString = [item objectForKey:@"Id"];
                NSString *isLocator = [item objectForKey:@"Locator"];
                NSString *name = [item objectForKey:@"Name"];
                
                BOOL connectedAsBool = [connected boolValue];
                NSNumber *idNumber = [NSNumber numberWithInteger:[idString integerValue]];
                BOOL locatorAsBool = [isLocator boolValue];
                Controller *controller = [[Controller alloc] initWithAllValues:connectedAsBool description:description hostname:hostname
                                                                        ctrlid:idNumber locator:locatorAsBool name:name];
                if (!alreadyShownLogMessage)
                    NSLog(@"%@", controller);
                
                alreadyShownLogMessage=true;
                
                if (controller)
                    self.controllers[idNumber] = controller;
            }
            
            break;
            
        case GetSensors:
            
            jsonArray = [dict objectForKey:@"GetSensorsResult"];
            
            if (!jsonArray)
                return;
            
            for (NSDictionary *sensorItem in jsonArray)
            {
                NSString *description = [sensorItem objectForKey:@"Description"];
                NSString *sensorId = [sensorItem objectForKey:@"SensorId"];
                NSString *channelNumber = [sensorItem objectForKey:@"ChannelNumber"];
                NSString *sensorGuid = [sensorItem objectForKey:@"SensorGuid"];
                NSString *pointCount = [sensorItem objectForKey:@"PointCount"];
                NSNumber *sensorIdNumber = [NSNumber numberWithInteger:[sensorId integerValue]];
                NSNumber *channelNumberNumber = [NSNumber numberWithInteger:[channelNumber integerValue]];
                
                NSMutableArray *pointsForSensor = [NSMutableArray arrayWithCapacity:[pointCount intValue]];
                
                NSArray *pointsJSONArray = [sensorItem objectForKey:@"Points"];
                for (NSDictionary *pointItem in pointsJSONArray)
                {
                    latitude = [pointItem objectForKey:@"Lat"];
                    longitude = [pointItem objectForKey:@"Long"];
                    altitude = [pointItem objectForKey:@"Alt"];
                    parentId = [pointItem objectForKey:@"ParentId"];
                    sequence = [pointItem objectForKey:@"Seq"];
                    cableDistance = [pointItem objectForKey:@"CabDist"];
                    perimeterDistance = [pointItem objectForKey:@"PerDist"];
                    
                    SensorLinePoint *sensorLinePoint = [[SensorLinePoint alloc] initWithLatStr:latitude longStr:longitude altStr:altitude parentIdStr:parentId sequenceStr:sequence cableDistanceStr:cableDistance perimeterDistanceStr:perimeterDistance];
                    
                    [pointsForSensor addObject:sensorLinePoint];
                }
                
                Sensor *sensor = [[Sensor alloc] initWithDesc:description sensorid:sensorIdNumber channelNumber:channelNumberNumber sensorGuid:sensorGuid points:pointsForSensor];
                
                if (!alreadyShownLogMessage)
                    NSLog(@"%@", sensor);
                
                alreadyShownLogMessage=true;

                if (sensor)
                    self.sensors[sensorIdNumber] = sensor;
            }
            
            
            break;
            
        case GetZones:
            jsonArray = [dict objectForKey:@"GetZonesResult"];
            
            if (!jsonArray)
                return;
            
            for (NSDictionary *item in jsonArray)
            {
                NSString *zoneIdAsString = [item objectForKey:@"ZoneId"];
                NSString *name = [item objectForKey:@"Name"];
                NSString *description = [item objectForKey:@"Description"];
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
        case SetAPNSToken:
            NSLog(@"APNS: %@", @"Set the APNS token.");
            break;
    }
}

@end
