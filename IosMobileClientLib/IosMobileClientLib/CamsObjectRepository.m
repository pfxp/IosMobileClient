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
-(CamsWsRequest) parseJsonDictionary:(NSDictionary *)dict
{
    if (dict==nil)
    {
        NSLog(@"Dictionary passed to parseJsonDictionary is null.");
        return Unknown;
    }
    
    if ([dict objectForKey:@"GetControllersResult"] != nil)
        return[self parseJsonDictionary:dict command:GetControllers];
    else if ([dict objectForKey:@"GetSensorsResult"] != nil)
        return [self parseJsonDictionary:dict command:GetSensors];
    else if ([dict objectForKey:@"GetZonesResult"] != nil)
        return [self parseJsonDictionary:dict command:GetZones];
    else if ([dict objectForKey:@"GetMapsResult"] != nil)
        return [self parseJsonDictionary:dict command:GetMaps];
    else if ([dict objectForKey:@"GetZoneEventsResult"] != nil)
        return [self parseJsonDictionary:dict command:GetZoneEvents];
    else
    {
        NSLog(@"UNKNOWN Parsing JSON dictionary. %@", dict);
        return Unknown;
    }
}



//
// Parses the JSON dictionary. Invoked when the NSURLSessionDataRequest finishes.
// Some tasks, such as when the APNS token is set do not require a response.
// Outputs the first object to the Console window.
//
-(CamsWsRequest) parseJsonDictionary:(NSDictionary *)dict command:(CamsWsRequest)req
{
    NSArray *jsonArray;
    bool alreadyShownLogMessage=false;
    
    switch(req)
    {
        case GetControllers:
            jsonArray = [dict objectForKey:@"GetControllersResult"];
            if (!jsonArray)
                return Unknown;
            
            [self.controllers removeAllObjects];
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
            return GetControllers;
            break;
            
        case GetSensors:
            jsonArray = [dict objectForKey:@"GetSensorsResult"];
            if (!jsonArray)
                return Unknown;
            
            [self.sensors removeAllObjects];
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
            return GetSensors;
            break;
            
        case GetZones:
            jsonArray = [dict objectForKey:@"GetZonesResult"];
            
            if (!jsonArray)
                return Unknown;
            
            [self.zones removeAllObjects];
            for (NSDictionary *zoneDict in jsonArray)
            {
                Zone *zone = [CamsObjectRepository parseZoneJsonDictionary:zoneDict];
                
                if (!alreadyShownLogMessage)
                    NSLog(@"%@", zone);
                
                alreadyShownLogMessage=true;
                if (zone)
                    self.zones[[zone zoneId]] = zone;
            }
            return GetZones;
            break;
            
        case GetMaps:
            jsonArray = [dict objectForKey:@"GetMapsResult"];
            
            if (!jsonArray)
                return Unknown;
            
            [self.maps removeAllObjects];
            for (NSDictionary *item in jsonArray)
            {
                Map *map = [CamsObjectRepository parseMapJsonDictionary:item];
                
                if (!alreadyShownLogMessage)
                    NSLog(@"%@", map);
                
                alreadyShownLogMessage=true;
                if (map)
                    self.maps[[map mapId]] = map;
            }
            return GetMaps;
            break;
            
        case GetZoneEvents:
            jsonArray = [dict objectForKey:@"GetZoneEventsResult"];
            
            if (!jsonArray)
                return Unknown;
            
            [self.zoneEvents removeAllObjects];
            for (NSDictionary *zoneEventDict in jsonArray)
            {
                ZoneEvent *zoneEvent = [CamsObjectRepository parseZoneEventJsonDictionary:zoneEventDict];
                
                if (!alreadyShownLogMessage)
                    NSLog(@"%@", zoneEvent);
                
                alreadyShownLogMessage=true;
                if (zoneEvent)
                    self.zoneEvents[[zoneEvent eventId]] = zoneEvent;
            }
            return GetZoneEvents;
            break;
            
        case PostAPNSToken:
            NSLog(@"APNS: %@", @"Set the APNS token.");
            return PostAPNSToken;
            break;
            
        case PostAcknowledgeAlarm:
            NSLog(@"PostAcknowledgeAlarm: %@", @"Acknowledge an alarm.");
            return PostAcknowledgeAlarm;
            break;
            
        default:
            NSLog(@"Unknown command.");
            return Unknown;
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
    
    return [[Controller alloc] initWithAllValues:connectedAsBool
                                     description:description
                                        hostname:hostname
                                          ctrlid:idNumber
                                         locator:locatorAsBool
                                            name:name];
}



//
// Returns a sensor from a JSON dictionary. The Sensor constructor will order the SensorLinePoints by sequence number.
//
+ (Sensor *) parseSensorJsonDictionary:(NSDictionary *) dict
{
    // Sensor properties.
    NSString *description = [dict objectForKey:@"Description"];
    NSString *sensorId = [dict objectForKey:@"SensorId"];
    NSString *channelNumber = [dict objectForKey:@"ChannelNumber"];
    NSString *sensorGuid = [dict objectForKey:@"SensorGuid"];
    NSString *pointCount = [dict objectForKey:@"PointCount"];
    NSNumber *sensorIdNumber = [NSNumber numberWithInteger:[sensorId integerValue]];
    NSNumber *channelNumberNumber = [NSNumber numberWithInteger:[channelNumber integerValue]];
    
    // Sensor line point properties.
    NSMutableString *latitude;
    NSMutableString *longitude;
    NSMutableString *altitude;
    NSMutableString *pointId;
    NSMutableString *sequence;
    NSMutableString *cableDistance;
    NSMutableString *perimeterDistance;
    NSMutableArray *pointsForSensor = [NSMutableArray arrayWithCapacity:[pointCount intValue]];
    
    // Read each sensor line point.
    NSArray *pointsJSONArray = [dict objectForKey:@"Points"];
    for (NSDictionary *pointDict in pointsJSONArray)
    {
        latitude = [pointDict objectForKey:@"Lat"];
        longitude = [pointDict objectForKey:@"Long"];
        altitude = [pointDict objectForKey:@"Alt"];
        pointId = [pointDict objectForKey:@"PointId"];
        sequence = [pointDict objectForKey:@"Seq"];
        cableDistance = [pointDict objectForKey:@"CabDist"];
        perimeterDistance = [pointDict objectForKey:@"PerDist"];
        
        SensorLinePoint *sensorLinePoint = [[SensorLinePoint alloc] initWithLatStr:latitude
                                                                           longStr:longitude
                                                                            altStr:altitude
                                                                        pointIdStr:pointId
                                                                       sequenceStr:sequence
                                                                  cableDistanceStr:cableDistance
                                                              perimeterDistanceStr:perimeterDistance];
        
        [pointsForSensor addObject:sensorLinePoint];
    }
    
    // Get the bounding box
    CamsGeoPoint *boundsTopLeftPoint = [CamsObjectRepository parseCamsGeoPointDictionary:[dict objectForKey:@"BoundsTopLeft"]];
    CamsGeoPoint *boundsTopRightPoint = [CamsObjectRepository parseCamsGeoPointDictionary:[dict objectForKey:@"BoundsTopRight"]];
    CamsGeoPoint *boundsBottomLeftPoint = [CamsObjectRepository parseCamsGeoPointDictionary:[dict objectForKey:@"BoundsBottomLeft"]];
    CamsGeoPoint *boundsBottomRightPoint = [CamsObjectRepository parseCamsGeoPointDictionary:[dict objectForKey:@"BoundsBottomRight"]];
    CamsGeoPoint *centerPoint = [CamsObjectRepository parseCamsGeoPointDictionary:[dict objectForKey:@"CenterPoint"]];
    
    return [[Sensor alloc] initWithDesc:description
                                         sensorid:sensorIdNumber
                                    channelNumber:channelNumberNumber
                                       sensorGuid:sensorGuid
                                     sensorPoints:pointsForSensor
                                    topLeftCorner:boundsTopLeftPoint
                                   topRightCorner:boundsTopRightPoint
                                 bottomLeftCorner:boundsBottomLeftPoint
                                bottomRightCorner:boundsBottomRightPoint
                                      centerPoint:centerPoint];
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
    
    return [[Zone alloc] initWithZoneId:zoneIdNumber name:name zoneDescription:description];
}



//
// Parses a map
//
+ (Map *) parseMapJsonDictionary:(NSDictionary *) dict
{
    NSString *displayName = [dict objectForKey:@"DisplayName"];
    NSString *idString = [dict objectForKey:@"Id"];
    
    CamsGeoPoint *topLeftPoint = [CamsObjectRepository parseCamsGeoPointDictionary:[dict objectForKey:@"TopLeftCorner"]];
    CamsGeoPoint *topRightPoint = [CamsObjectRepository parseCamsGeoPointDictionary:[dict objectForKey:@"TopRightCorner"]];
    CamsGeoPoint *bottomLeftPoint = [CamsObjectRepository parseCamsGeoPointDictionary:[dict objectForKey:@"BottomLeftCorner"]];
    CamsGeoPoint *bottomRightPoint = [CamsObjectRepository parseCamsGeoPointDictionary:[dict objectForKey:@"BottomRightCorner"]];
    
    return [[Map alloc] initWithDisplayName:displayName
                                          mapId:idString
                                        topLeft:topLeftPoint
                                       topRight:topRightPoint
                                     bottomLeft:bottomLeftPoint
                                bottomRight:bottomRightPoint];
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
    
    NSNumber *controllerId = [NSNumber numberWithInt:[controllerIdAsString intValue]];
    NSNumber *sensorId = [NSNumber numberWithInt:[sensorIdAsString intValue]];
    NSNumber *zoneId = [NSNumber numberWithInt:[zoneIdAsString intValue]];
    NSNumber *epoch = [NSNumber numberWithLongLong:[eventTimeUtc1970sec longLongValue]];
    NSDate *eventTime = [NSDate dateWithTimeIntervalSince1970:[epoch doubleValue]];
    NSNumber *eventId = [NSNumber numberWithInteger:[eventIdAsString integerValue]];
    
    NSDictionary *locInfoDict = [dict objectForKey:@"LocInfo"];
    NSString *cableDistance = [locInfoDict objectForKey:@"CableDist"];
    
    CamsGeoPoint *locationGeoPoint = [CamsObjectRepository parseCamsGeoPointDictionary:[locInfoDict objectForKey:@"Location"]];
    
    NSString *perimeterDistAsString =[locInfoDict objectForKey:@"PerimDist"];
    NSString *locationWeightAsString =[locInfoDict objectForKey:@"LocWeight"];
    NSString *locationWeightThresholdAsString =[locInfoDict objectForKey:@"LocWeightThresh"];
    
    NSNumber *cableDistAsDouble = [NSNumber numberWithDouble:[cableDistance doubleValue]];
    NSNumber *perimeterDistAsDouble = [NSNumber numberWithDouble:[perimeterDistAsString doubleValue]];
    NSNumber *locationWeightAsDouble = [NSNumber numberWithDouble:[locationWeightAsString doubleValue]];
    NSNumber *locationWeightThresholdAsDouble = [NSNumber numberWithDouble:[locationWeightThresholdAsString doubleValue]];
    
    ZoneEvent *zoneEvent = [[ZoneEvent alloc] initWithEventId:eventId
                                                    eventTime:eventTime
                                                 acknowledged:[acknowledged boolValue]
                                                       active:[active boolValue]
                                                      dynamic:[dynamic boolValue]
                                                       zoneId:zoneId
                                                 controllerId:controllerId
                                                     sensorId:sensorId
                                                cableDistance:cableDistAsDouble
                                                 locationGeoPoint:locationGeoPoint
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
    
    // Sort Zone events in reverse chronological order.
    NSMutableArray *mutableIntrusions = [[NSMutableArray alloc]  initWithArray:intrusions];
    [mutableIntrusions sortUsingComparator:^(id obj1, id obj2) {
        ZoneEvent *event1 = (ZoneEvent *)obj1;
        ZoneEvent *event2 = (ZoneEvent *)obj2;
        NSDate *eventDate1 = [event1 eventTimeUtc];
        NSDate *eventDate2 = [event2 eventTimeUtc];
        return [eventDate2 compare:eventDate1];
    }];
    
    return [mutableIntrusions objectAtIndex:index];
}

//
// Get a zone by its ZoneId.
-(Zone *) getZoneById:(NSNumber *)zoneId
{
    Zone *zone = [_zones objectForKey:zoneId];
    return zone;
}

//
// Get maps by an arbitrary index. This is not really correct.
// When the CAMS SDK has the ability to retrieve maps, this will change.
//
-(Map *)getMapByIndex:(int) index
{
    NSArray *mapList = [_maps allValues];
    
    if ([mapList count] == 0 || index > ([mapList count] -1 ))
        return nil;
    
    // Sort maps alphabetically.
    NSMutableArray *mutableMaps = [[NSMutableArray alloc]  initWithArray:mapList];
    
    [mutableMaps sortUsingComparator:^(id obj1, id obj2) {
        Map *map1 = (Map *)obj1;
        Map *map2 = (Map *)obj2;
        NSString *mapName1 = [map1 displayName];
        NSString *mapName2 = [map2 displayName];
        return [mapName1 compare:mapName2];
    }];
    
    return [mutableMaps objectAtIndex:index];
}

@end
