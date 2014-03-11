//
//  CamsObjectRepository.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalSettings.h"

@class Controller;
@class Sensor;
@class Zone;
@class ZoneEvent;
@class Map;
@class CamsGeoPoint;

@interface CamsObjectRepository : NSObject

@property (readwrite) NSMutableDictionary *controllers;
@property (readwrite) NSMutableDictionary *sensors;
@property (readwrite) NSMutableDictionary *zones;
@property (readwrite) NSMutableDictionary *maps;
@property (readwrite) NSMutableDictionary *zoneEvents;

-(void) parseJsonDictionary:(NSDictionary *)dict;
-(void) parseJsonDictionary:(NSDictionary *)dict command:(CamsWsRequest) req;
-(ZoneEvent*) getZoneEventOrderedByTimeDesc:(int) index;
-(Zone *) getZoneById:(NSNumber *)zoneId;
-(Map *)getMapByIndex:(int) index;

+ (Controller *) parseControllerJsonDictionary:(NSDictionary *) dict;
+ (Sensor *) parseSensorJsonDictionary:(NSDictionary *) dict;
+ (Zone *) parseZoneJsonDictionary:(NSDictionary *) dict;
+ (Map *) parseMapJsonDictionary:(NSDictionary *) dict;
+ (ZoneEvent *) parseZoneEventJsonDictionary:(NSDictionary *) dict;
+ (CamsGeoPoint *) parseCamsGeoPointDictionary:(NSDictionary *) dict;

@end
