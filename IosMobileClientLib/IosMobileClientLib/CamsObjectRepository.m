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

//
// Parses the JSON dictionary.
//
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
        NSLog(@"UNKNOWN Parsing JSON dictionary. %@", dict);
}

//
// Parses the JSON dictionary. Invoked when the NSURLSessionDataRequest finishes.
// Some tasks, such as when the APNS token is set do not require a response.
//
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
                Zone *zone = [CamsObjectRepository parseZoneJsonDictionary:zoneDict];
                
                if (!alreadyShownLogMessage)
                    NSLog(@"%@", zone);
                
                alreadyShownLogMessage=true;
                
                if (zone)
                    self.zones[[zone zoneId]] = zone;
            }
            break;
            
        case GetMaps:
            jsonArray = [dict objectForKey:@"GetMapsResult"];
            
            if (!jsonArray)
                return;
            
            for (NSDictionary *item in jsonArray)
            {
                Map *map = [CamsObjectRepository parseMapJsonDictionary:item];
                
                if (!alreadyShownLogMessage)
                    NSLog(@"%@", map);
                
                alreadyShownLogMessage=true;
                
                if (map)
                    self.maps[[map mapId]] = map;
            }
            break;
            
        case GetZoneEvents:
            jsonArray = [dict objectForKey:@"GetZoneEventsResult"];
            
            if (!jsonArray)
                return;
            
            for (NSDictionary *zoneEventDict in jsonArray)
            {
                ZoneEvent *zoneEvent = [CamsObjectRepository parseZoneEventJsonDictionary:zoneEventDict];
                
                if (!alreadyShownLogMessage)
                    NSLog(@"%@", zoneEvent);
                
                alreadyShownLogMessage=true;
                
                if (zoneEvent)
                    self.zoneEvents[[zoneEvent eventId]] = zoneEvent;
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

//
// Parses a zone.
//
+ (Zone *) parseZoneJsonDictionary:(NSDictionary *) dict
{
    NSString *zoneIdAsString = [dict objectForKey:@"ZoneId"];
    NSString *name = [dict objectForKey:@"Name"];
    NSString *description = [dict objectForKey:@"Description"];
    NSNumber *zoneIdNumber = [NSNumber numberWithInteger:[zoneIdAsString integerValue]];
    
    Zone *zone = [[Zone alloc] initWithZoneId:zoneIdNumber name:name zoneDescription:description];
    return zone;
}



//
// Parses a map
//
+ (Map *) parseMapJsonDictionary:(NSDictionary *) dict
{
    NSString *displayName = [dict objectForKey:@"DisplayName"];
    NSString *idString = [dict objectForKey:@"Id"];
    
    NSDictionary *topLeftCorner = [dict objectForKey:@"TopLeftCorner"];
    CamsGeoPoint *topLeftPoint = [CamsObjectRepository parseCamsGeoPointDictionary:topLeftCorner];
    
    NSDictionary *topRightCorner = [dict objectForKey:@"TopRightCorner"];
    CamsGeoPoint *topRightPoint = [CamsObjectRepository parseCamsGeoPointDictionary:topRightCorner];
    
    NSDictionary *bottomLeftCorner = [dict objectForKey:@"BottomLeftCorner"];
    CamsGeoPoint *bottomLeftPoint = [CamsObjectRepository parseCamsGeoPointDictionary:bottomLeftCorner];
    
    NSDictionary *bottomRightCorner = [dict objectForKey:@"BottomRightCorner"];
    CamsGeoPoint *bottomRightPoint = [CamsObjectRepository parseCamsGeoPointDictionary:bottomRightCorner];
    
    Map *map = [[Map alloc] initWithDisplayName:displayName
                                          mapId:idString
                                        topLeft:topLeftPoint
                                       topRight:topRightPoint
                                     bottomLeft:bottomLeftPoint
                                    bottomRight:bottomRightPoint];

    return map;
}

//
// Parses a zone event.
//
+ (ZoneEvent *) parseZoneEventJsonDictionary:(NSDictionary *) dict
{
    NSString *eventIdAsString = [dict objectForKey:@"Id"];
    NSString *eventTimeUtc1970sec = [dict objectForKey:@"TimeUtc1970sec"];
    NSString *acknowledged = [dict objectForKey:@"Acked"];
    NSString *active = [dict objectForKey:@"Active"];
    NSString *dynamic = [dict objectForKey:@"Dynamic"];
    NSString *controllerIdAsString = [dict objectForKey:@"CtrlId"];
    NSString *sensorIdAsString = [dict objectForKey:@"SensorId"];
    NSString *zoneIdAsString = [dict objectForKey:@"ZoneId"];
    
    int controllerId = [controllerIdAsString intValue];
    int sensorId = [sensorIdAsString intValue];
    int zoneId = [zoneIdAsString intValue];
    
    NSNumber *epoch = [NSNumber numberWithLongLong:[eventTimeUtc1970sec longLongValue]];
    
    NSDate *eventTime = [NSDate dateWithTimeIntervalSince1970:[epoch doubleValue]];
    NSNumber *eventId = [NSNumber numberWithInteger:[eventIdAsString integerValue]];
    
    NSDictionary *locInfoDict = [dict objectForKey:@"LocInfo"];
    NSString *cableDistance = [locInfoDict objectForKey:@"CableDist"];
    double cableDistAsDouble = [cableDistance doubleValue];
    
    NSDictionary *locationDict = [locInfoDict objectForKey:@"Location"];
    CamsGeoPoint *locationPoint = [CamsObjectRepository parseCamsGeoPointDictionary:locationDict];
    
    NSString *perimeterDistAsString =[locInfoDict objectForKey:@"PerimDist"];
    NSString *locationWeightAsString =[locInfoDict objectForKey:@"LocWeight"];
    NSString *locationWeightThresholdAsString =[locInfoDict objectForKey:@"LocWeightThresh"];
    
    double perimeterDistAsDouble = [perimeterDistAsString doubleValue];
    double locationWeightAsDouble = [locationWeightAsString doubleValue];
    double locationWeightThresholdAsDouble = [locationWeightThresholdAsString doubleValue];
    
    ZoneEvent *zoneEvent = [[ZoneEvent alloc] initWithEventId:eventId
                                                    eventTime:eventTime
                                                 acknowledged:[acknowledged boolValue]
                                                       active:[active boolValue]
                                                      dynamic:[dynamic boolValue]
                                                       zoneId:zoneId
                                                   controllerId:controllerId
                                                     sensorId:sensorId
                                                cableDistance:cableDistAsDouble
                                                 camsGeoPoint:locationPoint
                                            perimeterDistance:perimeterDistAsDouble
                                               locationWeight:locationWeightAsDouble
                                      locationWeightThreshold:locationWeightThresholdAsDouble];

    
    return zoneEvent;
}

//
// Parses CamsGeoPoint
//
+ (CamsGeoPoint *) parseCamsGeoPointDictionary:(NSDictionary *) dict
{
    return [[CamsGeoPoint alloc] initWithLatStr:[dict objectForKey:@"Lat"]
                                        longStr:[dict objectForKey:@"Long"]
                                         altStr:[dict objectForKey:@"Alt"]];
}

//
// Returns zone event using a 0-based index in reverse chronological order.
//
-(ZoneEvent*) getZoneEventOrderedByTimeDesc:(int) index
{
    NSArray *intrusions = [_zoneEvents allValues];
    if ([intrusions count] == 0 || index > ([intrusions count] -1 ))
        return nil;
    
    NSMutableArray *mutableIntrusions = [[NSMutableArray alloc]  initWithArray:intrusions];
    
    [mutableIntrusions sortUsingComparator:^(id obj1, id obj2) {
        
        ZoneEvent *event1 = (ZoneEvent *)obj1;
        ZoneEvent *event2 = (ZoneEvent *)obj2;
        
        NSDate *date1 = [event1 eventTimeUtc];
        NSDate *date2 = [event2 eventTimeUtc];
        
        return [date2 compare:date1];
    }];

    return [mutableIntrusions objectAtIndex:index];
}

-(Zone *) getZoneById:(NSNumber *)zoneId
{
    Zone *zone = [_zones objectForKey:zoneId];
    return zone;
}

@end
